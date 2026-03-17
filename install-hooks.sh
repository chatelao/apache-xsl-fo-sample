#!/bin/bash
HOOK_SOURCE="hooks/pre-commit"
HOOK_DEST=".git/hooks/pre-commit"

chmod +x "$HOOK_SOURCE"
ln -sf "../../$HOOK_SOURCE" "$HOOK_DEST"
chmod +x "$HOOK_DEST"

echo "Pre-commit hook installed successfully."
