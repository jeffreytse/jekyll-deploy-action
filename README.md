# jekyll-deploy-action

![Tests](https://github.com/jeffreytse/jekyll-deploy-action/workflows/Tests/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)

A GitHub Action to deploy the Jekyll site conveniently for GitHub Pages.

## Story

As we known, GitHub Pages runs in `safe` mode and only allows [a set of whitelisted plugins](https://pages.github.com/versions/). To use the gem in GitHub Pages, you need to build locally or use CI (e.g. [travis](https://travis-ci.org/), [github workflow](https://help.github.com/en/actions/configuring-and-managing-workflows/configuring-a-workflow)) and deploy to your `gh-pages` branch.

Therefore, if you want to make Jekyll site run as if it were local, such as let
the custom plugins work properly, this action can be very useful for you,
beacause it's really convenient to build and deploy the Jekyll site to Github
Pages.

## Usage

At First, you should configurate a github workflow file (e.g. `.github/workflows/build-jekyll.yml`) as below:

```yml
name: Build and Deploy to Github Pages

on:
  push:
    branches:
      - master

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v2

        # Use GitHub Actions' cache to cache dependencies on servers
        - uses: actions/cache@v1
          with:
            path: vendor/bundle
            key: ${{ runner.os }}-gems-${{ hashFiles('**/Gemfile.lock') }}
            restore-keys: |
              ${{ runner.os }}-gems-

        # Use GitHub Deploy Action to build and deploy to Github
        - uses: jeffreytse/jekyll-deploy-action@v0.1.0
          with:
            provider: 'github'
            auth_token: ${{ secrets.GITHUB_TOKEN }}
            repository: ''             # default is current repository
            branch: 'gh-pages'         # default is gh-pages for github provider
            jekyll_src: './'           # default is root directory
            jekyll_cfg: '_config.yml'  # default is _config.yml
```

To schedule a workflow, you can use the POSIX cron syntax in your workflow file. The shortest interval you can run scheduled workflows is once every 5 minutes. For example, this workflow is triggered every hour.

```yml
on:
  schedule:
    - cron:  '0 * * * *'
```

After this, we should provide permissions for this action to push to the `gh-pages` branch:

- Create a [Personal Token](https://github.com/settings/tokens) with repos permissions and copy the value.
- Go to your repository’s Settings and then switch to the Secrets tab.
- Create a token named `GH_TOKEN` (important) using the value copied.

Additionally, if you don't have the `gh-pages` branch, you can create it as below:

```bash
git checkout --orphan gh-pages
git rm -rf .
git commit --allow-empty -m "initial commit"
git push origin gh-pages
```

**💡 Tip:** The `gh-pages` branch is only for the site static files and the `master` branch is for source code.


## Credits

- [Jekyll](https://github.com/jekyll/jekyll) - A blog-aware static site generator in Ruby.
- [actions/checkout](https://github.com/actions/checkout) - Action for checking out a repo.
- [actions/cache](https://github.com/actions/cache) - Cache dependencies and build outputs in GitHub Actions.

## Contributing

Issues and Pull Requests are greatly appreciated. If you've never contributed to an open source project before I'm more than happy to walk you through how to create a pull request.

You can start by [opening an issue](https://github.com/jeffreytse/jekyll-deploy-action/issues/new) describing the problem that you're looking to resolve and we'll go from there.

## License

This software is licensed under the [MIT license](https://opensource.org/licenses/mit-license.php) © JeffreyTse.
