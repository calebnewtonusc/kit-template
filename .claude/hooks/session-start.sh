#!/bin/sh
# Runs when a session starts. Prints the current state of this person's work into
# context so the agent opens knowing where things stand, instead of asking.
#
# Never fails. A broken briefing must not break the session.

cd "$(dirname "$0")/../.." 2>/dev/null || exit 0

filled() {
  # Every template ships with a "TEMPLATE: unfilled" marker. Whoever writes real
  # content into the file deletes the marker. No heuristics, no false positives.
  [ -f "$1" ] || return 1
  grep -q 'TEMPLATE: unfilled' "$1" 2>/dev/null && return 1
  return 0
}

count_md() { find "$1" -name '*.md' ! -name '_TEMPLATE.md' ! -name 'INDEX.md' ! -name 'README.md' 2>/dev/null | wc -l | tr -d ' '; }

echo "=== {{KIT NAME}}: where this person is right now ==="
echo ""

if [ -f PROGRESS.md ]; then
  echo "--- PROGRESS.md (the running state, keep it current) ---"
  sed -n '1,60p' PROGRESS.md
  echo ""
fi

echo "--- Detected on disk ---"
filled you/PROFILE.md && echo "profile:   filled" || echo "profile:   EMPTY (nothing known about them yet)"
[ -n "$(ls -A you/uploads 2>/dev/null | grep -v README)" ] && echo "uploads:   present, READ THEM before asking anything" || echo "uploads:   none"
echo "work:      $(count_md work) file(s) in progress"
filled you/OUTCOMES.md && echo "outcomes:  past rounds recorded, READ THEM before advising"

# Facts that were true when written and may not be now. Only meaningful once
# there is a filled profile, so a cold start never sees this.
if filled you/PROFILE.md; then
  STALE=$(sh tools/stale.sh 2>/dev/null | grep -oE '[0-9]+ stale, [0-9]+ never checked' | head -1)
  if [ -n "$STALE" ]; then
    case "$STALE" in
      "0 stale, 0 never checked") echo "facts:     all confirmed recently" ;;
      *) echo "facts:     $STALE. Run /refresh BEFORE relying on any of them." ;;
    esac
  fi
fi
echo ""

echo "--- How to open this session ---"
echo "The person using this does not know any commands and must never be asked to type one."
echo "Do not list options. Do not explain the system. Open with ONE question, the one whose"
echo "answer unblocks the most, per the phase rules in CLAUDE.md. Then keep the conversation"
echo "moving yourself: run the plays, write the files, and end every turn with either a"
echo "concrete question or the next thing you already did."
echo ""
echo "If everything above is EMPTY, this is a cold start. Ask the opening question in"
echo "CLAUDE.md phase 0 and nothing else."
echo ""
echo "If the facts line reports anything stale, run /refresh early, in one short message."
echo "A fact that was true in week one and is not true now will pass every other check here."
