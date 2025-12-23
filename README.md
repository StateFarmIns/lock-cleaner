# npm-lock-cleaner

A simple bash script to clean and regenerate `package-lock.json` with default npm registry paths before pushing to GitHub. This ensures your lock file doesn't contain custom registry paths or local configuration that may have been used during development.

## 🎯 Purpose

When working with Node.js projects, your `package-lock.json` might contain resolved dependency URLs pointing to:
- Private npm registries
- Custom registry configurations
- Internal company registries
- Mirror registries

This script ensures your `package-lock.json` uses default npm registry paths before committing, making it suitable for public repositories or team collaboration.

## ✨ What It Does

1. **Removes** the existing `package-lock.json`
2. **Temporarily hides** the `node_modules` directory (renames to `.node_modules_temp`)
3. **Regenerates** `package-lock.json` using `npm install --package-lock-only` (no actual package installation)
4. **Restores** the `node_modules` directory to its original state

The result is a clean `package-lock.json` with default registry paths, without affecting your installed dependencies.

## 📋 Requirements

- **Bash shell** (Linux, macOS, Git Bash on Windows, WSL)
- **npm** (Node Package Manager)
- A Node.js project with `package.json`

## 🚀 Installation

### Option 1: Download Directly

1. Download the script to your project root:
   ```bash
   curl -O https://raw.githubusercontent.com/dafreitag/npm-lock-cleaner/main/pre-push-clean.sh
   chmod +x pre-push-clean.sh
   ```

### Option 2: Copy Manually

1. Copy `pre-push-clean.sh` to your project root directory
2. Make it executable:
   ```bash
   chmod +x pre-push-clean.sh
   ```

## 📖 Usage

### Manual Execution

Run the script manually before pushing your code:

```bash
./pre-push-clean.sh
```

### Add to package.json Scripts

Add it as an npm script for easy access:

```json
{
  "scripts": {
    "prepush": "./pre-push-clean.sh",
    "clean-lock": "./pre-push-clean.sh"
  }
}
```

Then run:
```bash
npm run prepush
```

### Automated Git Hook (Recommended)

Set it up as a Git pre-push hook to run automatically before every push:

```bash
# Create the pre-push hook
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
./pre-push-clean.sh
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
   npx husky add .git/hooks/pre-push "./pre-push-clean.sh"
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

## 🛠️ Troubleshooting

### "Permission denied" error
Make sure the script is executable:
```bash
chmod +x pre-push-clean.sh
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

If you encounter any problems or have suggestions, please [open an issue](https://github.com/dafreitag/npm-lock-cleaner/issues).

## 🙏 Acknowledgments

Created to solve the common problem of `package-lock.json` files containing custom registry paths in team environments.
