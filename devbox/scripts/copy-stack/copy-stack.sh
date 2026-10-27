#!/usr/bin/env bash
# Put the open PR stack holding a branch or PR on the clipboard the way
# Graphite's "Copy stack" did: top first, one HTML line per PR with its
# diffstat, plus the markdown form as plain text (also printed).
#
# Usage: copy-stack [-C <repo-dir>] [--no-copy] [branch | pr-number | pr-url]
# Defaults to the current branch. Needs an authenticated gh, and jq.
set -euo pipefail

COPY=1
TARGET=""
MAX_DEPTH=40
while [[ $# -gt 0 ]]; do
	case "$1" in
	-C)
		cd "$2"
		shift 2
		;;
	--no-copy)
		COPY=0
		shift
		;;
	-h | --help)
		awk 'NR > 1 && !/^#/ { exit } NR > 1 { sub(/^# ?/, ""); print }' "$0"
		exit 0
		;;
	*)
		TARGET="$1"
		shift
		;;
	esac
done
[[ -n "$TARGET" ]] || TARGET=$(git rev-parse --abbrev-ref HEAD)

FIELDS='number,title,url,headRefName,baseRefName'
repo=$(gh repo view --json nameWithOwner -q .nameWithOwner)
trunk=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)

# The open PR whose head is $1, or nothing. On a double, the newest is live.
pr_for_head() {
	gh pr list --head "$1" --state open --limit 5 --json "$FIELDS" | jq -c 'sort_by(.number) | last // empty'
}

in_stack() {
	jq -e --arg h "$1" 'any(.[]; .headRefName == $h)' <<<"$stack" >/dev/null
}

if [[ "$TARGET" =~ ^https?:// || "$TARGET" =~ ^[0-9]+$ ]]; then
	target=$(gh pr view "$TARGET" --json "$FIELDS")
else
	target=$(pr_for_head "$TARGET")
fi
if [[ -z "$target" ]]; then
	echo "copy-stack: no open PR for $TARGET" >&2
	exit 1
fi

# Walk down to trunk, then up along the lowest-numbered child at each level.
stack="[$target]"
cur="$target"
depth=0
while ((depth++ < MAX_DEPTH)); do
	base=$(jq -r .baseRefName <<<"$cur")
	[[ "$base" != "$trunk" ]] || break
	parent=$(pr_for_head "$base")
	[[ -n "$parent" ]] || break
	in_stack "$base" && break
	stack=$(jq -c --argjson p "$parent" '[$p] + .' <<<"$stack")
	cur="$parent"
done

head=$(jq -r .headRefName <<<"$target")
depth=0
while ((depth++ < MAX_DEPTH)); do
	child=$(gh pr list --base "$head" --state open --limit 30 --json "$FIELDS" | jq -c 'sort_by(.number) | first // empty')
	[[ -n "$child" ]] || break
	head=$(jq -r .headRefName <<<"$child")
	in_stack "$head" && break
	stack=$(jq -c --argjson c "$child" '. + [$c]' <<<"$stack")
done

query="query(\$owner: String!, \$name: String!) { repository(owner: \$owner, name: \$name) {"
for n in $(jq -r '.[].number' <<<"$stack"); do
	query+=" pr$n: pullRequest(number: $n) { additions deletions }"
done
query+=" } }"
stats=$(gh api graphql -F owner="${repo%/*}" -F name="${repo#*/}" -f query="$query" --jq '.data.repository')

# Graphite's "Copy stack" writes exactly these two forms: HTML lines joined by
# <br />, and the markdown form as the plain-text type.
rendered=$(jq -n --argjson r "$stack" --argjson s "$stats" '
	$r | reverse
	| map(. + $s["pr" + (.number | tostring)])
	| {
		markdown: (map("[#\(.number) \(.title)](\(.url)) `+\(.additions)/-\(.deletions)`") | join("\n")),
		html: (map("<a href=\"\(.url)\">#\(.number) \(.title | @html)</a> <code>+\(.additions)/-\(.deletions)</code>") | join("<br />"))
	}')

text=$(jq -r .markdown <<<"$rendered")
printf '%s\n' "$text"

[[ "$COPY" -eq 1 ]] || exit 0
tmp=$(mktemp -d "${TMPDIR:-/tmp}/copy-stack.XXXXXX")
trap 'rm -rf "$tmp"' EXIT
printf '%s' "$text" >"$tmp/text"
# Same pasteboard types and charset prefix a browser's clipboard.write() produces.
{
	printf "<meta charset='utf-8'>"
	jq -r .html <<<"$rendered"
} >"$tmp/html"
if osascript -l JavaScript - "$tmp/html" "$tmp/text" 2>/dev/null <<'EOF'
function run(argv) {
	ObjC.import("AppKit");
	const read = (p) => $.NSString.stringWithContentsOfFileEncodingError(p, $.NSUTF8StringEncoding, null);
	const pb = $.NSPasteboard.generalPasteboard;
	pb.clearContents;
	pb.setStringForType(read(argv[0]), $.NSPasteboardTypeHTML);
	pb.setStringForType(read(argv[1]), $.NSPasteboardTypeString);
}
EOF
then
	echo "copy-stack: on the clipboard as rich text" >&2
else
	echo "copy-stack: clipboard unavailable; paste the text above" >&2
fi
