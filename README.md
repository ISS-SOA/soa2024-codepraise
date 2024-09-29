# Github API Client

Project to gather useful information from Github API

## Resources

- Repository
- Contributors
- Organization

## Elements

- repositories
  - clone url
  - name of repo/project
  - list of contributors
  - size of repos
- contributors
  - name
  - email

## Entities

These are objects that are important to the project, following my own naming conventions:

- Project (Github repository for a course project)
- Contributors (teammates/others contributing to a project)

## Install

## Setting up this script

- Create a personal Github API access token with `public_repo` scope
- Copy `config/secrets_example.yml` to `config/secrets.yml` and update token
- Ensure correct version of Ruby install (see `.ruby-version` for `rbenv`)
- Run `bundle install`

## Running this script

To create fixtures, run:

```shell
ruby lib/project_info.rb
```

Fixture data should appear in `spec/fixtures/` folder
