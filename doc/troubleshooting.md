# 💪 Troubleshooting

## Nodejs

### Nodejs And Yarn Upgrades

After upgrading Nodejs or Yarn, you may need to install the dependencies again:

```sh
make install
```

### Yarn Debugging Mode

To debug yarn commands and send the output to a file for later inspection, run:

```sh
yarn lint-staged -d > lint-staged-debug.txt 2>&1
```

- `-d` : Tells yarn to output debug information
- `> lint-staged-debug.txt` : Redirects the stdout stream to the lint-staged-debug.txt file. &gt; is shorthand for 1&gt;
- `2>&1` : This uses the &amp;&gt; redirect instruction. This instruction allows you to tell the shell to make one stream got to the same destination as another stream. In this case, we’re saying “redirect stream 2, stderr, to the same destination that stream 1, stdout, is being redirected to.”

### Other Errors

- Check that [.gitignore](../.gitignore) is not including or excluding external packages by mistake.
Folders `.yarn/cache` and `node_modules` are excluded in this repo.

## Lint-Staged

### Task concurrency

By default lint-staged will run tasks concurrently. All tasks will be started at the same time; then, for each task, all commands run in sequence.

⚠️ Pay extra attention when the configured globs overlap, and tasks make edits to files.

When the `pre-commit` git hook invokes `lint-staged`, we can disable concurrency adding `--concurrent false` to the invocation.

> See [Task concurrency](https://github.com/lint-staged/lint-staged?tab=readme-ov-file#task-concurrency)
