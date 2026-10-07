# The platform contract

What a course must supply to be rendered by the lesson runtime. The code is `packages/` in this
repository; this directory is the contract as documents.

## The lesson data format

`lesson.schema.json` is the lesson format as JSON Schema (draft 2020-12), generated from the zod
schema in `packages/lesson-schema` by `npm run -s schema > contract/lesson.schema.json`. The check
fails if the file is not what the schema generates. A lesson that validates against this file
parses in the runtime, and the runtime's further checks (`checkLesson`) hold:

- the ten sections in this order: question, motivation, prediction, investigation, construction,
  failureExperiment, explanation, generalisation, challenge, reflection;
- every challenge mounted by a section, every challenge id unique, a reference solution present;
- for a circuit challenge (the digital-design course): every test port declared by the challenge's
  interface, and a write-graded challenge allowing at least one construct;
- for an answers challenge: fields to answer, answer tests, a reference that answers every field,
  and, for a `choice` field, options that include the reference's answer;
- for a written or drawn challenge graded case by case: a `text` or `data` reference, and no
  circuit limits;
- an `originalityNote` on every lesson.

A section may also carry `details`: the words of a control (`summary`, plain text) and the
Markdown it opens (`prose`). The runtime shows it closed, after the section's prose and before its
figures, in a `details` element of class `lesson-details` that the course styles. It is for detail
the section's next step does not need, kept where it first matters: the metadata course keeps how
its lab runs there, where its first chapter names the lab. The term gate reads it with the prose.

## What a course supplies

A `Book` (`packages/lesson-runtime/src/book.ts`): an id that namespaces learner state (stored keys
start `<id>:v1:`), the lessons, a registry of interactives by kind, an editor for a challenge's
artifact, a grader from challenge and artifact to a verdict, and a note per model its figures run.
A figure's `timeModel` is a name the course chooses (the digital-design course's `settle`,
`clocked` and `delay`; the metadata course's `lab`); `none` is reserved for a figure that runs
nothing, and `modelProblems` checks that every figure names a model the course declares. A course
gives a note for each model, which the runtime shows behind a model's badge and once at the foot of
every lesson that runs it; a course whose lessons explain the model in their own prose may give
none, and the foot then states none.

A figure may also declare a `role`: what it asks of the reader, in the course's own word for it
(the metadata course's `experiment`, `inspect` and `reference`). The runtime then badges the figure
by its role, from the strings' `lesson.role`, and the badge's note is the book's `roleNotes` entry
for the role alone: the model's note is stated once, at the foot, not again in every badge. A role
with no note gets a badge that opens nothing. A figure without a role is badged by its model, as
before; a course that declares no roles needs no `roleNotes`.

The verdict's shape is the one the runtime renders: pass or fail per test, the inputs, what the
artifact gave, what was expected, where the disagreement first appears, or a sentence of detail
for a failure that is not about one row.

## The interaction vocabulary

Inspect, predict, step, experiment, break, explain, drill down, replay. Each lesson's figures are
views of the course's own model, never scripted animations; a figure's answer comes from running
the model.
