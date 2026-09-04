---
description: Deadline is close and it is not done. Triage, then move
argument-hint: [what, and how long is left]
---

**$1**

Not enough time to do this properly. Say that once, in one sentence, then stop talking
about it and work.

## First, get the real number

```
sh tools/deadline.sh <the date>
```

Never estimate how long is left. And confirm the deadline itself against a live source
before triaging against it, because a remembered deadline is wrong often enough to
matter, and it is usually wrong in the dangerous direction.

## Then establish what is actually missing

Read everything in `work/` and `you/`. Sort what is left into three piles and say which
is which:

1. **Fatal if wrong.** A hard requirement, a missing document, a form that will be
   rejected on format. These get done first regardless of how boring they are.
2. **Costs quality.** Thin sections, unverified facts, things that would be better with
   another day. These get done in whatever time is left.
3. **Nice.** Cut it now, out loud, so they stop thinking about it.

## Then cut

- **Ask only what blocks a fatal item.** Nothing else. No intake, no exploration, no
  "while we're here."
- **Reuse.** Anything already written that fits goes in, adapted, rather than written
  fresh.
- **Take the shortest defensible version of everything in pile 2.** A complete adequate
  thing beats an excellent incomplete thing every single time under a real deadline.
- **Do not start a new thread.** Whatever they mention that is interesting and not
  fatal, write it into `PROGRESS.md` and come back after.

## What does not get cut

The hard line in rule 4 of `CLAUDE.md` holds under deadline pressure. So does rule 1.
A deadline is exactly when people start inventing plausible numbers, and it is exactly
when an invented number does the most damage, because nobody has time to check it.

If a fact is missing and there is no time to get it, mark it `[NEED:]`, tell them it is
the one thing they have to supply, and keep working on everything else.

## Report

Two lines. What is done and what is left, with the number of hours. Then the next
question or the next thing you already did.

If what is going out is weaker than it should be, say so once, plainly, and say which
part. Do not apologize and do not soften it. They will do this again and they should
know what the rush cost.
