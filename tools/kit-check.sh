#!/bin/sh
# Does this kit meet the standard set by apply-kit and accommodations-kit?
#
# "As good as those two" is a feeling until something checks it. Every floor
# below is measured from the weaker of the two, so both pass comfortably and a
# folder of markdown with a CLAUDE.md on top does not.
#
# Usage:
#   tools/kit-check.sh            check the kit in this directory
#   tools/kit-check.sh ../foo-kit check another one
#
# Exit 1 on any failure. Warnings do not fail the run but are worth reading.
#
# What it cannot check is whether the questions are good, which is most of what
# makes a kit worth opening. See STANDARD.md for the part a person has to judge.

K="${1:-.}"
cd "$K" 2>/dev/null || { echo "No such directory: $K"; exit 2; }
NAME=$(basename "$(pwd)")

FAIL=0; WARN=0; PASS=0
fail() { FAIL=$((FAIL+1)); echo "  FAIL  $1"; }
warn() { WARN=$((WARN+1)); echo "  warn  $1"; }
ok()   { PASS=$((PASS+1)); echo "  pass  $1"; }

echo ""
echo "Checking $NAME against the kit standard"
echo ""

# --- The marker -----------------------------------------------------------
if [ ! -f .kit ]; then
  fail ".kit marker missing, so nothing can ever discover this kit"
else
  grep -q '{{' .kit && fail ".kit still has placeholders, so routing skips it" \
                    || ok ".kit marker filled in"
  grep -q '^status: ready' .kit && ok "status: ready" \
    || fail "status is not 'ready', so this kit is excluded from routing"
  UW=$(grep -m1 '^use-when:' .kit | sed 's/^use-when: *//')
  case "$UW" in
    "") fail "no use-when line, so a prompt can never match this kit" ;;
    *,*,*) ok "use-when has several phrases" ;;
    *) warn "use-when has fewer than three phrases; routing needs the words people actually type" ;;
  esac
fi

# --- The phase machine ----------------------------------------------------
if [ ! -f CLAUDE.md ]; then
  fail "no CLAUDE.md, which is the kit"
else
  L=$(wc -l < CLAUDE.md | tr -d ' ')
  [ "$L" -ge 150 ] && ok "CLAUDE.md is $L lines" \
    || fail "CLAUDE.md is only $L lines; the reference kits are 229 and 314"
  P=$(grep -c '^\*\*Phase [0-9]' CLAUDE.md)
  [ "$P" -ge 8 ] && ok "$P phases" \
    || fail "only $P phases; the reference kits have 10 and 11"
  grep -q '^\*\*5\.' CLAUDE.md && ok "all five override rules present" \
    || fail "rule 5 missing; facts expiring is what makes a kit beat a long prompt"
  grep -qiE 'never (diagnose|say|tell|draft|advise|write)|will not|does not (practice|tell)' CLAUDE.md \
    && ok "rule 4 names something this kit refuses to do" \
    || fail "no hard line found; every kit needs one thing it refuses to do"
  grep -q 'stale.sh' CLAUDE.md && ok "CLAUDE.md wires in stale.sh" \
    || fail "nothing runs stale.sh, so rule 5 is decoration"
fi

