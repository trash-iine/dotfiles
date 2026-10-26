// apps: right-sidebar panel listing running apps across all workspaces,
// grouped by app instead of by workspace/tab: Claude Code sessions (from
// cmux's agent tracking, with live status) and Neovim instances (from the
// terminal title, which nvim sets when `title` is on: "file (dir) - Nvim").
// Click a row to jump to the workspace and focus that terminal.
// Based on Examples/CustomSidebars/panel-subagents.js.
//   cmux right-sidebar set custom apps

const [query, setQuery] = signal("");

const STATUS = {
  needs_input: { color: "#FF9F0A", label: "Needs input", rank: 0 },
  working: { color: "#0A84FF", label: "Working", rank: 1 },
  idle: { color: "#34C759", label: "Idle", rank: 2 },
  ended: { color: "#7f7f7f66", label: "Ended", rank: 3 },
};
const statusOf = (a) => STATUS[a.status] ?? { color: "#7f7f7f66", label: a.status, rank: 9 };

// nvim's default titlestring: "%t%( %M%)%( (%{expand("%:~:h")})%)%a - Nvim"
const NVIM_TITLE = /^(.*?)(?: ([+\-=]+))?(?: \((.*)\))?(?: \(\d+ of \d+\))? - n?vim$/i;

const matches = (...texts) => {
  const q = query().trim().toLowerCase();
  if (!q) return true;
  return texts.some((t) => String(t ?? "").toLowerCase().includes(q));
};

function fmtElapsed(secs) {
  const s = Math.max(0, Math.floor(secs));
  if (s < 60) return s + "s";
  const m = Math.floor(s / 60);
  if (m < 60) return m + "m " + String(s % 60).padStart(2, "0") + "s";
  return Math.floor(m / 60) + "h " + String(m % 60).padStart(2, "0") + "m";
}

function fmtAgo(secs) {
  const s = Math.max(0, Math.floor(secs));
  if (s < 60) return s + "s";
  const m = Math.floor(s / 60);
  if (m < 60) return m + "m";
  const h = Math.floor(m / 60);
  if (h < 24) return h + "h";
  return Math.floor(h / 24) + "d";
}

function timeText(a, epoch) {
  if ((a.status === "working" || a.status === "needs_input") && a.sinceEpoch) {
    return fmtElapsed(epoch - a.sinceEpoch);
  }
  if (a.lastActivityAt) return fmtAgo(epoch - a.lastActivityAt) + " ago";
  return "";
}

const dirTail = (d) => {
  const parts = String(d ?? "").split("/").filter((p) => p.length > 0);
  return parts.length ? parts[parts.length - 1] : "";
};

const claudeRows = computed(() => {
  const rows = [];
  for (const w of data.workspaces() ?? []) {
    for (const a of w.agents ?? []) {
      if (!String(a.kind ?? "").toLowerCase().includes("claude")) continue;
      if (a.status === "ended") continue;
      if (!matches(a.title, a.name, w.title, a.directory)) continue;
      rows.push({ key: "a:" + w.id + ":" + a.id, kind: "claude", wsId: w.id, wsTitle: w.title, surfaceId: a.surfaceId, agent: a });
    }
  }
  rows.sort((x, y) =>
    (statusOf(x.agent).rank - statusOf(y.agent).rank)
    || ((y.agent.lastActivityAt ?? 0) - (x.agent.lastActivityAt ?? 0)));
  return rows;
});

const nvimRows = computed(() => {
  const rows = [];
  for (const w of data.workspaces() ?? []) {
    for (const t of w.tabs ?? []) {
      const m = NVIM_TITLE.exec(String(t.title ?? ""));
      if (!m) continue;
      const file = m[1] || "[No Name]";
      const dir = m[3] ?? t.directory ?? "";
      if (!matches(file, dir, w.title)) continue;
      rows.push({
        key: "n:" + w.id + ":" + t.id,
        kind: "nvim",
        wsId: w.id,
        wsTitle: w.title,
        surfaceId: t.surfaceId,
        file: file,
        modified: (m[2] ?? "").includes("+"),
        dir: dir,
        focused: w.selected && t.focused,
      });
    }
  }
  return rows;
});

// One flat keyed list: section headers + rows (kind is encoded in the key so
// each key's template stays stable across live updates).
const entries = computed(() => {
  const c = claudeRows();
  const n = nvimRows();
  const out = [];
  out.push({ key: "h:claude", kind: "header", title: "Claude", app: "claude" });
  for (const r of c) out.push(r);
  if (c.length === 0) out.push({ key: "e:claude", kind: "empty", text: "No Claude sessions." });
  out.push({ key: "h:nvim", kind: "header", title: "Neovim", app: "nvim" });
  for (const r of n) out.push(r);
  if (n.length === 0) out.push({ key: "e:nvim", kind: "empty", text: "No Neovim instances." });
  return out;
});

