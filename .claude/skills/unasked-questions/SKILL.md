---
name: unasked-questions
description: Find the question a prompt is really asking under the one it states, and write it under every prompt in an application file. Use when extracting questions from an application, before drafting, and when auditing a draft.
---

# The unasked question

Every prompt has a stated ask and an unstated one. **The unstated one is what gets
scored.** An org asks "tell us about a time you worked on a team" and decides
something about you that has nothing to do with teams.

This is the single highest-leverage thing in the kit. Do it for every prompt in every
application file, before any drafting starts.

## How to find it

Ask four questions about the prompt:

**1. What decision is this org making with this answer?** Not "what do they want to
know." What are they deciding. A pro-bono consulting org asking about a social issue
is deciding whether you will still show up in week nine of an unglamorous project.

**2. What is the failure mode they are screening out?** Every prompt exists because
somebody bad got in once. "Describe a conflict with a teammate" exists because they
admitted someone who could not be told they were wrong.

**3. What does this specific org worry about, given who applies to them?** A startup
org worries about people who love the idea of startups. A service org worries about
résumé-builders. An org that rejected you last year is asking, without saying it,
what is different now.

**4. What will the reader think and never write down?** If the applicant has shipped
real things, the reader is quietly asking whether this person will take direction. If
the applicant is a freshman, whether they will follow through. Name that.

## How to write it

Under each prompt in the `applications/` file, in a quoted block:

```markdown
### Q2. Describe a product that changed how you think or act. (200 words)

> **Unasked:** Do you have taste, or do you just consume? Anyone can name an app they
> like. They want evidence you notice mechanism: why it works on you, what it was
> designed to do, whether you can separate the two. And underneath: is your interest
> in building things actually about anything, or is it about wanting to have built
> something.
```

Rules for these blocks:

- Two to four sentences. Longer and it stops being usable at write time.
- Name the decision, not the theme. "They are deciding whether you can be told you are
  wrong" beats "this is about teamwork."
- If the honest read is uncomfortable, write it anyway. That is the entire value.
- One per prompt, including the fun ones. Especially the fun ones.

## Patterns worth knowing

These run under prompts in nearly every type:

| Stated prompt                   | Usually unasked                                                 |
| ------------------------------- | --------------------------------------------------------------- |
| Why us                          | Why not the five others you are obviously also applying to      |
| Tell us about yourself          | Can you pick one thing and go deep, or do you list              |
| A time you failed               | Can you look at yourself honestly without turning it into a win |
| A challenge you overcame        | Do you know the difference between hard and inconvenient        |
| A time you disagreed            | Can you be wrong out loud                                       |
| What do you want to learn       | Are you here to learn or to be impressive                       |
| Your strengths and weaknesses   | Do you know how you are hard to work with                       |
| Reapplying? Tell us more        | What is actually different since we told you no                 |
| Optional additional materials   | Do you take the free opportunity or not                         |

The optional-materials one deserves emphasis. Declining an optional invitation while
reapplying answers the real question badly. Almost nobody takes it, which is exactly
why taking it works.

**Then read the table in this application's `reference/` file.** Each type has its own
set, and they are more useful than the general list because they carry what that
specific kind of reader worries about. A `grant` reviewer reading your budget and a
`student-org` officer reading your favorite snack are both asking something, and it is
not the same something.

## Using them

**Before drafting:** read the unasked list for that question first. It usually changes
which story you pick, not just how you tell it.

**After drafting:** hand a reader only your answer, nothing else. Could they answer
each unasked question from it? Three misses is your revision, and the revision is
usually a swap of story rather than a rewrite of sentences.

## Roll the repeats up

When the same unasked question runs under prompts at four different orgs, put it in
`applications/INDEX.md` once, at the top, instead of repeating the analysis. Those
repeated ones are the real shape of the whole cycle, and seeing them together tells
the applicant what they are actually being evaluated on this fall.
