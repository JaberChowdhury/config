return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local lualine = require 'lualine'
    -- local theme = require("lualine.themes.gruvbox_dark")
    local theme = require 'lualine.themes.iceberg'

    -- Make the entire statusline background transparent
    for _, mode in pairs { 'normal', 'insert', 'visual', 'replace', 'command', 'inactive' } do
      if theme[mode] and theme[mode].c then
        theme[mode].c.bg = nil
      end
    end

    local icons = {
      mode = '',
      branch = '',
      diff = { added = ' ', modified = '󰝤 ', removed = ' ' },
      diagnostics = { error = ' ', warn = ' ', info = ' ', hint = '󰌵' },
      encoding = '',
      fileformat = '',
      filesize = '󱘲',
      hostname = '󰒋',
      location = '',
      progress = '󰳾',
      searchcount = '',
      selectioncount = '󰈈',
      lsp = '',
      windows = '',
      git = {
        added = '', -- Added files
        changed = '', -- Modified files
        removed = '󰷦', -- Removed files
        staged = '󰰣', -- Staged files
        untracked = '󰡯', -- Untracked files
        no_changes = ' No Changes',
      },
    }

    -- Function to display LSP status
    local function lsp_status()
      local clients = vim.lsp.get_clients { bufnr = 0 }
      if #clients == 0 then
        return icons.lsp .. ' No LSP'
      end
      local names = {}
      for _, client in ipairs(clients) do
        table.insert(names, client.name)
      end
      return icons.lsp .. ' ' .. table.concat(names, ', ')
    end

    -- Function to display the filename with icon
    local function file_icon_filename()
      local filename = vim.fn.expand '%:t'
      if filename == '' then
        return '[No Name]'
      end
      local ext = vim.fn.expand '%:e'
      local icon, icon_hl = require('nvim-web-devicons').get_icon(filename, ext, { default = true })
      local modified = vim.bo.modified and ' ●' or ''
      local readonly = vim.bo.readonly and ' ' or ''
      return string.format('%%#%s#%s %%*%s%s', icon_hl or '', icon or '', filename, modified .. readonly)
    end

    -- Function to display current time
    local function current_time()
      return os.date '%H:%M:%S'
    end

    -- Function to display Git status (both staged and unstaged changes)
    -- local function git_status()
    -- 	local gitsigns = vim.b.gitsigns_status_dict
    -- 	if not gitsigns then
    -- 		return icons.git.no_changes
    -- 	end

    -- 	local parts = {}

    -- 	-- Staged changes
    -- 	if gitsigns.added and gitsigns.added > 0 then
    -- 		table.insert(parts, string.format("%s %d ", icons.git.added, gitsigns.added))
    -- 	end
    -- 	if gitsigns.changed and gitsigns.changed > 0 then
    -- 		table.insert(parts, string.format("%s %d ", icons.git.changed, gitsigns.changed))
    -- 	end
    -- 	if gitsigns.removed and gitsigns.removed > 0 then
    -- 		table.insert(parts, string.format("%s %d ", icons.git.removed, gitsigns.removed))
    -- 	end

    -- 	-- Unstaged changes
    -- 	if gitsigns.untracked and gitsigns.untracked > 0 then
    -- 		table.insert(parts, string.format("%s %d ", icons.git.untracked, gitsigns.untracked))
    -- 	end

    -- 	if #parts == 0 then
    -- 		return icons.git.no_changes
    -- 	end

    -- 	return table.concat(parts, " ")
    -- end

    -- Get colors dynamically based on part and mode
    local function color_part(mode, part)
      local style = theme[mode] and theme[mode][part]
      return style and { fg = style.fg, bg = style.bg } or nil
    end

    -- Setup lualine with dynamic sections
    lualine.setup {
      options = {
        icons_enabled = true,
        theme = theme,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_divide_middle = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = {
          {
            'mode',
            icon = icons.mode,
            separator = { left = '', right = '' },
            color = color_part('normal', 'a'),
          },
          {
            'branch',
            icon = icons.branch,
            separator = { left = '', right = '' },
            color = color_part('insert', 'b'),
          },
          -- {
          -- 	git_status,
          -- 	separator = { left = "", right = "" },
          -- 	color = color_part("visual", "c"),
          -- },
          {
            'diff',
            symbols = icons.diff,
            separator = { left = '', right = '' },
            -- color = { fg = "#1a1b26", bg = "#e0af68" },
          },
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = icons.diagnostics,
            separator = { left = '', right = '' },
            color = color_part('replace', 'a'),
          },
          {
            'filesize',
            icon = icons.filesize,
            separator = { left = '', right = '' },
            color = color_part('normal', 'b'),
          },
          {
            'hostname',
            icon = icons.hostname,
            separator = { left = '', right = '' },
            color = color_part('visual', 'c'),
          },
          {
            'encoding',
            icon = icons.encoding,
            separator = { left = '', right = '' },
            color = color_part('visual', 'a'),
          },

          {
            lsp_status,
            separator = { left = '', right = '' },
            color = color_part('normal', 'b'),
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
          {
            'searchcount',
            icon = icons.searchcount,
            separator = { left = '', right = '' },
            color = color_part('visual', 'c'),
          },
          {
            'selectioncount',
            icon = icons.selectioncount,
            separator = { left = '', right = '' },
            color = color_part('insert', 'a'),
          },
          {
            'location',
            icon = icons.location,
            separator = { left = '', right = '' },
            color = color_part('replace', 'b'),
          },
          {
            'progress',
            icon = icons.progress,
            separator = { left = '', right = '' },
            color = color_part('visual', 'a'),
          },
          {
            current_time,
            separator = { left = '', right = '' },
            color = color_part('normal', 'a'),
          },
        },
        lualine_y = {
          {
            'windows',
            icon = icons.windows,
            separator = { left = '', right = '' },
            color = color_part('insert', 'b'),
          },
        },
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            file_icon_filename,
            cond = function()
              return vim.fn.empty(vim.fn.expand '%:t') == 0
            end,
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    }
  end,
}
