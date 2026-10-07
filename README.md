# Learning platform

The interactive technical-learning platform shared by the author's courses. What is shared is the
**interaction vocabulary** (inspect, predict, step, experiment, break, explain, drill down,
replay), the **lesson data format**, and, since a second course consumed them, the **code** that
renders lessons in that format.

**Status.** The platform's packages moved here on 6 October 2026, when the metadata-systems course
(`snowch/metadata-systems`) became their second consumer, as the digital-design course's inventory
planned: "The platform packages move to `learning-platform` when a second book consumes them, and
not before" ([`snowch/digital-design`, `docs/inventory.md`, section 5.7](https://github.com/snowch/digital-design/blob/main/docs/inventory.md)).

## The packages

| Package | What it holds |
| --- | --- |
| `packages/lesson-schema` (`@platform/lesson-schema`) | the lesson data format as zod schemas: ten sections in a fixed order, interactives by kind, challenges with their tests, five hints and a reference, the originality note; the checks beyond shape (`checkLesson`), the term gate (`termProblems`), the model gate (`modelProblems`), and the format as JSON Schema (`lessonJsonSchema`) |
| `packages/lesson-runtime` (`@platform/lesson-runtime`) | a lesson rendered from its data: the sections, the figures' badges (a figure's role, or the model it runs) and their notes, the challenge runner with its verdicts, the hint ladder, learner state kept in the browser and graded again on every load |
| `packages/primitives` (`@platform/primitives`) | the shared interaction primitives, extracted from the digital-design course under the rule of two: `PredictionChallenge`, `FaultInjector`, `Stepper`, `Timeline`, `StateInspector`, `DrillDown` |

A course brings its own model, figures, editor and grader, and gives the runtime a `Book`
(`packages/lesson-runtime/src/book.ts`). `docs/adoption.md` says how a course adopts the platform,
what the move generalised, and how the digital-design course switches to these packages.

```sh
npm ci
npm run check     # exactly what CI runs: Prettier, the copyright line, tsc, Vitest, and a check
                  # that contract/lesson.schema.json is what the schema generates
```

## The contract

`contract/` holds the lesson data format as JSON Schema, generated from the zod schema by `npm run
-s schema`, and a note on what a course supplies to the runtime. See `contract/README.md`.

## The cross-book regression job

`.github/workflows/cross-book.yml` runs, on request and weekly, one job per repository from a
fresh checkout of its default branch: the digital-design course's `npm run check`, each book's own
suite as far as a hosted runner can run it, the metadata-systems course's `npm run check`, and
two jobs that run each course against this repository's current packages, which is the regression
check for a change to the platform. A red job is a regression in that course, not in this
repository, which never modifies a course.

## The courses

- `snowch/digital-design`: *Digital Design: From Bits to a Working Computer*. The platform was
  built with it, and it still carries its own copy of the packages under their old `@dd/` names
  until it switches (`docs/adoption.md`).
- `snowch/metadata-systems`: *Metadata Systems: From Raw Files to a Working Metadata Platform*.
  It takes the packages as a copy at a recorded commit (its `platform/SOURCE.json`), checked
  unedited on every run of its check.

## Why the books are patterns, not code

The Parquet book runs Rust compiled to WebAssembly; the query-engine book runs Python under
Pyodide; both are Make + Python + MyST sites with labs in plain ES modules. They share the
interaction vocabulary and the lesson shape with the courses, studied as patterns; no code is
extracted from them.
