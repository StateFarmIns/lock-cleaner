#!/bin/bash

# Pre-push script to clean package-lock.json and ensure default registry paths
# This script removes package-lock.json, temporarily hides node_modules,
# regenerates the lock file, then restores node_modules

set -e  # Exit on any error

echo "🧹 Starting pre-push cleanup..."

# Check if package.json exists
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found in current directory"
    exit 1
fi

# Step 1: Remove existing package-lock.json
if [ -f "package-lock.json" ]; then
    echo "📝 Removing existing package-lock.json..."
    rm package-lock.json
else
    echo "ℹ️  No package-lock.json found to remove"
fi

# Step 2: Hide node_modules directory if it exists
if [ -d "node_modules" ]; then
    echo "🙈 Hiding node_modules directory..."
    mv node_modules .node_modules_temp
    NODE_MODULES_HIDDEN=true
else
    echo "ℹ️  No node_modules directory found"
    NODE_MODULES_HIDDEN=false
fi

# Step 3: Regenerate package-lock.json (without full install)
echo "🔄 Regenerating package-lock.json with default registry paths..."
npm install --package-lock-only

# Check if regeneration was successful
if [ ! -f "package-lock.json" ]; then
    echo "❌ Error: Failed to generate package-lock.json"
    
    # Restore node_modules before exiting
    if [ "$NODE_MODULES_HIDDEN" = true ]; then
        echo "🔄 Restoring node_modules..."
        mv .node_modules_temp node_modules
    fi
    
    exit 1
fi

# Step 4: Unhide node_modules directory
if [ "$NODE_MODULES_HIDDEN" = true ]; then
    echo "👀 Restoring node_modules directory..."
    mv .node_modules_temp node_modules
fi

echo "✅ Pre-push cleanup completed successfully!"
echo "📦 package-lock.json has been regenerated with default registry paths"
