local github_link = require("github-link")

describe("get_repository_link", function()
	it("should convert git protocol link to the correct http link", function()
		local remote = "git@github.com:ushmz/github-link.nvim.git"
		local link = github_link.get_repo_link(remote)
		assert.equals(link, "https://github.com/ushmz/github-link.nvim")
	end)

	it("should convert ssh protocol link to the correct http link", function()
		local remote = "ssh://git@github.com/ushmz/github-link.nvim.git"
		local link = github_link.get_repo_link(remote)
		assert.equals(link, "https://github.com/ushmz/github-link.nvim")
	end)

	it("should convert http protocol link to the correct http link", function()
		local remote = "https://github.com/ushmz/github-link.nvim"
		local link = github_link.get_repo_link(remote)
		assert.equals(link, "https://github.com/ushmz/github-link.nvim")
	end)
end)
