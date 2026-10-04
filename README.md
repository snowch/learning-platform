# Learning platform

The interactive technical-learning platform shared by the author's books and the digital-design
course. What is shared is the **interaction vocabulary** (inspect, predict, step, experiment,
break, explain, drill down, replay) and the **lesson data format**, not a code library or a look.

**Status: Prompt A, Checkpoint 3.** The platform packages and the first lesson are built in the
course repository, `snowch/digital-design`, on its `ccr-12defae1-l9pdzb` branch. This repository
holds the cross-book regression workflow (`.github/workflows/cross-book.yml`) and, from
Checkpoint 4, the platform contract as documents. The inventory that decided this is
[`snowch/digital-design`, `docs/inventory.md`](https://github.com/snowch/digital-design/blob/ccr-12defae1-l9pdzb/docs/inventory.md);
the lesson data format it contracts is `packages/lesson-schema` there, exported as JSON Schema by
`lessonJsonSchema()`.

## The contract

`contract/` holds the lesson data format as JSON Schema, generated from the course's zod schema,
and a note on what a book supplies to the runtime. See `contract/README.md`.

## The cross-book regression job

`.github/workflows/cross-book.yml` runs, on request and weekly, one job per repository from a
fresh checkout of its default branch: the course's `npm run check`, and each book's own suite as
far as a hosted runner can run it (the inventory's section 2 records what needs a cross compiler,
QEMU or MyST and is left out). A red job is a regression in that book, not in this repository,
which never modifies a book. The `digital_design_ref` input points the course's job at a branch.

## Role of this repository

Recommended in the inventory (section 5.7) and approved by the author at Checkpoint 1:

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
