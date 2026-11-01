# task-graph

A Claude Code mod: a live, git-log-style task graph in a pane beside the chat,
which you and Claude edit together. Claude records the outcomes you ask for as
tasks, claims one before working on it and completes it when done; you can
reorder, edit, cancel or "work on next" any task from the pane, and Claude is
told what you changed.

It lives in its own repo, [`avegancafe/claude-plugin-task-graph`](https://github.com/avegancafe/claude-plugin-task-graph),
and is listed in [`avegancafe-marketplace`](https://github.com/avegancafe/avegancafe-marketplace).
It was a mod in Juliet (`symlinked/home/.claude/mods/task-graph`) until 0.2.0;
its history came with it.

## Install

```
/plugin install task-graph@avegancafe-marketplace
```

Start a new session afterwards; the pane opens on its own, and `/task-graph`
reopens it.

## What it costs in tokens

- A short system-prompt section saying how to use the graph.
- The `tg_*` tools are deferred: their schemas load through ToolSearch only
  when Claude first uses them.
- The graph listing is attached to a prompt only when it changed since Claude
  last saw it (your edits in the pane, a new session, or after a compaction or
  `/clear`). Claude's own edits come back in its tool results instead.
- Native `TaskCreate` / `TaskUpdate` / `TaskList` write to the same graph.

## Contributing

The hooks module is [`hooks/register.tsx`](hooks/register.tsx); the `$.state`
contract is [`types/index.d.ts`](types/index.d.ts). Bump `version` in
[`.claude-plugin/plugin.json`](.claude-plugin/plugin.json) (minor for a feature,
patch for a fix) and open a PR. CI runs `claude plugin validate .` and
`claude plugin test .`. To type-check locally, load the mod once (the engine
writes `.claude-plugin/types/`), then add a `tsconfig.json` with
`{ "extends": "./.claude-plugin/types/tsconfig.json" }` and run `tsc -p .`.
Both are gitignored.

## Releasing

Merging a `plugin.json` version bump to `main` is the release.
[`release.yml`](.github/workflows/release.yml) then sends a `plugin-released` event to
`avegancafe-marketplace`, whose sync workflow updates this plugin's entry there.

It needs the `MARKETPLACE_DISPATCH_TOKEN` repo secret: a fine-grained PAT scoped to
`avegancafe/avegancafe-marketplace` only, with Contents read & write.

```bash
gh secret set MARKETPLACE_DISPATCH_TOKEN -R avegancafe/claude-plugin-task-graph
```

Without it the release run fails and the marketplace entry stops tracking new versions.
