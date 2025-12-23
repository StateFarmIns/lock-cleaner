# lock-cleaner

This is a simple shell script utility for Node.js projects. The project consists of a single bash script that cleans package-lock.json files before pushing to GitHub.

## Project Type
- Bash script utility for Node.js projects (currently npm, extensible to yarn, pnpm, etc.)
- No compilation or build process required
- No external dependencies

## Key Features
- Removes package-lock.json
- Temporarily hides node_modules
- Regenerates lock file with default registry paths
- Restores node_modules

## Usage
This script is meant to be copied into Node.js projects and run before pushing code to GitHub.
