# Conventional Commits

This is a mix task that will open a REPL allowing developers to write commit messages following [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/)

# Setup
- Add `:conventional_commits` to the list of dependencies in `mix.exs`
```
def deps do
    [
        {:conventional_commits, "~> 0.1.0"}
    ]
end
```

# Usage
## Conventional Commit
A conventional commit will have the following structure
```
<type>[optional scope] : <description>

[optional body]

[optional footer(s)]
```

For example: 
```
feat(logging): Updating logging module

- Updated `parse_log/3` to stream logs. This allows for more consistent load on the backend.

Author: W3NDO
Refs: #123
```

## The `.commit.exs` file
This is a file that will specify parts of a commit that may be required by the user's code base. For example, if your organisation needs that all commits contain a `body`, then it is included in the `.commit.exs` file under `required: []`

```
[
  required: [],
  footer_fields: [:author, :reviewed_by, :refs],
  breaking_change_in_footer: false
]
```

### `required` field keys
`body`  : Used if the commit requires a body
`footer`: Used if the commit requires a footer
`scope` : Used if the commit requires a scope

If the `.commit.exs` file does not exist, you can specify required parts of the commit using these flags:
`-f` or `--footer` : Footer required
`-b` or `--body` : Body required
`-s` or `--scope`: Scope required. 

### `footer_fields`
These will be used to specify fields that should be included in the footer. It is ignored if `:footer` is not in `required`. 

### `breaking_change_in_footer`
This is a boolean that specifies if in the footer ofa commit with a breaking change the tag `BREAKING CHANGE` is included. By default it is false, but all breaking change commits will include a `!` before the description

## Task Options
- `--type` (or `-t`) - `required` Specifies the type of commit. Accepted options are `fix`, `feat`, `build`, `chore`, `ci`, `docs`, `style`, `refactor`, `perf` and `test`
- `--footer` (or `-f`) - Used when the commit must have a footer
- `--scope` (or `-s`) - Used when the commit must have a scope
- `--body` (or `-b`) - Used when the commit must have a body
- `--breaking` (or `-B`) - Used when the commit will create a breaking change to the code base. This will append a `!` after type and scope eg: `feat(scope)!: Description`. Optionally, you can specify in your `.commit.exs` if you want the words: `BREAKING CHANGE` included in your footer.


## What this mix task doesn't do
1. Push your changes upstream.
2. Add your changes to staging. (WIP)

## Contributing
Visit the [issues tracker](https://github.com/W3NDO/conventional_commits/issues) to see which issues are outstanding. You are welcome to file new issues as well!

