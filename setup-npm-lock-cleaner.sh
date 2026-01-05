#!/bin/bash

# Post-clone setup script for lock-cleaner
# Run this once after cloning a project to install the lock file cleaner hook
# Usage: ./setup-lock-cleaner.sh

set -e

echo "🔧 Setting up lock-cleaner..."

# Download the script
echo "📥 Downloading npm-pre-push-clean.sh..."
if ! curl -s -f -O https://raw.githubusercontent.com/StateFarmIns/lock-cleaner/main/npm-pre-push-clean.sh 2>/dev/null; then
    echo "❌ Failed to download npm-pre-push-clean.sh"
    echo "   Verify the repository is public and the file exists at:"
    echo "   https://raw.githubusercontent.com/StateFarmIns/lock-cleaner/main/npm-pre-push-clean.sh"
    exit 1
fi

if [ ! -f "npm-pre-push-clean.sh" ]; then
    echo "❌ npm-pre-push-clean.sh not found after download"
    exit 1
fi

if ! chmod +x npm-pre-push-clean.sh; then
    echo "❌ Failed to make npm-pre-push-clean.sh executable"
    exit 1
fi

# Create git hook directory if it doesn't exist
if ! mkdir -p .git/hooks; then
    echo "❌ Failed to create .git/hooks directory"
    exit 1
fi

# Create pre-push hook
echo "🪝 Setting up git pre-push hook..."
if ! cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
./npm-pre-push-clean.sh
EOF
then
    echo "❌ Failed to create pre-push hook"
    exit 1
fi

if ! chmod +x .git/hooks/pre-push; then
    echo "❌ Failed to make pre-push hook executable"
    exit 1
fi

# Update .gitignore
echo "📝 Updating .gitignore..."
if [ ! -f ".gitignore" ]; then
    if ! touch .gitignore; then
        echo "❌ Failed to create .gitignore"
        exit 1
    fi
fi

# Add heading comment if not already present
if ! grep -q "^# Lock cleaner" .gitignore; then
    if ! echo "# Lock cleaner" >> .gitignore; then
        echo "❌ Failed to update .gitignore with section header"
        exit 1
    fi
fi

# Add entries if they don't exist
for entry in "npm-pre-push-clean.sh" ".last-lock-clean" ".node_modules_temp"; do
    if ! grep -q "^$entry$" .gitignore; then
        if ! echo "$entry" >> .gitignore; then
            echo "❌ Failed to update .gitignore with $entry"
            exit 1
        fi
        echo "  Added: $entry"
    else
        echo "  Already present: $entry"
    fi
done

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "  1. Run 'npm install' to ensure node_modules and package-lock.json are in sync"
echo "  2. Commit .gitignore changes (ignore npm-pre-push-clean.sh locally)"
echo "  3. The script will now run automatically before every 'git push'"
echo ""
echo "💡 To test manually, run: ./npm-pre-push-clean.sh"
