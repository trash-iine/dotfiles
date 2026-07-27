# Keymaps

リーダーキーは `<Space>`。

## 基本 (config/keymaps.lua)

| キー | モード | 説明 |
|---|---|---|
| `<Esc>` | normal | 検索ハイライト解除 |
| `<leader>w` | normal | 保存 |
| `<leader>q` | normal | 終了 |
| `<C-h/j/k/l>` | normal | ウィンドウ移動 (左/下/上/右) |
| `<S-h>` / `<S-l>` | normal | 前/次のバッファ |
| `J` / `K` | visual | 選択行を下/上へ移動 |
| `<C-d>` / `<C-u>` | normal | 半ページ下/上 (カーソル中央寄せ) |

## Telescope (ファジーファインダー)

| キー | 説明 |
|---|---|
| `<leader>ff` | ファイル検索 |
| `<leader>fg` | プロジェクト内 grep |
| `<leader>fb` | バッファ一覧 |
| `<leader>fh` | ヘルプタグ検索 |
| `<leader>fr` | 最近開いたファイル |
| `<C-j>` / `<C-k>` | (insert) 次/前の候補 |

## LSP (LspAttach 時に有効)

| キー | 説明 |
|---|---|
| `gd` | 定義へジャンプ |
| `gr` | 参照一覧 |
| `K` | ホバー (型/ドキュメント表示) |
| `<leader>rn` | シンボルリネーム |
| `<leader>ca` | コードアクション |
| `<leader>f` | フォーマット |

## ファイルエクスプローラー (neo-tree)

| キー | 説明 |
|---|---|
| `<leader>e` | エクスプローラーをトグル |

## 補完 (nvim-cmp, insert モード)

| キー | 説明 |
|---|---|
| `<C-n>` / `<C-p>` | 次/前の候補 |
| `<C-Space>` | 補完を手動トリガー |
| `<CR>` | 確定 |
| `<C-b>` / `<C-f>` | ドキュメントスクロール |
| `<Tab>` / `<S-Tab>` | スニペットジャンプ |

## Git (gitsigns)

| キー | 説明 |
|---|---|
| `]c` / `[c` | 次/前の hunk |
| `<leader>hs` | hunk をステージング |
| `<leader>hr` | hunk をリセット |
| `<leader>hp` | hunk をプレビュー |

## コメント (Comment.nvim)

| キー | モード | 説明 |
|---|---|---|
| `gcc` | normal | 行コメントトグル |
| `gc` | visual | 選択範囲をコメントトグル |
| `gbc` | normal | ブロックコメントトグル |
