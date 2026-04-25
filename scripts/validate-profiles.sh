#!/bin/sh
# Validates all model profiles in models/ to ensure required fields are set
# and ALIAS values are unique.
# Exit code 0 = all good, 1 = one or more errors found.

MODELS_DIR="$(dirname "$0")/../models"
REQUIRED_FIELDS="HF_REPO MODEL_DIR MODEL_FILE ALIAS"
errors=0

# Check required fields in each profile
for profile in $(find "$MODELS_DIR" -name '*.env' | sort); do
  name=$(echo "$profile" | sed "s|^$MODELS_DIR/||")
  for field in $REQUIRED_FIELDS; do
    value=$(grep "^${field}=" "$profile" | cut -d'=' -f2-)
    if [ -z "$value" ]; then
      echo "ERROR: $name is missing $field"
      errors=$((errors + 1))
    fi
  done
done

# Check for duplicate ALIAS values
aliases=$(find "$MODELS_DIR" -name '*.env' -exec grep -h "^ALIAS=" {} + | cut -d'=' -f2- | sort)
duplicates=$(echo "$aliases" | uniq -d)
if [ -n "$duplicates" ]; then
  echo "WARNING: Duplicate ALIAS values found (multiple profiles share the same alias):"
  for dup in $duplicates; do
    echo "  $dup"
    find "$MODELS_DIR" -name '*.env' -exec grep -l "^ALIAS=$dup" {} + | while read -r f; do
      echo "    $(echo "$f" | sed "s|^$MODELS_DIR/||")"
    done
  done
fi

if [ "$errors" -gt 0 ]; then
  echo ""
  echo "Found $errors error(s). Fix the profiles above before merging."
  exit 1
fi

echo "All $(find "$MODELS_DIR" -name '*.env' | wc -l | tr -d ' ') profiles are valid."
