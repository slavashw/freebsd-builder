#!/usr/bin/env bash
# One-time publish of the BYO FreeBSD 15.1 x86-64 image to GitHub Releases.
# Requires: gh auth login, empty repo https://github.com/slavashw/freebsd-builder
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

TAG=v15.1.0

if ! command -v gh >/dev/null 2>&1; then
  echo "Install GitHub CLI (gh) and run: gh auth login" >&2
  exit 1
fi

gh repo view slavashw/freebsd-builder >/dev/null 2>&1 || {
  echo "Create the repo first: gh repo create slavashw/freebsd-builder --public --source=. --remote=slavashw --push" >&2
  exit 1
}

git push slavashw main
git tag -f "$TAG"
git push slavashw "$TAG" --force

echo "Wait for Actions on tag $TAG, then publish the draft release:"
echo "  gh release edit $TAG --draft=false"
echo
echo "Image URL for rdma-core FREEBSD_IMAGE_URL:"
echo "  https://github.com/slavashw/freebsd-builder/releases/download/${TAG}/freebsd-15.1-x86-64.qcow2"
