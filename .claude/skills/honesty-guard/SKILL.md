---
name: honesty-guard
description: Never fabricate a fact about the applicant, keep numbers consistent across every document, and respect org AI bans. Use during drafting, /truth, and before any submission.
---

# Honesty guard

Two failure modes, both expensive, both preventable.

## 1. Fabrication

**Never invent a number, a title, a date, an outcome, a name, or a feeling.** Not as a
placeholder you plan to fix. Not because it is probably about right. Not because the
sentence reads better with a number in it.

When a draft needs a detail you do not have:

```
I ran the event for [NEED: how many attendees] students across
[NEED: how many schools, and are you counting schools or orgs?] campuses.
```

Then list every `[NEED:]` at the bottom of the draft file. A draft with six markers is
a good draft. A plausible invented figure is a failure, and it is the kind that
surfaces in an interview when someone asks "how did you get that number?"

The same rule covers feelings and motives. Do not write that something moved them, or
that they realized anything, unless they said so. Write `[NEED: what did you actually
think when that happened]`.

## 2. Numbers that drift

The same claim appears on the resume, in four essays, and in the interview. **If it
grows between documents, that is what gets caught.**

Run this check as part of `/truth`:

1. Pull every number, title, and date from `you/PROFILE.md`, the resume in
   `you/uploads/`, and every file in `drafts/`.
2. Group by claim.
3. Report any claim with more than one value, in a table, showing where each came from.
4. Ask which one is defensible, and make sure the answer includes what it counts.
   "Twenty orgs" and "eleven schools" can both be true and are not the same claim.
5. Write the chosen version into `you/PROFILE.md` under **Canonical numbers**, and use
   it everywhere without exception.

A smaller number they can walk someone through beats a bigger one they cannot. This is
also self-interest, not just integrity: orgs that score humility are exactly the ones
where an inflated figure does the most damage.

## Claims to flag even when true

Some true statements read bigger than the underlying thing, and the interview is where
that gets tested. Flag these for the applicant to decide on:

- **A plan described in the past tense.** "Secured seven clients for spring" when the
  clients are a target. An interviewer will ask them to walk through an engagement
  that has not happened.
- **A round accuracy figure on a small dataset.** Invites "what was your split?"
- **A multiplier with no baseline.** "6.3x more meetings" invites "from what to what?"
- **A tool listed as a skill they would not want to be quizzed on.** Some applications
  ask which technical skill you want to be evaluated on. Anything on the page is an
  invitation.
- **A title whose scope changed.** Founder, president, lead. If someone else runs it
  now, the tense matters.

Say it once, give the reasoning, and accept their answer. **They know their own work
better than any file in this repo does.** If they say a claim is accurate, it is
accurate, and the right move is to correct the repo rather than restate the doubt.

## 3. Org AI bans

Before drafting anything, check the `AI policy:` field in that org's
`applications/` file. See `AI-POLICY.md` for the three settings.

If it is `banned`, say so plainly in one sentence and switch modes. Do not draft "just
a rough version they can rewrite." That is the ban with extra steps.

In banned mode you still: interview them until they know what they think, argue the
weak side of their argument back at them, tell them where the essay actually starts,
count words, run mock interviews, and read the draft they wrote and say what a
stranger will notice.

If the policy field is empty, ask them to check the form before drafting. Do not guess.

## 4. Format requirements are part of honesty too

Not integrity exactly, but the same class of avoidable loss. Every org file has a
**Format** section. Before submitting, verify:

- File type. Almost everyone wants PDF, and a `.md` or `.pages` file fails silently.
- Filename convention. These differ per org and often include commas or underscores
  in a specific order.
- Page limit. If an org says one page, it means one page.
- Link permissions. If they want a link, open it in a private window first. Orgs that
  warn twice about permissions do so because people keep failing it.
- Word limits, counted, per answer.
