# The platform contract

What a book must supply to be rendered by the lesson runtime, as documents. The code lives in
`snowch/digital-design` (`packages/lesson-schema`, `packages/lesson-runtime`) until a second book
consumes it; this directory is the contract's reference copy.

## The lesson data format

`lesson.schema.json` is the lesson format as JSON Schema (draft 2020-12), generated from the zod
schema the runtime validates with by `npm run schema` in the course repository. Regenerate it
there whenever the schema changes; a lesson that validates against this file parses in the
runtime, and the runtime's further checks (`checkLesson`) hold:

- the ten sections in the course's order: question, motivation, prediction, investigation,
  construction, failureExperiment, explanation, generalisation, challenge, reflection;
- every challenge mounted by a section, every challenge id unique, every test port declared by
  the challenge's interface, a reference solution present, a write-graded challenge allowing at
  least one construct;
- an `originalityNote` on every lesson.

## What a book supplies

A `Book` (see `packages/lesson-runtime/src/book.ts`): an id that namespaces learner state, the
lessons, a registry of interactives by kind, an editor for a challenge's artifact, a grader from
challenge and artifact to a verdict, and a note per time model. The verdict's shape is the one the
runtime renders: pass or fail per test, the inputs, what the artifact gave, what was expected, and
where the disagreement first appears.

## The interaction vocabulary

Inspect, predict, step, experiment, break, explain, drill down, replay. Each lesson's figures are
views of the book's own model, never scripted animations; a figure's answer comes from running the
model. `docs/inventory.md` in the course repository records which pattern came from which book.
