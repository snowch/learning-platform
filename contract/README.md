# The platform contract

What a course must supply to be rendered by the lesson runtime. The code is `packages/` in this
repository; this directory is the contract as documents.

## The lesson data format

`lesson.schema.json` is the lesson format as JSON Schema (draft 2020-12), generated from the zod
schema in `packages/lesson-schema` by `npm run -s schema > contract/lesson.schema.json`. The check
fails if the file is not what the schema generates. The generated schema checks the lesson's
shape; `parseLesson` also applies the runtime's semantic checks (`checkLesson`):

- by default, all ten sections in this order: question, motivation, prediction, investigation,
  construction, failureExperiment, explanation, generalisation, challenge, reflection; an explicit
  `sectionLayout: "selected"` permits a nonempty ordered subset, with no repeated section kind;
- every challenge mounted by a section, every challenge id unique, a reference solution present;
- for a circuit challenge (the digital-design course): every test port declared by the challenge's
  interface, and a write-graded challenge allowing at least one construct;
- for an answers challenge: fields to answer, answer tests, a reference that answers every field,
  and, for a `choice` field, options that include the reference's answer;
- for a written or drawn challenge graded case by case: a `text` or `data` reference, and no
  circuit limits;
- an `originalityNote` on every lesson.

`sectionLayout` defaults to `"full"`. Its schema branch requires exactly ten sections and a
nonempty `modelVsReality` string, as before; omitting the new field does not relax those rules.
The explicit `"selected"` branch permits one to ten sections and an empty `modelVsReality`
string. The runtime omits the model-versus-reality aside for that empty string. The field remains
a required string in both branches. Section order and uniqueness are checked by `checkLesson`;
JSON Schema alone does not check them. Existing challenge-reference checks still apply to every
selected section.

A lesson's objectives are inline Markdown, one line each: code between backticks is drawn as the
prose draws it (through the strings' `code`, where a course gives one), inside the objective's list
item, with no paragraph.

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

A lesson may set `showTimeModelNotes: false` when its own prose already explains the model.
This hides the automatic model-note footer and the model-note control on figures. A simulated
figure still has its static model badge, and role badges and their notes are unchanged. The
option does not hide figures, challenges or the lesson's separate `modelVsReality` text. It
defaults to `true`, preserving the existing rendering for courses that do not use the option.

A grader should give a verdict for any artifact, with `blocked` for one it cannot test. Saved work
is graded again whenever a challenge mounts and whenever a book's list of lessons calls
`verifyCompletion`, so the runtime does not trust a grader not to throw: `gradeSafely` turns a throw
into a verdict that says the tests could not run, with the error's message, and a challenge whose
editor throws while drawing the saved work keeps its buttons, so "Clear work" can draw it afresh. A
course's list of lessons should call `verifyCompletion`, or `gradeSafely`, rather than its grader.

A figure may also declare a `role`: what it asks of the reader, in the course's own word for it
(the metadata course's `experiment`, `inspect` and `reference`). The runtime then badges the figure
by its role, from the strings' `lesson.role`, and the badge's note is the book's `roleNotes` entry
for the role alone: the model's note is stated once, at the foot, not again in every badge. A role
with no note gets a badge that opens nothing. A figure without a role is badged by its model, as
before; a course that declares no roles needs no `roleNotes`.

A course may replace any of the runtime's strings through LessonView's `strings` prop, and may
give `code`, a component that draws inline code in prose (a mark before a name, say); without it
the words are rendered plain. A prediction figure built on the primitives' `PredictionChallenge`
may pass `renderLabel` to draw its options' labels the same way. The learner's work is kept in a
`Storage` with `get`, `set`, `remove` and `keys`; `resetBook(storage, bookId)` forgets every
lesson's work for one book, so a course can offer to start the whole course again.

The verdict's shape is the one the runtime renders: pass or fail per test, the inputs, what the
artifact gave, what was expected, where the disagreement first appears, or a sentence of detail
for a failure that is not about one row.

## The interaction vocabulary

Inspect, predict, step, experiment, break, explain, drill down, replay. Each lesson's figures are
views of the course's own model, never scripted animations; a figure's answer comes from running
the model.
