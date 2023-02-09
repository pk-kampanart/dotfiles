local status_ok, zk = pcall(require, "zk")
if not status_ok then
  return
end

local opts = {
  -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
  -- it's recommended to use "telescope" or "fzf"
  picker = "telescope",

  lsp = {
    -- `config` is passed to `vim.lsp.start_client(config)`
    config = {
      cmd = { "zk", "lsp" },
      name = "zk",
      -- on_attach = ...
      -- etc, see `:h vim.lsp.start_client()`
    },

    -- automatically attach buffers in a zk notebook that match the given filetypes
    auto_attach = {
      enabled = true,
      filetypes = { "markdown" },
    },
  },
}

local map = require("utils.mappings").map
map("n", "<leader>nn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>")
map("n", "<leader>no", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>")
map("n", "<leader>nt", "<Cmd>ZkTags<CR>")
map("n", "<leader>nf", "<Cmd>ZkNotes { sort = { 'modified' }, match = vim.fn.input('Search: ') }<CR>")
map("v", "<leader>nf", ":'<,'>ZkMatch<CR>")

local function zk_keymaps(bufnr)
  local function map_buf(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end
  map_buf("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>")
  -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
  map_buf("n", "<leader>nn", "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>")
  -- Create a new note in the same directory as the current buffer, using the current selection for title.
  map_buf("v", "<leader>nnt", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>")
  -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
  map_buf(
    "v",
    "<leader>nnc",
    ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>"
  )
  -- Open notes linking to the current buffer.
  map_buf("n", "<leader>nb", "<Cmd>ZkBacklinks<CR>")
  -- Open notes linked by the current buffer.
  map_buf("n", "<leader>nl", "<Cmd>ZkLinks<CR>")
  -- Open the code actions for a visual selection.
  map_buf("v", "<leader>na", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>")
end

opts.lsp.config.on_attach = function(_, bufnr)
  zk_keymaps(bufnr)
end

zk.setup(opts)
