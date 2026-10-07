# Adopting the platform

How a course uses these packages, what the move from `snowch/digital-design` generalised, and how
the digital-design course switched to the moved packages.

## What a course brings

- Its model: whatever its figures run (a circuit simulator, a data platform).
- Its figures, by kind, each checking its own props.
- An editor for its challenges' artifacts, and a grader that turns an artifact into a verdict.
- A note for each model its figures run, which the runtime shows behind each figure's badge.
- Optionally, a role for each figure (what it asks of the reader) and a note for each role: the
  runtime then names the role in the figure's badge, and shows the role's note before the model's.
- Its own shell (routes, front page, look) and, optionally, its own words for the runtime's labels
  through `LessonView`'s `strings` prop.

## How a course takes the packages

As a copy at a recorded commit: `platform/` with `platform/SOURCE.json`, written by the course's
`scripts/sync-platform.mjs` from a clean checkout of this repository, and a check that the copy is
unedited. Both courses take it so. This repository is public, so a git submodule would also work;
the copy is kept because cloning, building and deploying a course then need no second checkout. A
fix to the platform is made here, checked here, and then synced into each course.

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

Done on 6 October 2026, once the author had made this repository public and agreed, on
`snowch/digital-design`'s branch `claude/metadata-systems-agent-promotion-ggb2lv`: its three
packages replaced by a checked copy in `platform/`, taken as the metadata course takes it, and
every import renamed from `@dd/` to `@platform/`. No commit had touched the three packages there
since the move, so the switch lost nothing. Its strict type check, its unit and integration suite
(92 files, 897 tests, these packages' own included) and its build pass; its browser suite is CI's
to decide, because its screenshot baselines were made on CI's runner.

The cross-book job `digital-design-on-this-platform` syncs this repository's current packages into
that course once the switch reaches the ref it tests, and until then overlays them and renames the
imports, as the switch did. It stays: like the metadata course's job, it checks every change here
against the course before the course takes it.
