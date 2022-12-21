# 💪 Troubleshooting

## Lint-Staged

### Task concurrency

By default lint-staged will run configured tasks concurrently. This means that for every glob, all the commands will be started at the same time.

Pay extra attention when the configured globs overlap, and tasks make edits to files. For example, in our [configuration](.lintstagedrc) `lint-markdown` and `toc-markdown` might try to make changes to the same `Readme.md` file at the same time, causing a race condition.

This is why in our [pre-commit](/.husky/pre-commit) git hook, lint-staged concurrency is disabled with `--concurrent false`

### Debugging Mode

To debug yarn commands and send the output to a file for later inspection, you can run:

```sh
yarn lint-staged -d > lint-staged-debug.txt 2>&1
```

- `-d` : Tells yarn to output debug information
- `> lint-staged-debug.txt` : Redirects the stdout stream to the lint-staged-debug.txt file. > is shorthand for 1>
- `2>&1` : This uses the &> redirect instruction. This instruction allows you to tell the shell to make one stream got to the same destination as another stream. In this case, we’re saying “redirect stream 2, stderr, to the same destination that stream 1, stdout, is being redirected to.”

### Other Errors

- Check that [.gitignore](.gitignore) is not including or excluding external packages by mistake.
Folders `.yarn/cache` and `node_modules` are excluded in this repo.
