# github-link.nvim

Copy github link for current line(s) to clipboard.

## Install

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    -- add plugin to your list
    "ushmz/github-link.nvim"
}
```

## Usage

In normal mode, put a link for the file on Github.

| Command             | Description                            |
| :------------------ | :------------------------------------- |
| `CommitLink`        | Get link to the file on latest change  |
| `CurrentCommitLink` | Get link to the file on HEAD           |
| `CurrentBranchLink` | Get link to the file on current branch |

In visual mode, put a link for the selected range of the file on Github.

| Command                  | Description                            |
| :----------------------- | :------------------------------------- |
| `CommitLinkRange`        | Get link to the file on latest change  |
| `CurrentCommitLinkRange` | Get link to the file on HEAD           |
| `CurrentBranchLinkRange` | Get link to the file on current branch |
