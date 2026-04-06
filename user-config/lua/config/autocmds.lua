-- Auto-checkout file from Perforce before writing.
-- Only active when P4CLIENT is set in the environment, so the autocommand
-- is a no-op on machines that don't have Perforce configured.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("p4_auto_edit", { clear = true }),
  callback = function()
    -- Skip if not in a Perforce workspace
    if not os.getenv("P4CLIENT") then return end

    local file = vim.fn.expand("%:p")

    -- Skip new buffers that haven't been saved yet
    if file == "" or not vim.uv.fs_stat(file) then return end

    -- Skip files that are already writable (already checked out or not in depot)
    if vim.fn.filewritable(file) == 1 then return end

    local out = vim.fn.system({ "p4", "edit", file })
    if vim.v.shell_error ~= 0 then
      vim.notify("p4 edit failed:\n" .. out, vim.log.levels.WARN, { title = "Perforce" })
    else
      vim.notify(vim.fn.fnamemodify(file, ":~:.") .. " checked out", vim.log.levels.INFO, { title = "Perforce" })
    end
  end,
})
