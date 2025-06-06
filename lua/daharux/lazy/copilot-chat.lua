return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },                   -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                          -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
    config = function()
      local vim = vim

      require('copilot').setup({})
      -- Copilot autosuggestions
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_hide_during_completion = false
      vim.g.copilot_proxy_strict_ssl = false
      vim.g.copilot_integration_id = 'vscode-chat'
      vim.g.copilot_settings = { selectedCompletionModel = 'gpt-4o-copilot' }
      vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })

      -- Copilot chat
      local chat = require('CopilotChat')
      local select = require('CopilotChat.select')
      chat.setup({
        model = 'claude-3.7-sonnet',
        references_display = 'write',
        -- question_header = ' ' .. icons.ui.User .. ' ',
        -- answer_header = ' ' .. icons.ui.Bot .. ' ',
        -- error_header = '> ' .. icons.diagnostics.Warn .. ' ',
        selection = select.visual,
        context = 'buffers',
        opts = {},
        mappings = {
          reset = {
            normal = '',
            insert = '',
          },
          show_diff = {
            full_diff = true,
          },
        },
        prompts = {
          Explain = {
            mapping = '<leader>ae',
            description = 'AI Explain',
          },
          Review = {
            mapping = '<leader>ar',
            description = 'AI Review',
          },
          Tests = {
            mapping = '<leader>at',
            description = 'AI Tests',
          },
          Fix = {
            mapping = '<leader>af',
            description = 'AI Fix',
          },
          Optimize = {
            mapping = '<leader>ao',
            description = 'AI Optimize',
          },
          Docs = {
            mapping = '<leader>ad',
            description = 'AI Documentation',
          },
          Commit = {
            mapping = '<leader>ac',
            description = 'AI Generate Commit',
            selection = select.buffer,
          },
        },
        providers = {
          copilot = {
          },
          github_models = {
          },
          copilot_embeddings = {
          },
        },

      })

      local function open_with_custom_prompt()
        local prompt_dir = vim.fn.getcwd() .. "/.github/prompts"
        if vim.fn.isdirectory(prompt_dir) == 1 then
          local files = vim.fn.glob(prompt_dir .. "/*.md", false, true)
          if #files > 0 then
            -- Create a simple menu for selection
            local menu = {}
            for i, file in ipairs(files) do
              local name = vim.fn.fnamemodify(file, ":t:r")
              table.insert(menu, { name, file })
            end

            -- Use vim.ui.select for better UI
            vim.ui.select(menu, {
              prompt = "Select a prompt:",
              format_item = function(item) return item[1] end, -- Show the prompt name
            }, function(selected)
              if selected then
                local file_path = selected[2]
                local prompt_name = vim.fn.fnamemodify(file_path, ":t:r")

                -- Create the context command to include the prompt file
                local context_cmd = "> #file:`" .. file_path .. "`"

                -- Copy to system clipboard ('+' register)
                vim.fn.setreg('+', context_cmd)

                -- Open chat window
                chat.toggle()

                -- Let user know which prompt is being used (without notification about clipboard)
                vim.defer_fn(function()
                  vim.api.nvim_echo(
                    { { "Using prompt: '" .. prompt_name .. "' (context copied to clipboard)", "None" } },
                    false, {})
                end, 100)
              end
            end)
          else
            vim.notify("No prompt files found in " .. prompt_dir, vim.log.levels.WARN)
          end
        else
          vim.notify("Directory not found: " .. prompt_dir, vim.log.levels.WARN)
        end
      end

      -- Custom function to save chat with name
      local function save_chat_with_name()
        vim.ui.input({
          prompt = "Save chat as: ",
        }, function(input)
          if input and input ~= "" then
            vim.cmd("CopilotChatSave " .. input)
            vim.notify("Chat saved as '" .. input .. "'", vim.log.levels.INFO)
          end
        end)
      end

      -- Custom function to load chat by name
      local function load_chat_by_name()
        -- Get list of saved chats
        local chat_dir = vim.fn.stdpath("data") .. "/copilot-chat"
        if vim.fn.isdirectory(chat_dir) == 1 then
          local files = vim.fn.glob(chat_dir .. "/*.json", false, true)
          if #files > 0 then
            local chat_names = {}
            for _, file in ipairs(files) do
              local name = vim.fn.fnamemodify(file, ":t:r")
              table.insert(chat_names, name)
            end

            vim.ui.select(chat_names, {
              prompt = "Load chat:",
            }, function(selected)
              if selected then
                vim.cmd("CopilotChatLoad " .. selected)
              end
            end)
          else
            vim.notify("No saved chats found", vim.log.levels.WARN)
          end
        else
          vim.notify("Chat directory not found", vim.log.levels.WARN)
        end
      end

      vim.api.nvim_create_user_command('CopilotChatTestPrompt', function()
        -- Print the current directory for debugging
        local cwd = vim.fn.getcwd()
        vim.api.nvim_echo({ { "Current working directory: " .. cwd, "None" } }, false, {})
        local prompt_dir = cwd .. "/.github/prompts"
        vim.api.nvim_echo({ { "Looking for prompts in: " .. prompt_dir, "None" } }, false, {})
        if vim.fn.isdirectory(prompt_dir) == 1 then
          local files = vim.fn.glob(prompt_dir .. "/*.md", false, true)
          if #files > 0 then
            vim.api.nvim_echo({ { "Found " .. #files .. " prompt files in " .. prompt_dir, "None" } }, false, {})
            for i, file in ipairs(files) do
              local name = vim.fn.fnamemodify(file, ":t:r")
              vim.api.nvim_echo({ { "  " .. i .. ": " .. name, "None" } }, false, {})
            end
          else
            vim.api.nvim_echo({ { "No prompt files found in " .. prompt_dir, "None" } }, false, {})
          end
        else
          vim.api.nvim_echo({ { "Directory not found: " .. prompt_dir, "None" } }, false, {})
        end
      end, {})

      -- Add save chat with name keymap
      vim.keymap.set({ 'n' }, '<leader>in', save_chat_with_name, { desc = 'AI Save Chat (Named)' })
      -- Add load chat by name keymap
      vim.keymap.set({ 'n' }, '<leader>ib', load_chat_by_name, { desc = 'AI Load Chat (Browse)' })
      vim.keymap.set({ 'n' }, '<leader>ap', open_with_custom_prompt, { desc = 'AI Custom Prompt' })
      vim.keymap.set({ 'n' }, '<leader>aa', chat.toggle, { desc = 'AI Toggle' })
      vim.keymap.set({ 'v' }, '<leader>aa', chat.open, { desc = 'AI Open' })
      vim.keymap.set({ 'n' }, '<leader>ax', chat.reset, { desc = 'AI Reset' })
      vim.keymap.set({ 'n' }, '<leader>as', chat.stop, { desc = 'AI Stop' })
      vim.keymap.set({ 'n' }, '<leader>am', chat.select_model, { desc = 'AI Models' })
      vim.keymap.set({ 'n' }, '<leader>ag', chat.select_agent, { desc = 'AI Agents' })
      vim.keymap.set({ 'n', 'v' }, '<leader>asp', chat.select_prompt, { desc = 'AI Prompts' })
      -- Add save chat keymap
      vim.keymap.set({ 'n' }, '<leader>iw', chat.save, { desc = 'AI Save Chat' })
      -- Add load chat keymap
      vim.keymap.set({ 'n' }, '<leader>il', chat.load, { desc = 'AI Load Chat' })
      vim.keymap.set({ 'n', 'v' }, '<leader>aq', function()
        vim.ui.input({
          prompt = 'AI Question> ',
        }, function(input)
          if input ~= '' then
            chat.ask(input)
          end
        end)
      end, { desc = 'AI Question' })
    end
  },
}
