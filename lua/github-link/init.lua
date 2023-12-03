local function get_range()
	return vim.fn.line("'<"), vim.fn.line("'>")
end

local function get_file_name()
	return vim.fn.expand("%")
end

---@class Error
---@field message string

---Get the ref of the current file
---@param which_ref string The ref type, one of `branch`, `head`, `file`
---@return string ref The ref name
---@return Error | nil err The error message or nil if no error
local function get_ref(which_ref)
  local ref
	if which_ref == "branch" then
		ref = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
		local exist = vim.fn.systemlist("git ls-remote --exit-code --heads origin " .. ref)[1]
		if not exist then
			return "", { message = "Remote branch does not exist" }
		end
	elseif which_ref == "head" then
		ref = vim.fn.systemlist("git rev-parse HEAD")[1]
	elseif which_ref == "file" then
		ref = vim.fn.systemlist("git rev-list -1 HEAD -- " .. vim.fn.shellescape(vim.fn.expand("%")))[1]
		if not ref then
			return "", { message = "No commits yet" }
		end
	else
		return "", { message = "Unknown ref type: " .. which_ref }
	end

	return ref, nil
end

---Get the link to the current file in the current branch
---@param remote string The remote name with `https://github.com/${owner}/${repo}`
---@param ref string The branch name or commit hash
---@param file string The file path relative to the repository root
---@return string
local function get_link(remote, ref, file)
	return string.format("%s/blob/%s/%s", remote, ref, file)
end

local plain_extensions = {
	"md",
	"rst",
	"markdown",
	"mdown",
	"mkdn",
	"md",
	"textile",
	"rdoc",
	"org",
	"creole",
	"mediawiki",
	"wiki",
	"rst",
	"asciidoc",
	"adoc",
	"asc",
	"pod",
}

---Append `?plain=1` to the link if the file is a plain text file
---@param link string
---@param file string
---@return string
local append_plain_query = function(link, file)
	local plain_ext_regexp = table.concat(plain_extensions, "|")
	if string.match(file, string.format("%s$", plain_ext_regexp)) then
		link = link .. "?plain=1"
	end
	return link
end

---Append line range to the link
---@param link string
---@param from number
---@param to number
---@return string
local append_range = function(link, from, to)
	if from ~= to then
		link = link .. string.format("#L%d-L%d", from, to)
	else
		link = link .. string.format("#L%d", from)
	end
	return link
end

local function trim_git_suffix(str)
	return string.gsub(str, ".git$", "")
end

---@param remote string The remote name
---@return string | nil link The link or nil if error
local function get_repo_link(remote)
	if string.match(remote, "^git") then
		local link = string.gsub(trim_git_suffix(remote), "^git@(.*):(.*)$", "https://%1/%2")
		return link
	elseif string.match(remote, "^https") then
		local link = string.gsub(trim_git_suffix(remote), "^https://(.*@)?(.*)$", "https://%2")
		return link
	elseif string.match(remote, "^ssh") then
		local link = string.gsub(trim_git_suffix(remote), "^ssh://git@(.{-})/(.*)$", "https://%1/%2")
		return link
	else
		return nil
	end
end

local M = {}

---@param which_ref "branch" | "head" | "file" The ref type, one of `branch`, `head`, `file`
function M.get_commit_link(which_ref)
	local remote = vim.fn.systemlist("git remote get-url origin")[1]
	if not string.match(remote, ".*github.*") then
		vim.api.nvim_err_writeln("[github-link.nvim] Not a github repo")
		return
	end

	local repo = get_repo_link(remote)
	if not repo then
		vim.api.nvim_err_writeln("[github-link.nvim] Unknown remote format")
		return
	end

	local ref, err = get_ref(which_ref)
	if err then
		vim.api.nvim_err_writeln("[github-link.nvim] " .. err.message)
		return
	end

	local file = get_file_name()
	if file == "" then
		vim.api.nvim_err_writeln("[github-link.nvim] Not in a file")
		return
	end

	local link = get_link(repo, ref, file)
	link = append_plain_query(link, file)
	vim.print(link)
end

---@param which_ref "branch" | "head" | "file" The ref type, one of `branch`, `head`, `file`
function M.get_commit_link_range(which_ref)
	local remote = vim.fn.systemlist("git remote get-url origin")[1]
	if not string.match(remote, ".*github.*") then
		vim.api.nvim_err_writeln("Not a github repo")
		return
	end

	local repo = get_repo_link(remote)
	if not repo then
		vim.api.nvim_err_writeln("[github-link.nvim] Unknown remote format")
		return
	end

	local ref, err = get_ref(which_ref)
	if err then
		vim.api.nvim_err_writeln("[github-link.nvim] " .. err.message)
		return
	end

	local file = get_file_name()
	if not file then
		vim.api.nvim_err_writeln("[github-link.nvim] Not in a file")
		return
	end

	local start_line, end_line = get_range()

	local link = get_link(repo, ref, file)
	link = append_range(link, start_line, end_line)
	link = append_plain_query(link, file)
	vim.print(link)
end

function M.get_user_link()
	vim.print("https://github.com/" .. vim.fn.systemlist("git config --get user.name")[1])
end

return M
