#!/bin/sh
# ~/.config/starship/git-push-watch.sh
# Pushes to origin, watches CI, notifies on completion, refreshes starship prompt

set -e

# Push to origin
echo "⏫ Pushing to origin..."
git push "$@"

# Make sure there's a PR for this branch
if ! gh pr view --json number --jq '.number' >/dev/null 2>&1; then
  echo "No PR found for this branch."
  exit 0
fi

pr_number=$(gh pr view --json number --jq '.number')
echo "👀 Watching CI for PR #${pr_number}..."

# Watch checks until they complete, capture output
checks_output=$(gh pr checks --watch 2>&1) || true

# Parse results
failed=""
while IFS= read -r line; do
  case "$line" in
    *fail*)
      failed="${failed}${line}
"
      ;;
  esac
done <<EOF
$checks_output
EOF

# Force refresh starship prompt cache
touch ~/.cache/starship-pr/force

# Report results
if [ -n "$failed" ]; then
  echo ""
  echo "❌ Some checks failed:"
  echo "$checks_output"
  echo ""
  echo "🔗 Failed check links:"
  # Extract URLs from failed lines
  echo "$failed" | while IFS= read -r line; do
    [ -z "$line" ] && continue
    name=$(echo "$line" | awk '{print $1}')
    url=$(echo "$line" | grep -oE 'https://[^ ]+')
    if [ -n "$url" ]; then
      # Print as OSC 8 clickable link
      printf '\033]8;;%s\033\\  %s: %s\033]8;;\033\\\n' "$url" "$name" "$url"
    fi
  done
  # Desktop notification via OSC 777
  printf '\033]777;notify;CI Failed;PR #%s has failing checks\033\\' "$pr_number"
else
  echo ""
  echo "✅ All checks passed for PR #${pr_number}"
  # Desktop notification via OSC 777
  printf '\033]777;notify;CI Passed;PR #%s all checks green\033\\' "$pr_number"
fi
