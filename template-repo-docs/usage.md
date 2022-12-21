# ⚡ Usage

## Makefile Targets

If you run `make` from the terminal, it will provide you with a comprehensive menu of all the commands available to you.

Targets can be combined together in the same command, and even override variables when running the command from the shell; i.e.:

```sh
make spell-check lint-markdown toc-markdown VERSION_CSPELL=6.14.2 VERSION_MARKDOWNLINT=v0.5.1
```

Reference: [A brief introduction to what makefiles are](https://dev.to/sensorario/a-brief-introduction-to-what-makefiles-are-3fb1)

## Clean-up

You may clean up your local resources (Node packages, Docker containers, etc.) as much as you need, running:

```sh
make clean
```

 You can always re-install things again with:

 ```sh
 make install-deps
 ```

## Creating A Release

We'll use [standard-version](https://github.com/conventional-changelog/standard-version) Node package to automate `CHANGELOG` generation.

```sh
make create-release
```

**Requirements :**

- Your remote repository must be set in `package.json` with `npm pkg set repository.url='github:user/repo'`
- The release branch must exist in the remote repository
- By default, `main` and `master` are the only branches allowing releases
- There must be some _releasable_ commit (i.e.: `style:` or `revert:` are NOT, while `feat:` or `fix:` are)

## Upgrading Dependencies

To upgrade any **Node package** in particular, run:

```sh
yarn up package-name
yarn up package-name@1.2.3
```

To upgrade all outdated packages, first install the [interactive-tools](https://yarnpkg.com/features/plugins#official-plugins) plugin:

```sh
yarn plugin import interactive-tools
```

And then, run the interactive upgrade

```sh
yarn upgrade-interactive
```

---

**Docker images** used in this repository use the `latest` label by default. To change them, set the appropriate constant variable in the Makefile.