function jump(row) {
  cmux("workspace.select", { workspace_id: row.wsId });
  if (row.surfaceId) cmux("surface.focus", { surface_id: row.surfaceId });
}

function headerSummary(app) {
  if (app === "nvim") return String(nvimRows().length);
  const rows = claudeRows();
  const waiting = rows.filter((r) => r.agent.status === "needs_input").length;
  const working = rows.filter((r) => r.agent.status === "working").length;
  const bits = [String(rows.length)];
  if (waiting > 0) bits.push(waiting + " needs input");
  if (working > 0) bits.push(working + " working");
  return bits.join(" · ");
}

function headerRow(entry) {
  return HStack({ spacing: 6 }, [
    Text(() => entry().title).font(11).weight("semibold").color("secondary"),
    Spacer(),
    Text(() => headerSummary(entry().app)).font(10).monospaced().color("tertiary"),
  ])
    .paddingHorizontal(10).paddingVertical(4)
    .frame({ maxWidth: "infinity" });
}

function emptyRow(entry) {
  return Text(() => entry().text)
    .font(11).color("tertiary")
    .paddingHorizontal(10).paddingVertical(2);
}

function claudeRow(entry) {
  const a = () => entry().agent;
  return VStack({ spacing: 2 }, [
    HStack({ spacing: 6 }, [
      Circle({ size: 6 }).fill(() => statusOf(a()).color),
      Text(() => a().title || a().name)
        .font(12).weight("medium").lineLimit(1).truncation("tail"),
      Spacer(),
      Text(() => timeText(a(), data.clock()?.epoch ?? 0))
        .font(10).monospaced().color("tertiary")
        .lineLimit(1).fixedSize().layoutPriority(2),
    ]),
    HStack({ spacing: 6 }, [
      Text(() => statusOf(a()).label)
        .font(10)
        .color(() => (a().status === "needs_input" ? "#FF9F0A" : "tertiary"))
        .lineLimit(1).fixedSize().layoutPriority(2),
      Text(() => [entry().wsTitle, dirTail(a().directory)].filter((s) => s).join(" · "))
        .font(10).monospaced().color("tertiary").lineLimit(1).truncation("middle"),
      Spacer(),
    ]).paddingLeading(12),
  ])
    .paddingHorizontal(10).paddingVertical(5)
    .cornerRadius(8)
    .hoverBackground("#7f7f7f24")
    .frame({ maxWidth: "infinity" })
    .onTap(() => jump(entry()));
}

function nvimRow(entry) {
  return VStack({ spacing: 2 }, [
    HStack({ spacing: 6 }, [
      Circle({ size: 6 }).fill(() => (entry().modified ? "#FF9F0A" : "#57A143")),
      Text(() => entry().file + (entry().modified ? " +" : ""))
        .font(12).weight("medium").lineLimit(1).truncation("middle"),
      Spacer(),
    ]),
    HStack({ spacing: 6 }, [
      Text(() => [entry().wsTitle, entry().dir].filter((s) => s).join(" · "))
        .font(10).monospaced().color("tertiary").lineLimit(1).truncation("middle"),
      Spacer(),
    ]).paddingLeading(12),
  ])
    .paddingHorizontal(10).paddingVertical(5)
    .cornerRadius(8)
    .background(() => (entry().focused ? "#7f7f7f1c" : null))
    .hoverBackground("#7f7f7f24")
    .frame({ maxWidth: "infinity" })
    .onTap(() => jump(entry()));
}

sidebar(() =>
  VStack({ spacing: 6 }, [
    HStack({ spacing: 6 }, [
      Text("Apps").font(14).weight("semibold"),
      Spacer(),
    ]).paddingHorizontal(10),

    TextField("", {
      placeholder: "Search",
      autofocus: false,
      onEdit: (t) => setQuery(t ?? ""),
      onSubmit: (t) => setQuery(t ?? ""),
    }).paddingHorizontal(10),

    ForEach(
      { items: entries, key: (e) => e.key },
      (e) => {
        const entry = e(); // kind is stable per key
        if (entry.kind === "header") return headerRow(e);
        if (entry.kind === "empty") return emptyRow(e);
        if (entry.kind === "nvim") return nvimRow(e);
        return claudeRow(e);
      }
    ),
    Spacer(),
  ]).paddingHorizontal(6),
  { surface: "glass" }
)
