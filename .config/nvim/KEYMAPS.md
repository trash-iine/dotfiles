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

| キー | モード | 説明 |
|---|---|---|
| `]c` / `[c` | normal | 次/前の hunk |
| `<leader>hi` | normal | hunk をインライン展開 (削除行をバッファ内に表示、カーソル移動で消える) |
| `<leader>hp` | normal | hunk をフロートでプレビュー |
| `<leader>hs` | normal / visual | hunk をステージング (ステージ済みなら解除) |
| `<leader>hr` | normal / visual | hunk をリセット |
| `<leader>hS` | normal | バッファ全体をステージング |
| `<leader>hR` | normal | バッファ全体をリセット |
| `<leader>hb` | normal | この行の blame を表示 (詳細) |
| `<leader>hd` | normal | index との diff |
| `<leader>hD` | normal | 直前のコミットとの diff |
| `ih` | operator / visual | hunk をテキストオブジェクトとして選択 (`vih`, `dih`) |

常時有効: 行番号の差分ハイライト (numhl)、変更行内の単語差分 (word_diff)、カーソル行末の blame。

## トグル

| キー | 説明 |
|---|---|
| `<leader>tb` | カーソル行末の blame 表示をトグル |
| `<leader>tw` | 単語単位の差分ハイライトをトグル |
| `<leader>tn` | 行番号の差分ハイライトをトグル |

## コメント (Comment.nvim)

| キー | モード | 説明 |
|---|---|---|
| `gcc` | normal | 行コメントトグル |
| `gc` | visual | 選択範囲をコメントトグル |
| `gbc` | normal | ブロックコメントトグル |
