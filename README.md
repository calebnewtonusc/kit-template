# Kit Template

The spine for building a **kit**: a repo somebody lives inside for weeks while an agent
walks them through a process they have never done before and will not do again for years.

This is not a kit. It is what is left after you take the domain out of one.

## Start here: one paste, in the Code tab

Open the Claude desktop app ([download it here](https://claude.com/download)) and click
the `</>` icon at the top left to switch to the Code tab. The regular chat tab can't
touch your computer, so it can't copy this repo or write files, and it may tell you to
connect GitHub in Settings, Connectors. You don't need that: this repo is public, so
copying it needs no GitHub account. The Code tab needs a paid Claude plan (Pro or
higher).

Pick your home folder as the folder to work in, and paste this, with your idea in the
last line:

```
Build me a new kit from https://github.com/calebnewtonusc/kit-template.
Copy it with git clone into a new folder in my home folder named after the
kit, delete its .git and start a fresh repo. Before anything pops up (a
window, a password prompt, a sign-in), tell me what it is and what to click.
Then read MAKING-A-KIT.md, run its seven-property test on my idea, and if it
passes, build the kit until sh tools/kit-check.sh has zero failures. The idea:
```

What can pop up, so nothing surprises you:

- On a Mac that has never used developer tools, a macOS window asking to install the
  Command Line Tools (that's where `git` comes from). It can open behind the Claude
  window, so check the Dock if nothing seems to happen. Click Install and wait.
- Claude asking permission to run a command or edit a file. Allow it; that's the work.

Nothing here asks for a password or a GitHub sign-in. If you're one of the first people
through, finish by saying "write a PDF to my Downloads folder listing every snag I hit"
and send it to Caleb, so the next person doesn't hit them.

## Skill or kit

There are thousands of Claude skills. A skill is one `SKILL.md` that loads when relevant,
fires once, and forgets. That is the right shape for most things.

A kit is different. It carries state between sessions, drives the conversation instead of
waiting for a prompt, and does arithmetic in real scripts because the model gets numbers
wrong. It is the right shape when somebody has to be walked through something over weeks,
under a deadline, where the cost of a wrong fact is high and they have no instincts to
fall back on.

Read [MAKING-A-KIT.md](MAKING-A-KIT.md) before you build one. It opens with a seven-point
test for whether your idea is kit-shaped, and most ideas are not.

## What you get

**A phase machine.** `CLAUDE.md` decides what happens next from what is already known,
so the person never has to know what stage they are at or what to ask for.

**State that survives a closed laptop.** `PROGRESS.md` plus a session-start hook that
briefs every new session on where things stand. Nobody is ever asked "where were we."

**Facts that expire.** `you/PROFILE.md` carries a `Checked` date on every fact, and
`tools/stale.sh` flags anything unconfirmed for three weeks. This exists because a true
fact going stale is a real failure mode that no honesty check catches, and it has already
shipped a false claim into a real application.

**Date arithmetic that is actually correct.** `tools/deadline.sh` sorts everything dated
in the repo and exits non-zero when something is overdue or inside 48 hours. Both tools
are POSIX `sh` with no gawk extensions and no `date -d`, so they behave the same on
macOS, Linux and Git Bash.

**Six plays that work in any domain.** `/status`, `/gaps`, `/picks`, `/refresh`,
`/panic`, `/outcome`. The person never types them.

**Four skills.** Honesty guard, unasked questions, reader POV, no-slop writing.

## Using it by hand

The paste above does this for you. In a terminal it's:

```
git clone https://github.com/calebnewtonusc/kit-template my-kit
cd my-kit && rm -rf .git && git init
```

Then replace every `{{PLACEHOLDER}}`:

```
grep -rn "{{" --include="*.md" --include="*.sh" . ; grep -n "{{" .kit
```

Start with `CLAUDE.md`. The phases are the kit and everything else supports them. Then
rule 4, your hard line, which is the one thing this kit refuses to do. Write that early,
because it shapes every other file.

**Finish with `.kit`, and change `status` to `ready`.** While it says `template` the
directory is deliberately excluded from routing, so a half-built kit never catches live
work. Leave it that way and your finished kit stays invisible forever.

## The standard

apply-kit and accommodations-kit are the bar, and `tools/kit-check.sh` enforces it:
twenty-four checks, with every floor measured from the weaker of those two, plus the
start section every kit's README opens with. Both pass all of them. A fresh clone of
this template fails five, which is the point.

The four things no script can check are in [STANDARD.md](STANDARD.md).

## Where this gets used from

Installed as part of [Chewbacca](https://github.com/calebnewtonusc/Chewbacca), whose
`kit-builder` skill runs the seven-property test and scaffolds from this repo. You do not
have to use Chewbacca; cloning directly works exactly the same.

## Built from

[apply-kit](https://github.com/calebnewtonusc/apply-kit), which walks somebody through
club, job, fellowship, grad school, grant and accelerator applications. Everything general
in it lives here now.

All glory to God! ✝️❤️
