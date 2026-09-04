# /refresh

Read back the facts that have gone stale and confirm each one is still true.

**This is a play you run yourself, not something they ask for.** Run it when a session
opens and the briefing reports stale facts, and always before a submission.

## Why this exists

The honesty guard stops you inventing things. It does nothing about a true fact that
expired. Those are the ones that get through, because nothing about them looks wrong:
they were checked, they were sourced, they were accurate the week they were written.

The failure looks like this. Somebody tells you in week one they are taking eighteen
units. They drop a class at add/drop. Six weeks later four documents say eighteen units,
every check passes, and the number is false. Then somebody asks them in person and the
answer does not match what they submitted.

That specific failure is why this command exists. It shipped in a real cycle, in
apply-kit, and it is the reason every kit built from this template inherits rule 5.

## Run it

```
sh tools/stale.sh
```

Exit 1 means something needs confirming. The output names the file, the fact, and how
old it is. A window other than the default three weeks: `sh tools/stale.sh 45`.

## How to ask

**Read the facts back. Do not re-interview.** They already answered these questions and
being asked again reads as the tool forgetting them.

One message, the stale facts only, in a form they can answer in a single line:

> Four things I want to confirm before this goes out, since it has been a few weeks:
>
> 1. Course load: 16 units this term
> 2. GPA: 3.7
> 3. Blue Modern, still active
> 4. Club: 30 members
>
> Which of these have changed? "all good" is a fine answer.

Rules:

- **Never more than six at once.** Take the oldest and the ones that feed the
  thing you are actually working on right now. The rest can wait.
- **Never include a fact that is current.** Padding the list with things you already
  know teaches them the check is noise.
- **Never ask them to re-derive a number.** You are asking whether it changed, not
  where it came from.
- One message, then get back to work. This is a checkpoint, not a phase.

## Then write it down

For every fact they confirm, update the `Checked` column to today. For every fact they
correct, change the value **and** the date, then find everywhere the old value appears:

```
grep -rn "<old value>" work/ you/
```

**A corrected fact that only gets fixed in `PROFILE.md` is not fixed.** The old value is
already sitting in three other files. Fix all of them in the same turn and say which
files you touched.

If something already went out with the old value, say so plainly and say what it costs.
Usually it costs one sentence, said first rather than after being caught. Do not let them
find that out in the room.

## The one thing not to do

Do not run this on a cold start. Nothing is stale on day one, and opening with a
verification pass on somebody who has not written anything yet is the exact
bureaucratic feeling this kit exists to avoid.
