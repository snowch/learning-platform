# Learning platform

The interactive technical-learning platform shared by the author's books and the digital-design
course. What is shared is the **interaction vocabulary** (inspect, predict, step, experiment,
break, explain, drill down, replay) and the **lesson data format**, not a code library or a look.

**Status: Prompt A, Phase 1.** Nothing is built yet. The inventory that decides what this
repository holds is in the course repository:
[`snowch/digital-design`, `docs/inventory.md`](https://github.com/snowch/digital-design/blob/ccr-12defae1-l9pdzb/docs/inventory.md).

## Proposed role of this repository

Recommended in the inventory (section 5.7) and awaiting the author's decision at Checkpoint 1:

- During Prompt A, all code lives in `snowch/digital-design` as an npm-workspaces monorepo whose
  platform candidates (`lesson-schema`, `lesson-runtime`, `primitives`) are separate packages from
  the first commit.
- This repository holds the platform **contract** as documents: the vocabulary, the lesson data
  format once Phase 2 designs it, and the adoption guide for a future book.
- This repository also holds the **cross-book regression job**: one workflow with a job per
  repository (`parquet-book`, `query-engine-book`, `computer-systems`, `digital-design`) that runs
  each repository's own suite and fails if any is red. The books are never modified by this work.
- The platform packages move here when a second book consumes them, and not before. That is the
  prompt's rule of two applied to repositories, and it matches the author's own precedent of
  extracting the books' shared tooling only once both are stable.

## Why the books are patterns, not code

The Parquet book runs Rust compiled to WebAssembly; the query-engine book runs Python under
Pyodide; both are Make + Python + MyST sites with labs in plain ES modules. The course is
TypeScript with Vite and React. The inventory studies the books for which interactions work and
how lessons, tests and traces are presented, and extracts no code from them.
