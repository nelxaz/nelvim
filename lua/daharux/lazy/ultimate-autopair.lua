return {
  'altermo/ultimate-autopair.nvim',
  event = { 'InsertEnter', 'CmdlineEnter' },
  branch = 'v0.6', --recommended as each new version will have breaking changes
  opts = {
    --Config for automated bracket/quote pairing
    pair_spaces = true,         -- enable pair space feature (ex: '( |' creates '(  )')
    fastwarp = {                --wrapping mechanism
      enable = true,
      multi = true,             -- allows multiple fastwraps in one go
      highlight_duration = 200, -- duration of highlight for wrap points
      { faster = true, map = '<leader>w', cmap = '<leader>w' },
    },
    cmap = true,        -- command-line mode support
    bs = {              -- backspace configuration
      enable = true,
      overjump = true,  -- jump over closing pair when available
    },
    cr = {              -- configure how enters/returns are handled
      enable = true,
      autoclose = true, -- auto-close multiline pairs
    },
    extensions = {
      cmdtype = { enable = true },  -- command-line type detection
      filetype = { enable = true }, -- filetype-specific configurations
    },
  },
}
