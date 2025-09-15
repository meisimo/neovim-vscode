local function get_config_dir()
	local info = debug.getinfo(1, "S")
	local current_file = info.source:sub(2)  -- remove leading '@'
	local current_file_dir = vim.fn.fnamemodify(current_file, ":h")
	return current_file_dir
end

local config_dir = get_config_dir()

local function read_env_file()
	local env_file = config_dir .. "/.env"
	local file = io.open(env_file, "r")
	if file then
		local content = file:read("*all")
		file:close()
		return content
	end
	return ""
end
local function get_env_variables()
	local env_file = read_env_file()
	local env_variables = {}
	for line in env_file:gmatch("[^\r\n]+") do
		local key, value = line:match("^(%w+)=(.*)$")
		if key and value then
			env_variables[key] = value
		end
	end
	return env_variables
end

local env_vars = get_env_variables()
local editor = env_vars.EDITOR

local opt = vim.opt
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

if vim.g.vscode then
	local vscode = require("vscode")
	vim.g.mapleader = " "

	-- Command to comment the current line using vscode.nvim
	vim.api.nvim_create_user_command("VSCodeCommentLine", function()
		vscode.call("editor.action.commentLine")
	end, {})

	-- Map <leader><space> to open the file search (Quick Open)
	vim.keymap.set("n", "<leader><space>", function()
		vscode.call("workbench.action.quickOpen")
	end, { desc = "Open file search (Quick Open)" })

	-- Map <leader>e to toggle the file explorer
	vim.keymap.set("n", "<leader>e", function()
		vscode.call("workbench.explorer.fileView.focus")
	end, { desc = "Toggle file explorer" })

	-- Map <leader>z to toggle zen mode
	vim.keymap.set("n", "<leader>z", function()
		vscode.call("workbench.action.toggleZenMode")
	end, { desc = "Toggle Zen Mode" })

	-- Map <leader>sg to focus the search in content file for the project
	vim.keymap.set("n", "<leader>sg", function()
		vscode.call("workbench.action.findInFiles")
	end, { desc = "Focus project content search" })

	-- Map <leader>aa to open and focus GitHub Copilot panel
	if editor == "cursor" then
		vim.keymap.set("n", "<leader>aa", function()
			-- TODO: open cursor chat panel
		end, { desc = "Open and focus Cursor chat panel" })
	else
		vim.keymap.set("n", "<leader>aa", function()
			vscode.call("workbench.action.chat.toggle")
		end, { desc = "Open and focus Copilot panel" })
	end

	-- Map Shift+H to switch to the previous (left) tab
	vim.keymap.set("n", "H", function()
		vscode.call("workbench.action.previousEditor")
	end, { desc = "Go to previous (left) tab" })

	-- Map Shift+L to switch to the next (right) tab
	vim.keymap.set("n", "L", function()
		vscode.call("workbench.action.nextEditor")
	end, { desc = "Go to next (right) tab" })

	-- Buffers/Tabs management
	-- Map <leader>bo to close all the other tabs different than the one focused
	vim.keymap.set("n", "<leader>bo", function()
		vscode.call("workbench.action.closeOtherEditors")
	end, { desc = "Close all other tabs" })
	-- Map <leader>bd to close the current tab
	vim.keymap.set("n", "<leader>bd", function()
		vscode.call("workbench.action.closeActiveEditor")
	end, { desc = "Close current tab" })
	-- Map <leader>br to close all tabs to the right
	vim.keymap.set("n", "<leader>br", function()
		vscode.call("workbench.action.closeEditorsToTheRight")
	end, { desc = "Close all tabs to the right of the current tab" })
	-- Map <leader>bl to close all tabs to the left
	vim.keymap.set("n", "<leader>bl", function()
		vscode.call("workbench.action.closeEditorsToTheLeft")
	end, { desc = "Close all tabs to the left of the current tab" })
	-- End of Buffers/Tabs management

	-- Map Ctrl+/ to toggle the terminal
	vim.keymap.set("n", "<C-/>", function()
		vscode.call("workbench.action.terminal.toggleTerminal")
	end, { desc = "Toggle terminal" })

	-- Map <leader>ge to open the Git panel
	vim.keymap.set("n", "<leader>ge", function()
		vscode.call("workbench.view.scm")
	end, { desc = "Open Git panel" })

	-- Command to restart VSCode
	vim.api.nvim_create_user_command("Restart", function()
		vscode.call("workbench.action.reloadWindow")
	end, { desc = "Restart VSCode window" })
	
	-- Navigation commands and shortcuts
	-- Map ]e to go to the next error
	vim.keymap.set("n", "]e", function()
		vscode.call("editor.action.marker.next")
	end, { desc = "Go to next error" })

	-- Map [e to go to the previous error
	vim.keymap.set("n", "[e", function()
		vscode.call("editor.action.marker.prev")
	end, { desc = "editor.action.marker.prev" })
	
	-- Map ]h to go to the next git change (hunk)
	vim.keymap.set("n", "]h", function()
		vscode.call("workbench.action.editor.nextChange")
	end, { desc = "Go to next git change (hunk)" })

	-- Map [h to go to the previous git change (hunk)
	vim.keymap.set("n", "[h", function()
		vscode.call("workbench.action.editor.previousChange")
	end, { desc = "Go to previous git change (hunk)" })
	
	-- Show references (like Shift+F12)
	vim.keymap.set('n', 'gr', function()
		vscode.call('editor.action.referenceSearch.trigger')
	end, { desc = "Show references" })

	-- NOT WORKING YET
	-- Next reference
	vim.keymap.set('n', ']r', function()
		print("Go to next reference")
		vscode.call('references-view.next')
	end, { desc = "Go to next reference" })

	-- NOT WORKING YET
	-- Previous reference
	vim.keymap.set('n', '[r', function()
		vscode.call('references-view.prev')
	end, { desc = "Go to previous reference" })
	
	-- End of Navigation commands and shortcuts
	
	-- Refactoring commands and shortcuts
	-- Map <leader>cr to rename a symbol
	vim.keymap.set("n", "<leader>cr", function()
		vscode.call("editor.action.rename")
	end, { desc = "Rename a symbol" })
	-- Map <leader>ca to refactor a symbol
	vim.keymap.set("n", "<leader>ca", function()
		vscode.call("editor.action.refactor")
	end, { desc = "Refactor a symbol" })
	
	-- Map <leader>k to comment the current line
	vim.keymap.set("n", "<leader>k", function()
		vscode.call("editor.action.commentLine")
	end, { desc = "Comment current line" })
	-- Map <leader>k to comment all the lines in visual mode
	vim.keymap.set("v", "<leader>k", function()
		vscode.call("editor.action.blockComment")
	end, { desc = "Comment all the lines in visual mode" })
	vim.keymap.set("v", "<leader>kk", function()
		vscode.call("editor.action.commentLine")
	end, { desc = "Comment current line" })
	-- End of Refactoring commands and shortcuts

	-- Map <leader>| to split the current window vertically
	vim.keymap.set("n", "<leader>|", function()
		vscode.call("workbench.action.splitEditor")
	end, { desc = "Split current window vertically" })
	-- Map <leader>- to split the current window horizontally
	vim.keymap.set("n", "<leader>-", function()
		vscode.call("workbench.action.splitEditor")
	end, { desc = "Split current window horizontally" })
	-- Map Ctrl+l to switch to left panel when editor is split
	vim.keymap.set("n", "<C-l>", function()
		vscode.call("workbench.action.focusLeftGroup")
	end, { desc = "Switch to left panel" })
	-- Map Ctrl+h to switch to right panel when editor is split
	vim.keymap.set("n", "<C-h>", function()
		vscode.call("workbench.action.focusRightGroup")
	end, { desc = "Switch to right panel" })
end

