-- User keymaps - loaded by LazyVim automatically.
-- Add your custom keymaps here; do not re-define what LazyVim already sets.

-- -- Perforce --------------------------------------------------------------
-- Manual p4 operations on the current file.  All guarded by P4CLIENT so they
-- silently do nothing on machines without a Perforce workspace configured.
local function p4(cmd, desc)
  return function()
    if not os.getenv("P4CLIENT") then
      vim.notify("P4CLIENT not set", vim.log.levels.WARN, { title = "Perforce" })
      return
    end
    local file = vim.fn.expand("%:p")
    local out  = vim.fn.system({ "p4", cmd, file })
    vim.notify(out ~= "" and out or (cmd .. " ok"), vim.log.levels.INFO, { title = "Perforce" })
  end
end

local map = vim.keymap.set
map("n", "<leader>pe", p4("edit",    "P4 edit"),    { desc = "P4 edit" })
map("n", "<leader>pr", p4("revert",  "P4 revert"),  { desc = "P4 revert" })
map("n", "<leader>pa", p4("add",     "P4 add"),     { desc = "P4 add" })
map("n", "<leader>pd", p4("diff",    "P4 diff"),    { desc = "P4 diff" })
map("n", "<leader>pl", p4("filelog", "P4 filelog"), { desc = "P4 filelog" })
