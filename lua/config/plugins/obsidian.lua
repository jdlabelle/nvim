return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ft = "markdown",
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    workspaces = {
      {
        name = "wiki",
        path = "~/wiki",
        -- overrides = {
        --   notes_subdir = "notes",
        -- },
      },
    },

    -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
    -- levels defined by "vim.log.levels.\*".
    log_level = vim.log.levels.INFO,
    legacy_commands = false, -- this will be removed in the next major release

    -- Optional, determines how certain commands open notes. The valid options are:
    -- 1. "current" (the default) - to always open in the current window
    -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
    -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
    -- 4. "vsplit_force" - always open a new vertical split if the file is not in the adjacent vsplit.
    -- 5. "hsplit_force" - always open a new horizontal split if the file is not in the adjacent hsplit.
    open_notes_in = "current",

    daily_notes = {
      enabled = true,
      -- Optional, if you keep daily notes in a separate directory.
      folder = "dailies",
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = "%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = "%B %-d, %Y",
      -- Optional, default tags to add to each new daily note created.
      default_tags = { "daily-notes" },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = nil,
      -- Optional, if you want `Obsidian yesterday` to return the last work day or `Obsidian tomorrow` to return the next work day.
      workdays_only = true,
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Enables completion using blink.cmp
      blink = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
      match_case = true,
      create_new = true,
    },

    -- Where to put new notes. Valid options are
    -- _ "current_dir" - put new notes in same directory as the current buffer.
    -- _ "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = "current_dir",

    -- Optional, customize how note IDs are generated given an optional title.
    -- Default:
    -- note_id_func = require("obsidian.builtin").zettel_id,
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'.
      -- You may have as many periods in the note ID as you'd like—the ".md" will be added automatically
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      -- return tostring(os.time()) .. "-" .. suffix
      return tostring(os.date("%Y%m%d%H%M")) .. "-" .. suffix
    end,

    note_path_func = function(spec)
      -- This is equivalent to the default behavior.
      local path = spec.dir / tostring(spec.id)
      return path:with_suffix(".md", true)
    end,

    ---@alias obsidian.link.LinkStyle "wiki" | "markdown" | fun(opts: obsidian.link.LinkCreationOpts): string
    ---@alias obsidian.link.LinkFormat "shortest" | "relative" | "absolute"
    ---@class obsidian.config.LinkOpts
    ---@field style? obsidian.link.LinkStyle
    ---@field format? obsidian.link.LinkFormat
    link = {
      style = "wiki",
      format = "shortest",
    },

    -- Optional, for templates (see https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#substitutions)
    templates = {
      enabled = true,
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      --substitutions = {},
      -- A map for configuring unique directories and paths for specific templates
      --- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#customizations
      --customizations = {},
    },
    ---@class obsidian.config.OpenOpts
    ---
    ---Opens the file with current line number
    ---@field use_advanced_uri? boolean
    ---
    ---Function to do the opening, default to vim.ui.open
    ---@field func? fun(uri: string)
    ---
    ---URI scheme whitelist, new values are appended to this list, and URIs with schemes in this list, will not be prompted to confirm opening
    ---@field schemes? string[]
    open = {
      use_advanced_uri = false,
      func = vim.ui.open,
      schemes = { "https", "http", "file", "mailto" },
    },

    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
      name = "telescope.nvim",
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      note_mappings = {
        -- Create a new note from your query.
        new = "<C-x>",
        -- Insert a link to the selected note.
        insert_link = "<C-l>",
      },
      tag_mappings = {
        -- Add tag(s) to current note.
        tag_note = "<C-x>",
        -- Insert a tag at the current location.
        insert_tag = "<C-l>",
      },
    },

    -- Optional, by default, `:ObsidianBacklinks` parses the header under
    -- the cursor. Setting to `false` will get the backlinks for the current
    -- note instead. Doesn't affect other link behaviour.
    backlinks = {
      parse_headers = true
    },

    -- Optional, sort search results by "path", "modified", "accessed", or "created".
    -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
    -- that `:Obsidian quick_switch` will show the notes sorted by latest modified time
    search = {
      sort_by = "modified",
      sort_reversed = true,
      -- Set the maximum number of lines to read from notes on disk when performing certain searches.
      max_lines = 1000,
    },


    -- Optional, define your own callbacks to further customize behavior.
    -- callbacks = {
    --   -- Runs at the end of `require("obsidian").setup()`.
    --   ---@param client obsidian.Client
    --   post_setup = function(client) end,
    --
    --   -- Runs anytime you enter the buffer for a note.
    --   ---@param client obsidian.Client
    --   ---@param note obsidian.Note
    --   enter_note = function(client, note) end,
    --
    --   -- Runs anytime you leave the buffer for a note.
    --   ---@param client obsidian.Client
    --   ---@param note obsidian.Note
    --   leave_note = function(client, note) end,
    --
    --   -- Runs right before writing the buffer for a note.
    --   ---@param client obsidian.Client
    --   ---@param note obsidian.Note
    --   pre_write_note = function(client, note) end,
    --
    --   -- Runs anytime the workspace is set/changed.
    --   ---@param client obsidian.Client
    --   ---@param workspace obsidian.Workspace
    --   post_set_workspace = function(client, workspace) end,
    -- },

    ---@class obsidian.config.UICharSpec
    ---@field char string
    ---@field hl_group string

    ---@class obsidian.config.CheckboxSpec : obsidian.config.UICharSpec
    ---@field char string
    ---@field hl_group string

    ---@class obsidian.config.UIStyleSpec
    ---@field hl_group string

    ---@class obsidian.config.UIOpts
    ---
    ---@field enable boolean
    ---@field enabled boolean
    ---@field ignore_conceal_warn boolean
    ---@field update_debounce integer
    ---@field max_file_length integer|?
    ---@field checkboxes table<string, obsidian.config.CheckboxSpec>
    ---@field bullets obsidian.config.UICharSpec|?
    ---@field external_link_icon obsidian.config.UICharSpec
    ---@field reference_text obsidian.config.UIStyleSpec
    ---@field highlight_text obsidian.config.UIStyleSpec
    ---@field tags obsidian.config.UIStyleSpec
    ---@field block_ids obsidian.config.UIStyleSpec
    ---@field hl_groups table<string, table>
    -- Optional, configure additional syntax highlighting / extmarks.
    -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
    ui = {
      enable = false,              -- set to false to disable all additional syntax features
      ignore_conceal_warn = false, -- set to true to disable conceallevel specific warning
      update_debounce = 200,       -- update delay after a text change (in milliseconds)
      max_file_length = 5000,      -- disable UI features for files with more than this many lines
      -- Define how various check-boxes are displayed
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "obsidiantodo" },
        ["~"] = { char = "󰰱", hl_group = "obsidiantilde" },
        ["!"] = { char = "", hl_group = "obsidianimportant" },
        [">"] = { char = "", hl_group = "obsidianrightarrow" },
        ["x"] = { char = "", hl_group = "obsidiandone" },
      },
      -- Use bullet marks for non-checkbox lists.
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      -- Replace the above with this if you don't have a patched font:
      -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },

    ---@class obsidian.config.UniqueNoteOpts
    ---
    ---@field enabled? boolean
    ---@field format? string|fun():string
    ---@field folder? string
    ---@field template? string
    unique_note = {
      enabled = true,
      format = "YYYYMMDDHHmm",
      folder = nil,
      template = nil,
    },

    ---@class obsidian.config.AttachmentsOpts
    ---Default folder to save images to, relative to the vault root (/) or current dir (.)
    ---@field folder? string
    ---Default name for pasted images
    ---@field img_name_func? fun(): string
    ---Default text to insert for pasted images, for customizing, see: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Images
    ---@field img_text_func? fun(path: obsidian.Path): string
    ---Whether to confirm the paste or not. Defaults to true.
    ---@field confirm_img_paste? boolean
    attachments = {
      folder = "assets/imgs",
      img_name_func = function()
        return string.format("Pasted image %s", os.date "%Y%m%d%H%M%S")
      end,
      confirm_img_paste = true,
    },

    ---@class obsidian.config.FooterOpts
    ---@field enabled? boolean
    ---@field format? string
    ---@field hl_group? string
    ---@field separator? string|false Set false to disable separator; set an empty string to insert a blank line separator.
    footer = {
      enabled = true,
      format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
      hl_group = "Comment",
      separator = string.rep("-", 80),
    },

    ---@class obsidian.config.CheckboxOpts
    ---
    ---@field enabled? boolean
    ---
    ---Whether to create new checkbox on paragraphs
    ---@field create_new? boolean
    ---
    ---Order of checkbox state chars, e.g. { " ", "x" }
    ---@field order? string[]
    checkbox = {
      enabled = true,
      create_new = true,
      order = { " ", "~", "!", ">", "x" },
    },

    ---@class obsidian.config.CommentOpts
    ---@field enabled boolean
    comment = {
      enabled = false,
    },
  },

  -- My custom keymaps
  vim.keymap.set("n", "<leader>os", ":Obsidian search<CR>", { desc = "[O]bsidian [S]earch" }),
  vim.keymap.set("n", "<leader>of", ":Obsidian quick_switch<CR>", { desc = "[O]bsidian Quick Switch" }),
  vim.keymap.set("n", "<leader>on", ":Obsidian new<CR>", { desc = "[O]bsidian [N]ew Note" }),
  vim.keymap.set("n", "<leader>ow", ":Obsidian workspace<CR>", { desc = "[O]bsidian Switch [W]orkspace" }),
  vim.keymap.set("n", "<leader>ot", ":Obsidian new_from_template<CR>", { desc = "[O]bsidian new from [T]emplate" }),
}
