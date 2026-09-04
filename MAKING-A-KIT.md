# Making a kit

Everything here is the part that does not change. What you add is the domain.

## First: should this be a kit at all?

Most things should not. A kit is a repo somebody lives inside for weeks, and building one
around a task that finishes in an afternoon just adds ceremony to a prompt.

Seven properties. Something with five or more is kit-shaped. Something with two is a
skill, and you should write a single `SKILL.md` instead and be done in an hour.

1. **It spans sessions.** Days or weeks. State has to survive a closed laptop.
2. **The bottleneck is extraction, not generation.** The person has the material and
   cannot get it out. Nobody ever asked them the right question.
3. **There is a hidden evaluator.** Somebody scores this against criteria that are not
   written on the form.
4. **There is a mechanical constraint the model reliably fails.** Word counts, date
   arithmetic, dollar totals, page limits. Something that needs a real script.
5. **It is rare and high-stakes.** They do it once every few years, so they have no
   instincts and no way to build them.
6. **Facts must stay consistent across many artifacts.** One canonical set feeding a
   dozen documents.
7. **A professional would run a process, and most people do not know the process
   exists.**

Property 4 is the one people skip, and skipping it is why most kits are just folders of
markdown. If there is no arithmetic in your domain that an agent gets wrong, look harder
before you decide there is none. Days between dates, totals of a column, counts of
anything: those are all places a model will confidently produce a wrong number.

## What you are actually writing

Five things. In rough order of how much they matter:

**1. The phases in `CLAUDE.md`.** This is the kit. Everything else supports it. A phase
is not a chapter heading, it is a rule for deciding what to ask next given what is
already known. Write them so that an agent reading `PROGRESS.md` can locate itself
without asking the person where they are.

**2. The opening question.** Phase 0 gets exactly one question, and picking it well is
most of the difference between a kit that works and one that gets abandoned in the first
session. It is almost never "tell me about yourself." It is usually the clock, because
the clock decides everything downstream. Ask what they are facing and when it has to be
done, then shut up and listen.

**3. `reference/`, one file per variant.** The method is usually the same across
variants and the evaluator is not. Advice tuned for one reader produces bad work for
another. One file each, and the agent reads only the one that applies.

**4. `tools/`, the arithmetic.** `stale.sh` and `deadline.sh` ship with this template and
work in any domain. Add whatever else your domain counts. Write them in POSIX `sh` with
no gawk extensions and no `date -d`, so they run the same on macOS, Linux and Git Bash.
Every one of them should exit non-zero on a real problem so it can gate a step.

**5. Rule 4, the hard line.** Every kit needs one thing it refuses to do, named
explicitly, with what it does instead. Apply-kit will not write a sentence you submit to
an org that bans AI. A medical kit does not diagnose and does not touch dosing. A legal
kit does not tell you what your rights are, it helps you get organized enough to ask
somebody who knows. Write yours before you write anything else, because it shapes every
other file, and a kit without one will eventually do real damage to somebody.

## What you inherit and should not rewrite

- **The conversation rules.** Never ask permission, drive the conversation, three to five
  questions at a time, pick lists the moment answers get thin.
- **`PROGRESS.md` and the session-start hook.** State across sessions, and the briefing
  that means a returning session never asks "where were we."
- **The `TEMPLATE: unfilled` convention.** Every template ships with the marker. Whoever
  writes real content deletes it. The hook reads the markers to work out what exists. No
  heuristics, no false positives.
- **Rules 1, 2, 3 and 5.** Do not invent facts about them, do not invent facts about the
  other party, do not ask what is already answered, and facts expire.
- **`stale.sh` and the `Checked` columns.** Rule 5's enforcement.
- **`no-slop-writing`.** Applies to the agent's own messages, not only to output.

## The file layout

```
CLAUDE.md          The phase machine. The kit itself
PROGRESS.md        Running state. The agent keeps it current, the person never touches it
you/               Everything about them. PROFILE is the canonical facts, with Checked dates
work/              The actual artifacts in progress, one file per thing
reference/         One brief per variant. The agent reads only the one that applies
tools/             The arithmetic. stale.sh and deadline.sh ship with the template
.claude/commands/  Your plays. The person never types these
.claude/skills/    Loaded on trigger
.claude/hooks/     The session briefing
```

Rename `work/` to whatever your domain calls the thing. Apply-kit splits it into
`applications/` and `drafts/` because the questions and the answers are different
artifacts with different lifetimes. Most kits do not need that split.

## Writing the phases

A phase answers: **given what is known, what is the one thing that should happen next?**

The template ships with a shape that fits most domains:

- **0. Cold start.** One question. Usually the clock.
- **1. Triage on time.** Under 48 hours is a different kit than three weeks out. Say
  which mode you are in, once, then work.
- **2. Material.** Get what only they have. This is where most of the value is and it is
  the phase people rush.
- **3 through 5.** Your domain. Usually: understand the real requirement, fill the gaps,
  produce the thing.
- **6. Check.** Run the checking plays yourself and report findings, not activity.
- **7. Act.** They send it, file it, or walk in.
- **8. After.** Record the outcome so next time starts from evidence.

Anything with its own clock jumps the queue. In apply-kit that is recommender letters,
because other people's calendars do not wait for your process. Name yours in the phases
section or it will get skipped.

## The bar

apply-kit and accommodations-kit. Not "something in this shape," those two specifically.
`tools/kit-check.sh` measures the shape and [STANDARD.md](STANDARD.md) carries the four
questions it cannot measure. Read both before you decide you are finished.

## Testing it before you hand it to anybody

Four checks, all of which have caught real bugs:

```
sh .claude/hooks/session-start.sh      cold start briefing is correct and not alarming
sh tools/stale.sh                      exits 0 on empty templates, 1 on stale data
sh tools/deadline.sh                   handles no dates, past dates, and sorts correctly
python3 -c "import json;json.load(open('.claude/settings.json'))"
```

```
grep -n "{{" .kit      must come back empty, and status must read: ready
kits                   your kit must appear in the list
```

**The `.kit` marker is the difference between a kit and a folder.** A clone starts with
`status: template`, which excludes it from routing on purpose so a half-built kit never
catches live work. If you never change it, your finished kit is invisible to every future
session and somebody eventually rebuilds it.

Then simulate a ZIP download, because that is how most people will get it and it strips
the executable bit off every script:

```
tar --exclude=.git -cf - . | (cd /tmp/kittest && tar xf -)
chmod 644 /tmp/kittest/tools/*.sh
cd /tmp/kittest && sh tools/stale.sh && sh .claude/hooks/session-start.sh
```

Everything has to work invoked as `sh tools/whatever.sh`. Never document a bare
`./tools/whatever.sh` as the only way to run something.

Last, fill in a fake profile with one deliberately stale fact and confirm the briefing
surfaces it. The cold-start path and the returning-user path are different code paths and
only one of them gets exercised while you are building.

## The mistake to avoid

The temptation is to write a lot of domain knowledge into `reference/` and call it done.
That produces a kit that knows things and does not do anything.

The value is in the questions, the state, and the arithmetic. A kit that asks four good
questions and remembers the answers beats a kit that recites the whole domain and asks
nothing.
