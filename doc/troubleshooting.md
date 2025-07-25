# 💪 Troubleshooting

## Lint-Staged

### Task concurrency

By default lint-staged will run tasks concurrently. All tasks will be started at the same time; then, for each task, all commands run in sequence.

⚠️ Pay extra attention when the configured globs overlap, and tasks make edits to files.

When the `pre-commit` git hook invokes `lint-staged`, we can disable concurrency adding `--concurrent false` to the invocation.

> See [Task concurrency](https://github.com/lint-staged/lint-staged?tab=readme-ov-file#task-concurrency)
