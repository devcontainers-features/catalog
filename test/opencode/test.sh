#!/bin/bash

set -e

# Provides the 'check' and 'reportResults' commands.
# shellcheck disable=SC1091
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib. Syntax is...
# check <LABEL> <cmd> [args...]
check "execute command" bash -c "opencode -h | grep 'start opencode tui'"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