# --- Reference briefs -----------------------------------------------------
R=$(ls reference/*.md 2>/dev/null | grep -v 'README' | wc -l | tr -d ' ')
R=${R:-0}
if [ "$R" -ge 3 ]; then ok "$R reference briefs"
elif [ "$R" -ge 2 ]; then warn "$R reference briefs; the reference kits have 4 and 6"
else fail "$R reference briefs; a kit with one reader is usually a skill"
fi

# --- Plays ----------------------------------------------------------------
C=$(ls .claude/commands/*.md 2>/dev/null | wc -l | tr -d ' ')
INHERITED=0
for i in status gaps picks refresh panic outcome; do
  [ -f ".claude/commands/$i.md" ] && INHERITED=$((INHERITED+1))
done
DOMAIN=$((C - INHERITED))
[ "$DOMAIN" -ge 4 ] && ok "$DOMAIN domain plays on top of $INHERITED inherited" \
  || fail "only $DOMAIN domain plays; the reference kits have 7 and 25"

# --- Arithmetic -----------------------------------------------------------
DT=0
for t in tools/*.sh; do
  [ -f "$t" ] || continue
  case "$(basename "$t")" in stale.sh|deadline.sh|kit-check.sh) ;; *) DT=$((DT+1)) ;; esac
done
[ "$DT" -ge 1 ] && ok "$DT domain tool(s) doing this domain's arithmetic" \
  || fail "no domain tool; if you think your domain has no arithmetic, look harder"

# kit-check.sh is excluded here on purpose. Running it would run itself, which
# recurses until the shell gives up. That is not hypothetical: the first version
# of this loop hung for two minutes before anyone noticed.
for t in tools/*.sh; do
  [ -f "$t" ] || continue
  case "$(basename "$t")" in kit-check.sh) continue ;; esac
  sh "$t" >/dev/null 2>&1
  code=$?
  [ "$code" -le 1 ] || fail "$(basename "$t") exits $code on a clean checkout"
done
ok "every tool runs on a clean checkout"

# --- The README, which is the only thing a stranger reads -----------------
if [ ! -f README.md ]; then
  fail "no README, so nobody knows what this is"
else
  RL=$(wc -l < README.md | tr -d ' ')
  [ "$RL" -ge 80 ] && ok "README is $RL lines" \
    || warn "README is only $RL lines; the reference kits are 111 and 270"
  grep -qiE 'will not|does not|refuses' README.md \
    && ok "README states what this kit will not do" \
    || fail "README never says what it refuses to do; that belongs where users read it"
  grep -qi 'troubleshoot' README.md && ok "README has troubleshooting" \
    || warn "no troubleshooting section; every reference kit has one"
  grep -qiE 'claude\.com/product/claude-code|claude\.com/download|install claude' README.md \
    && ok "README tells a beginner how to start" \
    || warn "README assumes they already have Claude Code running"
fi

# --- The start: one paste, in the Code tab --------------------------------
# On 2026-10-27 a first-time user spent an hour on a setup repo and hit five
# walls: she was in the chat tab, which can't touch her computer; she clicked
# through browser steps a script could do; a sign-in window hid behind Claude;
# and the docs described files the repo no longer had. These checks are the
# parts of that a script can see.
if [ -f README.md ]; then
  # The first section has to name the tab, so it's checked in the opening lines.
  if head -40 README.md | grep -q 'Code tab' \
     && awk '/^ *```/{inb=!inb; next} inb && /github\.com\//{f=1} END{exit !f}' README.md; then
    ok "README opens with which tab to use and a paste prompt"
  else
    fail "README has no start section naming the Code tab with one paste-ready prompt (see MAKING-A-KIT.md, The start)"
  fi
  grep -qiE 'pop ?-?up|separate window|behind (the )?claude' README.md \
    && ok "README warns about windows and prompts before they appear" \
    || warn "README never warns about popups, password prompts or separate windows"
  grep -qi 'snag' README.md \
    && ok "README asks the first person through for a snag list" \
    || warn "README never asks the first person through to write up their snags"

  # Drift: every play and tool the README names has to exist today.
  MISSING=""
  for c in $(grep -oE '`/[a-z][a-z0-9-]*`' README.md | tr -d '`/' | sort -u); do
    [ -f ".claude/commands/$c.md" ] || MISSING="$MISSING /$c"
  done
  for t in $(grep -oE 'tools/[A-Za-z0-9_.-]+' README.md | sed 's/\.*$//' | sort -u); do
    [ -e "$t" ] || MISSING="$MISSING $t"
  done
  [ -z "$MISSING" ] && ok "every play and tool the README names exists" \
    || fail "README names things this repo doesn't have:$MISSING"

  KN=$(grep -m1 '^name:' .kit 2>/dev/null | sed 's/^name: *//')
  case "$KN" in
    ""|*'{{'*) ;;
    *) grep -qE "github\.com/[A-Za-z0-9_-]+/$KN([^A-Za-z0-9_-]|\$)" README.md \
         && ok "README links this kit's own repo ($KN)" \
         || fail "README never links github.com/<owner>/$KN, so the paste prompt points somewhere else" ;;
  esac
fi

# --- House writing rules --------------------------------------------------
if grep -rlq '—' --include='*.md' . 2>/dev/null; then
  fail "em dashes present: $(grep -rl '—' --include='*.md' . | head -3 | tr '\n' ' ')"
else
  ok "no em dashes"
fi

# An unfilled template is supposed to hold placeholders; that is what the
# TEMPLATE: unfilled marker means. Only files without it are suspect.
STRAY=""
for f in $(grep -rl '{{' --include='*.md' . 2>/dev/null); do
  case "$f" in *_TEMPLATE*) continue ;; esac
  grep -q 'TEMPLATE: unfilled' "$f" 2>/dev/null && continue
  STRAY="$STRAY $f"
done
if [ -n "$STRAY" ]; then
  warn "placeholders left in:$STRAY"
else
  ok "no leftover placeholders"
fi

# --- Session briefing -----------------------------------------------------
[ -x .claude/hooks/session-start.sh ] || [ -f .claude/hooks/session-start.sh ] \
  && ok "session-start briefing present" \
  || fail "no session briefing, so a returning session opens blind"

echo ""
echo "$PASS passed, $WARN warning(s), $FAIL failure(s)."
if [ "$FAIL" -gt 0 ]; then
  echo ""
  echo "Not at standard yet. The bar is apply-kit and accommodations-kit; see STANDARD.md."
  exit 1
fi
echo "At standard. The part no script can check is in STANDARD.md, under What a person still has to judge."
