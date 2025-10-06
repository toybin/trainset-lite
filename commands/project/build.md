---
description: Build/compile the project
---

# Build Command

**Command:** `[BUILD_COMMAND]`

**Purpose:** Compile, bundle, or prepare the project for execution/deployment.

## When to Use

- **Implementation Phase:** Verify code compiles successfully
- **Validation Phase:** Build before comprehensive testing
- **Polish Phase:** Create final artifacts for distribution
- **Gate Validation:** Many phases require successful builds

## Interpreting Output

### ✅ Build Successful
- **Meaning:** Code compiles/bundles without errors
- **Next Steps:** Ready for testing, deployment, or phase advancement
- **Gate Status:** Build-related gates likely satisfied
- **Artifacts:** Check for output files (binaries, bundles, packages)

### ❌ Build Failed
- **Meaning:** Compilation/bundling errors prevent successful build
- **Next Steps:**
  1. Read error messages carefully
  2. Fix syntax or dependency issues
  3. Ensure all required files present
  4. Re-run build
- **Gate Status:** Cannot advance until build succeeds

### ⚠️ Build with Warnings
- **Meaning:** Build succeeds but with potential issues
- **Next Steps:** Review warnings, fix if critical
- **Gate Status:** Usually acceptable but review warnings

## Common Build Commands by Technology

**JavaScript/Node.js:**
- `npm run build` - Build for production
- `npm run dev` - Development build
- `webpack` - Direct webpack build
- `vite build` - Vite production build

**Python:**
- `python -m build` - Build package
- `pip install -e .` - Install in development mode
- `python setup.py build` - Traditional setup

**Go:**
- `go build` - Build current package
- `go build -o binary ./cmd/app` - Build specific binary
- `go install` - Build and install

**Rust:**
- `cargo build` - Debug build
- `cargo build --release` - Optimized build
- `cargo install --path .` - Build and install locally

**C/C++:**
- `make` - Traditional make build
- `cmake --build build/` - CMake build
- `gcc -o binary *.c` - Direct compilation

## Build Artifacts

**Common Output Types:**
- **Binaries:** Executable files for distribution
- **Packages:** Installable packages (wheels, gems, etc.)
- **Bundles:** Web assets (JS, CSS, images)
- **Libraries:** Compiled libraries for linking
- **Documentation:** Generated docs from code

**Where to Find:**
- `build/` or `dist/` directories
- Platform-specific locations (`target/` for Rust, `bin/` for Go)
- Project-configured output paths

## Integration with Workflow

**Phase-Specific Usage:**
- **Architecture Phase:** Early build to validate setup
- **Implementation Phase:** Frequent builds during development
- **Validation Phase:** Clean build before testing
- **Polish Phase:** Final production builds

**Gate Integration:**
- "Code builds successfully" - common gate requirement
- "No build warnings" - quality gate option
- "Artifacts generated" - deployment readiness

## Optimization and Variants

**Development Builds:**
- Faster compilation
- Debug symbols included
- Hot reloading enabled
- Source maps generated

**Production Builds:**
- Optimized for performance
- Minified/compressed
- Debug symbols removed
- Environment-specific configuration

## Troubleshooting

**Build fails with dependency errors:**
- Run package manager install (`npm install`, `pip install -r requirements.txt`)
- Check for version conflicts
- Clear package caches if needed

**Build succeeds but artifacts missing:**
- Check output directory configuration
- Verify build target settings
- Look for build process errors

**Slow builds:**
- Use incremental builds when available
- Consider build caching
- Optimize dependency management
- Use faster build tools (e.g., esbuild, swc)