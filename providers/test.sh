#!/bin/bash
set -e

# Print a simple test statement
echo "This is just for deployment test."

echo "File listing..."
find . -type f

PROVIDER_EXIT_CODE=$?
