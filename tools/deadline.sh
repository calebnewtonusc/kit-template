#!/bin/sh
# Days until every dated thing this person is facing.
#
# The agent cannot do date arithmetic. This can. Anything in the kit that says
# "you have N days" gets N from here.
#
# Usage:
#   tools/deadline.sh              everything, soonest first
#   tools/deadline.sh 2026-10-01   days until one date
#
# Reads any markdown table row containing a YYYY-MM-DD, in PROGRESS.md,
# you/*.md and work/*.md. The first cell of the row is used as the label.
#
# Exit 1 if anything is overdue or due within 48 hours, so it can gate a session.
#
# Portable on purpose: no gawk extensions, no `date -d`, no GNU-only flags, so it
# behaves the same on macOS, Linux and Git Bash.

TODAY=$(date +%Y-%m-%d)

DAYS_AWK='
function days(d,   y, m, dd, era, yoe, doy, doe) {
  y  = substr(d, 1, 4) + 0
  m  = substr(d, 6, 2) + 0
  dd = substr(d, 9, 2) + 0
  if (y == 0 || m == 0 || dd == 0) return -999999
  y -= (m <= 2)
  era = int((y >= 0 ? y : y - 399) / 400)
  yoe = y - era * 400
  doy = int((153 * (m + (m > 2 ? -3 : 9)) + 2) / 5) + dd - 1
  doe = yoe * 365 + int(yoe / 4) - int(yoe / 100) + doy
  return era * 146097 + doe - 719468
}
'

# One date, asked directly.
if [ -n "$1" ]; then
  awk -v today="$TODAY" -v target="$1" "$DAYS_AWK"'
  BEGIN {
    n = days(target) - days(today)
    if (n < -900000)  { printf "%s is not a YYYY-MM-DD date.\n", target; exit 2 }
    if (n < 0)        printf "%s was %d day(s) ago.\n", target, -n
    else if (n == 0)  printf "%s is today.\n", target
    else              printf "%s is in %d day(s).\n", target, n
    exit (n < 2 ? 1 : 0)
  }'
  exit $?
fi

FILES=$(find PROGRESS.md you work -name '*.md' 2>/dev/null | sort)

# Drop any file still carrying the unfilled-template marker. This must happen
# here and not inside awk: the marker sits at the bottom of a template, so an
# awk rule would only see it after already processing every row above it.
KEEP=""
for f in $FILES; do
  grep -q 'TEMPLATE: unfilled' "$f" 2>/dev/null && continue
  KEEP="$KEEP $f"
done
FILES="$KEEP"
[ -z "$FILES" ] && { echo "Nothing dated yet."; exit 0; }

# Pass 1 emits "<delta>\t<date>\t<label>\t<file>", sort orders it, pass 2 formats.
awk -v today="$TODAY" "$DAYS_AWK"'
BEGIN { nowdays = days(today) }
/^\|/ {
  if ($0 !~ /[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/) next
  n = split($0, c, /\|/)
  label = c[2]
  gsub(/^[ \t*]+|[ \t*]+$/, "", label)
  if (label == "") next
  if (tolower(label) ~ /^(what|item|thing|fact|org|name|date)$/) next
  match($0, /[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/)
  d = substr($0, RSTART, RLENGTH)
  f = FILENAME
  sub(/^.*\//, "", f)
  printf "%d\t%s\t%s\t%s\n", days(d) - nowdays, d, label, f
}
' $FILES | sort -n -k1,1 | awk '
BEGIN { print "" }
{
  delta = $1 + 0
  split($0, p, "\t")
  if (delta < 0)       { status = sprintf("%d day(s) OVERDUE", -delta); overdue++ }
  else if (delta == 0) { status = "TODAY"; urgent++ }
  else if (delta < 2)  { status = sprintf("in %d day(s)", delta); urgent++ }
  else                   status = sprintf("in %d day(s)", delta)
  printf "  %-10s  %-34s %-22s %s\n", p[2], substr(p[3], 1, 34), status, p[4]
  n++
}
END {
  printf "\n%d dated item(s). %d overdue, %d inside 48 hours.\n", n+0, overdue+0, urgent+0
  if (overdue + urgent > 0) {
    print "Lead with these. Do not open on anything else."
    exit 1
  }
}'
