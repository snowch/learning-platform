# Adopting the platform

How a course uses these packages, what the move from `snowch/digital-design` generalised, and how
the digital-design course switches to the moved packages.

## What a course brings

- Its model: whatever its figures run (a circuit simulator, a data platform).
- Its figures, by kind, each checking its own props.
- An editor for its challenges' artifacts, and a grader that turns an artifact into a verdict.
- A note for each model its figures run, which the runtime shows behind each figure's badge.
- Its own shell (routes, front page, look) and, optionally, its own words for the runtime's labels
  through `LessonView`'s `strings` prop.

## How a course takes the packages

Either a copy at a recorded commit (the metadata-systems course: `platform/` with
`platform/SOURCE.json` and a check that the copy is unedited), or, once this repository is public,
a git submodule. A fix to the platform is made here, checked here, and then taken by each course.

## What the move generalised (6 October 2026)

The packages moved from `snowch/digital-design` at commit `1d89fab`. Their code is unchanged apart
from these additions, each backwards compatible:

- **Scope.** `@dd/lesson-schema`, `@dd/lesson-runtime` and `@dd/primitives` became
  `@platform/lesson-schema`, `@platform/lesson-runtime` and `@platform/primitives`.
- **Artifacts.** An artifact may hold `text` or structured `data`, beside a circuit, a library id,
  a hardware description and answers. A written or drawn challenge whose reference is `text` or
  `data` is graded case by case by the course's grader, with no circuit rules.
- **Answer fields.** A field may be a `choice` among options; its reference must be one of them.
- **Models.** `timeModel` is any non-empty name the course chooses; `none` is reserved and
  exported as `NO_MODEL`. `modelProblems(lessons, models)` lists figures that name a model the
  course has no note for.
- **Wording.** The validator's message for a written challenge that allows nothing no longer says
  "HDL".

## Proof that nothing the first course uses changed

With these packages overlaid on `snowch/digital-design` at `1d89fab` and its imports renamed from
`@dd/` to `@platform/`, its strict type check is clean and its unit and integration suite passes:
88 files, 872 tests. The cross-book workflow's `digital-design-on-this-platform` job repeats that
check on demand and weekly, against this repository's current packages.

## Switching the digital-design course to these packages

When the author chooses to, in `snowch/digital-design`:

```sh
# 1. Replace the three packages with this repository's, at a recorded commit.
for p in lesson-schema lesson-runtime primitives; do
  rm -rf packages/$p && cp -r ../learning-platform/packages/$p packages/$p
done
# 2. Rename the imports and the manifests' references.
grep -rl --include='*.ts' --include='*.tsx' --include='*.mts' --include='*.json' \
  -e '@dd/lesson-schema' -e '@dd/lesson-runtime' -e '@dd/primitives' \
  apps packages content tests scripts \
  | xargs sed -i 's#@dd/lesson-schema#@platform/lesson-schema#g;
                  s#@dd/lesson-runtime#@platform/lesson-runtime#g;
                  s#@dd/primitives#@platform/primitives#g'
# 3. Relink the workspaces and run the course's own check.
npm install && npm run check
```

Then, rather than keep a copy that can drift, take the packages the way the metadata course does
(a recorded copy checked unedited) or as a submodule, and delete the cross-book overlay job, which
would then test nothing new.
