# jekyll-deploy-action

A GitHub Action to deploy the Jekyll site conveniently for GitHub Pages.

## Story
As we known, GitHub Pages runs in `safe` mode and only allows [a set of whitelisted plugins](https://pages.github.com/versions/). To use the gem in GitHub Pages, you need to build locally or use CI (e.g. [travis](https://travis-ci.org/), [github workflow](https://help.github.com/en/actions/configuring-and-managing-workflows/configuring-a-workflow)) and deploy to your `gh-pages` branch.

Therefore, if you want to make Jekyll site run as if it were local, such as let
the custom plugins work properly, this action can be very useful for you,
beacause it's really convenient to build and deploy the Jekyll site to Github
Pages.

## Usage

For this, you should configurate a github workflow (e.g. `.github/workflows/`) as below:

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
        - uses: jeffreytse/jekyll-deploy-action@master
          with:
            provider: 'github'
            auth_token: ${{ secrets.GITHUB_TOKEN }}
            repository: ''             # default is current repository
            branch: 'gh-pages'         # default is gh-pages for github provider
            jekyll_src: './'           # default is root directory
            jekyll_cfg: '_config.yml'  # default is _config.yml
```

## Credits

- [Jekyll](https://github.com/jekyll/jekyll) - A blog-aware static site generator in Ruby.

## Contributing

Issues and Pull Requests are greatly appreciated. If you've never contributed to an open source project before I'm more than happy to walk you through how to create a pull request.

You can start by [opening an issue](https://github.com/jeffreytse/jekyll-deploy-action/issues/new) describing the problem that you're looking to resolve and we'll go from there.

## License

This software is licensed under the [MIT license](https://opensource.org/licenses/mit-license.php) © JeffreyTse.
