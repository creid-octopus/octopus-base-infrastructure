#!/usr/bin/env bash
# Clones a Git repository, moves into a project folder, installs npm packages,
# runs the Playwright tests, and collects the HTML report as an Octopus artifact.
#
# In an Octopus step, the values come from Octopus variables.
# Locally, pass them as arguments: ./clone-and-test.sh <url> <branch> <path>

set -uo pipefail

# Read Octopus variables when running inside an Octopus step, otherwise use arguments.
if command -v get_octopusvariable >/dev/null 2>&1; then
  REPO_URL="$(get_octopusvariable "Playwright.RepositoryUrl")"
  BRANCH="$(get_octopusvariable "Playwright.RepositoryBranch")"
  PROJECT_PATH="$(get_octopusvariable "Playwright.RepositoryFilePath")"
  # Octopus passes booleans as "True" or "False". Lowercase them for the check below.
  COLLECT_ARTIFACT="$(get_octopusvariable "Playwright.CollectResultsAsArtifact" | tr '[:upper:]' '[:lower:]')"
else
  REPO_URL="${1:?Usage: $0 <repo-url> <branch> <path>}"
  BRANCH="${2:?Usage: $0 <repo-url> <branch> <path>}"
  PROJECT_PATH="${3:?Usage: $0 <repo-url> <branch> <path>}"
  COLLECT_ARTIFACT="${COLLECT_ARTIFACT:-false}"
fi

# Artifacts must be written inside the step's working directory ($PWD).
# Octopus deletes other temporary folders after the step runs.
OUTPUT_DIR="$PWD"
REPORT_NAME="playwright-report"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$WORK_DIR/repo" || exit 1
cd "$WORK_DIR/repo/$PROJECT_PATH" || exit 1

# Use the lock file for repeatable installs when one exists.
if [ -f package-lock.json ]; then
  npm ci || exit 1
else
  npm install || exit 1
fi

# Keep the test exit code so the artifact is collected even when tests fail.
export PLAYWRIGHT_HTML_OUTPUT_DIR="$OUTPUT_DIR/$REPORT_NAME"
npx playwright test --reporter=list,html
TEST_EXIT=$?

# Zip the report because artifacts are single files.
if [ "$COLLECT_ARTIFACT" = "true" ] && command -v new_octopusartifact >/dev/null 2>&1 && [ -d "$PLAYWRIGHT_HTML_OUTPUT_DIR" ]; then
  (cd "$OUTPUT_DIR" && zip -r "$REPORT_NAME.zip" "$REPORT_NAME" >/dev/null)
  new_octopusartifact "$OUTPUT_DIR/$REPORT_NAME.zip"
fi

exit "$TEST_EXIT"
