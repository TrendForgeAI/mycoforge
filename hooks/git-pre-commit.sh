#!/bin/bash
# Git pre-commit Hook
# Wird von Git vor jedem Commit aufgerufen.
# Installiert durch entrypoint.sh als .git/hooks/pre-commit

/mycoforge/hooks/secrets-scan.sh "$(pwd)"
