# CodePraise

Application that allows *instructors* and *students* to guage how well individual students have contributed to *team projects*.

## Overview

Codepraise will pull data from Github's API, as well as clone and analyze blame information.

It will then generate *reports* to show how proportionately individual students have contributed to specific aspects of their project: testing, interface, infrastructure, etc. We call this a *praise* assessment: students should feel proud to have contributed to key parts of their project.

We hope this tool will give instructors a fair sense of how well students have contributed, but also that it gives students a sense of how their contributions are perceived objectively. We do not want our reports to be the sole basis of asessing student performance on team projects. Instead, we intend our praise reports to be the beginning of a conversation between instructors and students, and between team members, on how their contributions are perceived by others. It is upto team members and instructors to find a common understanding of how much, and how well, each student has contributed.

## Objectives

### Short-term usability goals

- Pull data from Github API, clone repos
- Analyze blame data from git to generate team appraisal reports
- Display folder level praise reports
- Project (Github repository for a course project)
- Contributors (teammates/others contributing to a project)

### Long-term goals

- Perform static analysis of folders/files: e.g., flog, rubocop, reek for Ruby

## Setup

- Create a personal Github API access token with `public_repo` scope
- Copy `config/secrets_example.yml` to `config/secrets.yml` and update token
- Ensure correct version of Ruby install (see `.ruby-version` for `rbenv`)
- Run `bundle install`
- Rub `bundle exec rake db:migrate` to create dev database
- Rub `RACK_ENV=test bundle exec rake db:migrate` to create test database

## Running tests

To run tests:

```shell
rake spec
```
