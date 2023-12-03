if vim.g.loaded_github_link == 1 then
	return
end
vim.g.loaded_github_link = 1

vim.api.nvim_create_user_command("CommitLink", function(_)
	require("github-link").get_commit_link("file")
end, { range = false })

vim.api.nvim_create_user_command("CurrentCommitLink", function(_)
	require("github-link").get_commit_link("head")
end, { range = false })

vim.api.nvim_create_user_command("CurrentBranchLink", function(_)
	require("github-link").get_commit_link("branch")
end, { range = false })

vim.api.nvim_create_user_command("CommitLinkRange", function(_)
	require("github-link").get_commit_link_range("file")
end, { range = true })

vim.api.nvim_create_user_command("CurrentCommitLinkRange", function(_)
	require("github-link").get_commit_link_range("head")
end, { range = true })

vim.api.nvim_create_user_command("CurrentBranchLinkRange", function(_)
	require("github-link").get_commit_link_range("branch")
end, { range = true })
