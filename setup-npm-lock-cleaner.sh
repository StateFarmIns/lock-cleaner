#!/bin/bash

# Post-clone setup script for lock-cleaner
# Run this once after cloning a project to install the lock file cleaner hook
# Usage: ./setup-lock-cleaner.sh

set -e

echo "🔧 Setting up lock-cleaner..."

# Download the script
echo "📥 Downloading npm-pre-push-clean.sh..."
curl -s -O https://raw.githubusercontent.com/StateFarmIns/lock-cleaner/main/npm-pre-push-clean.sh
chmod +x npm-pre-push-clean.sh

# Create git hook directory if it doesn't exist
mkdir -p .git/hooks

# Create pre-push hook
echo "🪝 Setting up git pre-push hook..."
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
./npm-pre-push-clean.sh
EOF
chmod +x .git/hooks/pre-push

# Update .gitignore
echo "📝 Updating .gitignore..."
if [ ! -f ".gitignore" ]; then
    touch .gitignore
fi

# Add entries if they don't exist
for entry in "npm-pre-push-clean.sh" ".last-lock-clean" ".node_modules_temp"; do
    if ! grep -q "^$entry$" .gitignore; then
        echo "$entry" >> .gitignore
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
