# lock-cleaner

A simple bash script to clean and regenerate `package-lock.json` with default npm registry paths before pushing to GitHub. This ensures your lock file doesn't contain custom registry paths or local configuration that may have been used during development.

## 🎯 Purpose

When working with Node.js projects, your `package-lock.json` might contain resolved dependency URLs pointing to:
- Private npm registries
- Custom registry configurations
- Internal company registries
- Mirror registries

This script ensures your `package-lock.json` uses default npm registry paths before committing, making it suitable for public repositories or team collaboration.

## ✨ What It Does

1. **Checks** if cleanup is needed (skips if `package-lock.json` hasn't changed since last run)
2. **Removes** the existing `package-lock.json`
3. **Temporarily hides** the `node_modules` directory (renames to `.node_modules_temp`)
4. **Regenerates** `package-lock.json` using `npm install --package-lock-only` (no actual package installation)
5. **Restores** the `node_modules` directory to its original state
6. **Tracks** the cleanup with a marker file (`.last-lock-clean`) to avoid unnecessary reruns

The result is a clean `package-lock.json` with default registry paths, without affecting your installed dependencies. The script intelligently skips cleanup when no `npm install` has run since the last cleanup, keeping your workflow fast.

## 📋 Requirements

- **Bash shell** (Linux, macOS, Git Bash on Windows, WSL)
- **npm** (Node Package Manager)
- A Node.js project with `package.json`

## 🚀 Installation

### For Consuming Projects (Recommended)

If you want to use this script in another project locally (without committing it to source control):

1. After cloning your project, run this one-time setup:
   ```bash
   curl -s https://raw.githubusercontent.com/StateFarmIns/lock-cleaner/main/setup-npm-lock-cleaner.sh | bash
   ```
   
   This will:
   - Download `npm-pre-push-clean.sh`
   - Create a git pre-push hook to run automatically
   - Add necessary entries to `.gitignore` (so the script stays local)

2. Run `npm install` to ensure packages and lock file start in sync:
   ```bash
   npm install
   ```

3. Commit the `.gitignore` changes (the script itself will be ignored):
   ```bash
   git add .gitignore
   git commit -m "Add lock-cleaner to gitignore"
   ```

4. The script now runs automatically before every `git push`

### Direct Download (For Development/Reference)

1. Download the script to your project root:
   ```bash
   curl -O https://raw.githubusercontent.com/StateFarmIns/lock-cleaner/main/npm-pre-push-clean.sh
   chmod +x npm-pre-push-clean.sh
   ```

## 📖 Usage

### Manual Execution

Run the script manually before pushing your code:

```bash
./npm-pre-push-clean.sh
```

### Automated Git Hook (Already Set Up)

If you used the recommended setup script, the git pre-push hook is already installed and will run automatically before every `git push`. No additional configuration needed.

### Automated Git Hook (Manual Setup)

If you prefer to set it up manually:

```bash
# Create the pre-push hook
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
./npm-pre-push-clean.sh
EOF

# Make it executable
chmod +x .git/hooks/pre-push
```

Now the script will run automatically every time you `git push`.

### Alternative: Using Husky

If your project uses [Husky](https://github.com/typicode/husky) for Git hooks:

1. Install Husky (if not already installed):
   ```bash
   npm install --save-dev husky
   npx husky install
   ```

2. Add the pre-push hook:
   ```bash
   npx husky add .git/hooks/pre-push "./npm-pre-push-clean.sh"
   ```

## 🔍 How It Works

The script uses `npm install --package-lock-only`, which:
- Only updates the `package-lock.json` file
- Does **NOT** install or modify packages in `node_modules`
- Uses npm's default registry configuration
- Is fast and lightweight

By temporarily hiding `node_modules`, we ensure npm generates the lock file fresh from `package.json` using default paths.

## ⚠️ Important Notes

- The script requires `package.json` to exist in the current directory
- It will exit with an error if `package-lock.json` generation fails
- Your `node_modules` will be safely restored even if an error occurs
- The script is idempotent - safe to run multiple times
- For a brand-new clone, run a full `npm install` once before using the script so `node_modules` and `package-lock.json` start in sync
- If you want this script only for local hygiene (e.g., working behind a firewall but publishing clean OSS), add these to your project `.gitignore` so they never reach source control:
   - `npm-pre-push-clean.sh`
   - `.last-lock-clean`
   - `.node_modules_temp`

## 🛠️ Troubleshooting

### "Permission denied" error
Make sure the script is executable:
```bash
chmod +x npm-pre-push-clean.sh
```

### Script doesn't run in Git hook
Ensure the hook file is executable:
```bash
chmod +x .git/hooks/pre-push
```

### npm command not found
Make sure npm is installed and in your PATH:
```bash
npm --version
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

Apache License 2.0 - feel free to use this script in your projects.

## 🐛 Issues

If you encounter any problems or have suggestions, please [open an issue](https://github.com/StateFarmIns/lock-cleaner/issues).

## 🙏 Acknowledgments

Created to solve the common problem of `package-lock.json` files containing custom registry paths in team environments.
