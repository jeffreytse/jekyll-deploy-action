<div align="center">
  <br>

  <a href="https://github.com/jeffreytse/jekyll-deploy-action">
    <img alt="jekyll-theme-yat →~ jekyll" src="https://user-images.githubusercontent.com/9413601/107134556-211ea280-692e-11eb-9d13-afb253db5c67.png" width="600">
  </a>

  <p>🪂 A GitHub Action to deploy the Jekyll site conveniently for GitHub Pages.</p>

  <br>

  <h1> JEKYLL DEPLOY ACTION </h1>

</div>

<h4 align="center">
  <a href="https://jekyllrb.com/" target="_blank"><code>Jekyll</code></a> action for deployment.
</h4>

<p align="center">

  <a href="https://jeffreytse.github.io/jekyll-deploy-action">
    <img src="https://github.com/jeffreytse/jekyll-deploy-action/workflows/Tests/badge.svg"
      alt="Tests" />
  </a>

  <a href="https://github.com/jeffreytse/jekyll-deploy-action/releases">
    <img src="https://img.shields.io/github/v/release/jeffreytse/jekyll-deploy-action?color=brightgreen"
      alt="Release Version" />
  </a>

  <a href="https://opensource.org/licenses/MIT">
  <img src="https://img.shields.io/badge/License-MIT-brightgreen.svg"
  alt="License: MIT" />
  </a>

  <a href="https://liberapay.com/jeffreytse">
  <img src="http://img.shields.io/liberapay/goal/jeffreytse.svg?logo=liberapay"
  alt="Donate (Liberapay)" />
  </a>

  <a href="https://patreon.com/jeffreytse">
  <img src="https://img.shields.io/badge/support-patreon-F96854.svg?style=flat-square"
  alt="Donate (Patreon)" />
  </a>

  <a href="https://ko-fi.com/jeffreytse">
  <img height="20" src="https://www.ko-fi.com/img/githubbutton_sm.svg"
  alt="Donate (Ko-fi)" />
  </a>

</p>

<div align="center">
  <sub>Built with ❤︎ by
  <a href="https://jeffreytse.net">jeffreytse</a> and
  <a href="https://github.com/jeffreytse/jekyll-deploy-action/graphs/contributors">contributors </a>
</div>

## ✨ Story

As we known, GitHub Pages runs in `safe` mode and a [set of allow-listed plugins](https://pages.github.com/versions/). To use the gem in GitHub Pages, you need to build locally or use CI (e.g. [travis](https://travis-ci.org/), [github workflow](https://help.github.com/en/actions/configuring-and-managing-workflows/configuring-a-workflow)) and deploy to your `gh-pages` branch.

**Therefore, if you want to make Jekyll site run as if it were local, such as let
the custom plugins work properly, this action can be very useful for you,
beacause it's really convenient to build and deploy the Jekyll site to Github
Pages.**

## 📚 Usage

At First, you should add a github workflow file (e.g. `.github/workflows/build-jekyll.yml`) in your repository's `master` branch as below:

```yml
name: Build and Deploy to Github Pages

on:
  push:
    branches:
      - master  # Here source code branch is `master`, it could be other branch

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      # Use GitHub Actions' cache to cache dependencies on servers
      - uses: actions/cache@v2
        with:
          path: vendor/bundle
          key: ${{ runner.os }}-gems-${{ hashFiles('**/Gemfile.lock') }}
          restore-keys: |
            ${{ runner.os }}-gems-

      # Use GitHub Deploy Action to build and deploy to Github
      - uses: jeffreytse/jekyll-deploy-action@v0.4.0
        with:
          provider: 'github'
          token: ${{ secrets.GITHUB_TOKEN }} # It's your Personal Access Token(PAT)
          repository: ''             # Default is current repository
          branch: 'gh-pages'         # Default is gh-pages for github provider
          jekyll_src: './'           # Default is root directory
          jekyll_cfg: '_config.yml'  # Default is _config.yml
          jekyll_baseurl: ''         # Default is according to _config.yml
          bundler_ver: '>=0'         # Default is latest bundler version
          cname: ''                  # Default is to not use a cname
          actor: ''                  # Default is the GITHUB_ACTOR
          pre_build_commands: ''     # Installing additional dependencies (Arch Linux)
          skip_deploy: ''            # Skip the Deploy Step - only build
```

To schedule a workflow, you can use the POSIX cron syntax in your workflow file.
The shortest interval you can run scheduled workflows is once every 5 minutes.
For example, this workflow is triggered every hour.

```yml
on:
  schedule:
    - cron:  '0 * * * *'
```

At the start of each workflow run, GitHub automatically creates a unique
`GITHUB_TOKEN` secret to use in your workflow. You can use the `GITHUB_TOKEN`
to authenticate in a workflow run. You can use the `GITHUB_TOKEN` by using the
standard syntax for referencing secrets: `${{ secrets.GITHUB_TOKEN }}`. For
more information, you can see [here](https://docs.github.com/en/actions/security-guides/automatic-token-authentication).

If you need a token that requires permissions that aren't available in the
`GITHUB_TOKEN`, you can create a Personal Access Token (PAT), and set it as
a secret in your repository for this action to push to the `gh-pages` branch:

- Create a [Personal Access Token](https://github.com/settings/tokens) with custom permissions and copy the value.
- Go to your repository’s Settings and then switch to the Secrets tab.
- Create a token named `GH_TOKEN` (important) using the value copied.

In the end, go to your repository’s Settings and scroll down to the GitHub Pages
 section, choose the `gh-pages` branch as your GitHub Pages source.

Additionally, if you don't have the `gh-pages` branch, you can create it as below:

```bash
git checkout --orphan gh-pages
git rm -rf .
git commit --allow-empty -m "initial commit"
git push origin gh-pages
```

**💡 Tip:** The `gh-pages` branch is only for the site static files and the `master` branch is for source code.

If you use [jekyll-last-modified-at](https://github.com/gjtorikian/jekyll-last-modified-at) plugin, you can configure the checkout action to fetch all commit history so that plugin could use the last Git commit date to determine a page's last modified date.

```yaml
- uses: actions/checkout@v3
  with:
    # The checkout action doesn't provide a way to get all commit history for a single branch
    # So we use the magic number 2147483647 here which means infinite depth for git fetch
    # See https://github.com/actions/checkout/issues/520, https://stackoverflow.com/a/6802238
    fetch-depth: 2147483647
```

## 🌱 Credits

- [Jekyll](https://github.com/jekyll/jekyll) - A blog-aware static site generator in Ruby.
- [actions/checkout](https://github.com/actions/checkout) - Action for checking out a repo.
- [actions/cache](https://github.com/actions/cache) - Cache dependencies and build outputs in GitHub Actions.

## ✍️  Contributing

Issues and Pull Requests are greatly appreciated. If you've never contributed to an open source project before I'm more than happy to walk you through how to create a pull request.

You can start by [opening an issue](https://github.com/jeffreytse/jekyll-deploy-action/issues/new) describing the problem that you're looking to resolve and we'll go from there.

## 🌈 License

This software is licensed under the [MIT license](https://opensource.org/licenses/mit-license.php) © JeffreyTse.
