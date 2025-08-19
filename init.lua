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

	-- Map <leader>kk to comment the current line
	vim.keymap.set("n", "<leader>kk", function()
		vscode.call("editor.action.commentLine")
	end, { desc = "Comment current line" })

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
	vim.keymap.set("n", "<leader>aa", function()
		vscode.call("workbench.action.chat.toggle")
	end, { desc = "Open and focus Copilot panel" })

	-- Map Shift+H to switch to the previous (left) tab
	vim.keymap.set("n", "H", function()
		vscode.call("workbench.action.previousEditor")
	end, { desc = "Go to previous (left) tab" })

	-- Map Shift+L to switch to the next (right) tab
	vim.keymap.set("n", "L", function()
		vscode.call("workbench.action.nextEditor")
	end, { desc = "Go to next (right) tab" })

	-- Map <leader>bd to close all the other tabs different than the one focused
	vim.keymap.set("n", "<leader>bd", function()
		vscode.call("workbench.action.closeOtherEditors")
	end, { desc = "Close all other tabs" })

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
	
	
end
