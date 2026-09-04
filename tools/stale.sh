#!/bin/sh
# Find facts that have gone stale.
#
# The agent cannot do date arithmetic reliably and cannot be trusted to notice
# that something true in week one stopped being true in week six. This can.
#
# A fact does not have to be wrong to sink an application. It only has to have
# expired. A GPA moves, a role ends, a graduation date shifts, a course load
# changes at add/drop. The honesty guard stops the agent inventing things. This
# stops the applicant's own true statements from rotting.
#
# Usage:
#   tools/stale.sh          flag anything unchecked for more than 21 days
#   tools/stale.sh 45       use a different window
#
# Reads:
#   you/*.md          table rows with a "Checked" column holding YYYY-MM-DD
#   applications/*.md inline "checked YYYY-MM-DD" on org claims
#
# Exit 1 if anything is stale or undated, so it can gate a submission.

WINDOW="${1:-21}"
TODAY=$(date +%Y-%m-%d)

FILES=$(find you applications -name '*.md' ! -name '_TEMPLATE.md' 2>/dev/null | sort)

if [ -z "$FILES" ]; then
  echo "Nothing to check yet."
  exit 0
fi

awk -v window="$WINDOW" -v today="$TODAY" '
# Days since 1970 for a YYYY-MM-DD string. Civil-days algorithm, no system call,
# so it behaves the same on macOS, Linux and Git Bash.
function days(d,   y, m, dd, era, yoe, doy, doe) {
  y  = substr(d, 1, 4) + 0
  m  = substr(d, 6, 2) + 0
  dd = substr(d, 9, 2) + 0
  if (y == 0 || m == 0 || dd == 0) return -1
  y -= (m <= 2)
  era = int((y >= 0 ? y : y - 399) / 400)
  yoe = y - era * 400
  doy = int((153 * (m + (m > 2 ? -3 : 9)) + 2) / 5) + dd - 1
  doe = yoe * 365 + int(yoe / 4) - int(yoe / 100) + doy
  return era * 146097 + doe - 719468
}

function report(file, label, datestr,   age) {
  if (datestr == "") {
    undated++
    printf "  %-22s %-42s never checked\n", file, substr(label, 1, 42)
    return
  }
  age = nowdays - days(datestr)
  if (age > window) {
    stale++
    printf "  %-22s %-42s %s, %d days old\n", file, substr(label, 1, 42), datestr, age
  } else {
    fresh++
  }
}

BEGIN { nowdays = days(today); print "" }

FNR == 1 {
  file = FILENAME
  sub(/^.*\//, "", file)
  in_table = 0
  checked_col = 0
}

# Skip unfilled templates entirely. Nothing to go stale in a blank form.
/TEMPLATE: unfilled/ { skip[FILENAME] = 1 }

# Header row of a markdown table: learn which column holds the date.
/^\|/ && /[Cc]hecked/ && !/^\| *[-:]/ {
  n = split($0, cols, /\|/)
  checked_col = 0
  for (i = 2; i < n; i++) {
    h = cols[i]
    gsub(/[ \t*]/, "", h)
    if (tolower(h) == "checked") checked_col = i - 1
  }
  in_table = 1
  ncols = n
  next
}

/^\| *[-:]/ { next }

# Body row of a table that has a Checked column.
/^\|/ {
  if (!in_table || checked_col == 0 || skip[FILENAME]) next
  n = split($0, cols, /\|/)
  first = cols[2]; gsub(/^[ \t]+|[ \t]+$/, "", first)
  if (first == "") next
  val = cols[checked_col + 1]
  gsub(/[^0-9-]/, "", val)
  if (val !~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/) val = ""
  report(file, first, val)
  next
}

# A blank line ends a table.
/^[ \t]*$/ { in_table = 0; checked_col = 0 }

# Org claims carry their date inline rather than in a column.
/[Cc]hecked *[0-9]{4}-[0-9]{2}-[0-9]{2}/ {
  if (skip[FILENAME]) next
  line = $0
  match(line, /[0-9]{4}-[0-9]{2}-[0-9]{2}/)
  d = substr(line, RSTART, RLENGTH)
  claim = substr(line, 1, 60)
  gsub(/^[ \t>*-]+/, "", claim)
  report(file, claim, d)
}

END {
  printf "\n%d fact(s) current, %d stale, %d never checked.\n", fresh+0, stale+0, undated+0
  if (stale + undated > 0) {
    printf "\nRead these back and ask whether each is still true. Do not reword them,\n"
    printf "do not re-interview, and do not ask about anything already current.\n"
    exit 1
  }
  printf "Everything checked within %d days.\n", window
}
' $FILES
