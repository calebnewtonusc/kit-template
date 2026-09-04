# The standard

**apply-kit and accommodations-kit are the bar.** Every kit built from this template
meets it or it does not ship.

```
sh tools/kit-check.sh
```

Nineteen checks. Both reference kits pass all nineteen with no warnings. A fresh clone of
this template fails five, which is correct: an empty spine is not a kit.

## Where the numbers come from

Nothing here is invented. Each floor is the weaker of the two reference kits, so both
clear it comfortably and a folder of markdown with a CLAUDE.md on top does not.

| | apply-kit | accommodations-kit | floor |
| --- | --- | --- | --- |
| CLAUDE.md lines | 314 | 229 | 150 |
| Phases | 10 | 11 | 8 |
| Reference briefs | 6 | 4 | 3 |
| Domain plays | 25 | 7 | 4 |
| Domain tools | 1 | 1 | 1 |
| README lines | 270 | 111 | 80 |

## What the checker enforces

**The marker is filled and reads `ready`.** A kit nothing can discover gets rebuilt.
`use-when` needs several phrases in the words people actually type.

**All five override rules, and rule 5 is wired to `stale.sh`.** Fact expiry is the thing
that makes a kit beat a long prompt. Present but unused is decoration.

**Rule 4 names something the kit refuses to do**, and it appears in the README, not only
in CLAUDE.md, because the README is the only file a stranger reads.

**At least one domain tool doing this domain's arithmetic.** This is the check people try
hardest to argue their way around. If you believe your domain has no arithmetic, look
harder: days between dates, totals of a column, counts of anything. apply-kit counts
words because a model cannot. accommodations-kit checks whether a letter was actually
delivered and whether a booking window is about to close, which is the entire failure the
kit exists to prevent.

**Every tool runs clean on a fresh checkout**, exit 0 or 1, never a crash.

**The README says what the kit will not do, has troubleshooting, and tells a beginner how
to start.** Somebody arrives frightened and short on time. A README that assumes they
already have Claude Code running loses them before the first question.

**No em dashes, no leftover placeholders.**

## What a person still has to judge

The checker measures shape. It cannot read, and shape is not the thing that makes those
two kits good. Four questions, and a kit that passes nineteen checks while failing these
is a worse kit than one that fails a check and passes them.

**1. Does the opening question earn its place?** Phase 0 gets exactly one question, and
it decides whether somebody stays. It is almost never "tell me about yourself." In both
reference kits it is the clock, because the clock changes everything downstream. Read
yours and ask whether a tired person at 11pm would answer it or close the terminal.

**2. Do the interview questions get at something nobody has asked them before?** This is
the whole value and it is where a kit is genuinely hard to write. "I have ADHD" is not a
request; "in a room where other people are typing I lose the thread of a question and
reread it four or five times" is. Getting from the first to the second is the work.
A kit that recites its domain and asks nothing is a reference document with extra steps.

**3. Does it name where people actually fail, not where the process starts?**
accommodations-kit is built around delivery and booking windows rather than registration,
because almost nobody fails at registration. apply-kit spends its effort on extraction
rather than writing, because writing was never the bottleneck. Find your equivalent and
build the middle of the kit around it. If you do not know what it is, you are not ready
to write the kit yet.

**4. Would the hard line leave the kit worth opening?** Rule 4 should remove the
dangerous capability and leave the useful one. If following it exactly makes the kit
pointless, it is drawn wrong.

## Before you call one finished

```
sh tools/kit-check.sh                              nineteen checks, zero failures
kits                                               it appears, and not as a template
printf '{"prompt":"<a real sentence>","cwd":"/"}' | ~/.claude/hooks/kit-route.sh
```

That last one is the difference between a kit that exists and a kit that gets used.
Silence means `use-when` is written in your words rather than theirs. Fix the marker.

Then read the four questions above and answer them honestly, out loud, to the person you
built it for.
