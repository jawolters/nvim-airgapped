-- User plugin specs - extends the bundle's plugin list.
--
-- In air-gapped mode, any plugin listed here must either:
--   a) already be in the bundle (just configure it), or
--   b) be available as a local path:  { dir = "/path/to/plugin" }
--
-- Do NOT use `url =` or short `"owner/repo"` specs - lazy.nvim won't be
-- able to fetch them without network access.

return {
  -- Example: configure a bundled plugin
  {
    "folke/tokyonight.nvim",
    opts = { style = "moon" },
  },

  -- Example: add a plugin from a local path
  -- { dir = "/opt/company-plugins/my-plugin.nvim" },
}
