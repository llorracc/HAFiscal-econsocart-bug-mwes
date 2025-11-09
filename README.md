# HAFiscal econsocart.cls Bug Demonstration

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/llorracc/HAFiscal-econsocart-bug-mwes/main?filepath=Interactive-Bug-Demonstrations-With-Workarounds.ipynb)

This repository contains a Minimal Working Example (MWE) demonstrating a problematic bug in the `econsocart.cls` document class used by Quantitative Economics journal.

**Repository Purpose**: Standalone bug demonstration for the Econometric Society data editor and maintainers

**Context**: This bug was discovered while preparing a submission to Quantitative Economics using the official `econsocart` document class (version 2.0, 2023/12/01). While modest in scope, diagnosing the root cause and constructing a reliable workaround required considerable effort.

**Interactive Demo**: Click the Binder badge above to launch an interactive environment where you can reproduce the bug and test the workaround without any local installation. Alternatively, see the [Docker section](#docker-alternative) below for a containerized local environment.

---

## Bug Summary

| Bug | Status | MWE Directory | Impact |
|-----|--------|---------------|--------|
| **Font Shape Warning** | Compilation Warnings | `font-shape-bug/` | Documents using small caps + italic produce warnings |

---

## Quick Start

The bug directory contains:
- **MWE LaTeX file**: Minimal code to reproduce the bug
- **Fixed LaTeX file**: Demonstrates the workaround actually works
- **README.md**: Detailed explanation, root cause, workaround
- **Compilation script**: `compile.sh` to test **both** bug and fix
- **workaround.sty**: Proven working fix

### Testing Font Shape Bug (and Fix)

```bash
cd font-shape-bug/
./compile.sh
# Tests BOTH:
#   1. Bug: Produces warnings (mwe-font-shape.tex)
#   2. Fix: Clean compilation (mwe-font-shape-fixed.tex)
```

---

## Bug: Font Shape Warning

**Warning Message**: `LaTeX Font Warning: Font shape 'T1/put/m/scit' undefined`

**Root Cause**: The Utopia font (`t1put.fd`) does not define combined font shapes:
- `scit` (small caps + italic)
- `scsl` (small caps + slanted)
- `slit` (slanted + italic)

When LaTeX encounters text that requires these combinations (e.g., `\textsc{\textit{...}}`), it produces warnings and substitutes available font shapes.

**Impact**: **Minor** (Code Quality Issue)
- Produces compilation warnings
- LaTeX automatically substitutes fonts and continues
- Documents compile successfully but with cluttered logs
- Missing font shape declarations should be properly declared

**Workaround**: ✅ **Proven** - Declare missing font shapes manually (see `font-shape-bug/README.md` and `mwe-font-shape-fixed.tex`)

---

## Technical Details

### Document Class Version
- **Package**: `econsocart.cls`
- **Version**: 2.0
- **Date**: 2023/12/01
- **Source**: Econometric Society official distribution

### Font Information
- **Font Family**: Utopia (`put`)
- **Encoding**: T1
- **Definition File**: `t1put.fd`

### Testing Environment
- **Distribution**: TeX Live 2024
- **Engine**: pdfLaTeX
- **Platform**: macOS 14.4 (also tested on Linux)

---

## Docker Alternative

For users who prefer a local containerized environment over Binder:

### Build and Run with Docker

```bash
# Clone the repository
git clone https://github.com/llorracc/HAFiscal-econsocart-bug-mwes.git
cd HAFiscal-econsocart-bug-mwes

# Build the Docker image
docker build -t econsocart-bug-mwes .

# Run the container
docker run -it --rm -v $(pwd):/workspace econsocart-bug-mwes
```

Inside the container, you can run the demonstration script:

```bash
cd font-shape-bug && ./compile.sh
```

Or start a Jupyter notebook server:

```bash
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root
```

Then access the notebook at `http://localhost:8888` in your browser.

---

## Repository Structure

```
HAFiscal-econsocart-bug-mwes/
├── README.md                       # This file
├── Dockerfile                      # Docker container configuration
├── Interactive-Bug-Demonstrations-With-Workarounds.ipynb  # Jupyter demo
├── font-shape-bug/
│   ├── README.md                  # Detailed font bug explanation
│   ├── mwe-font-shape.tex         # MWE that reproduces the bug
│   ├── mwe-font-shape-fixed.tex   # ✅ Demonstrates working fix
│   ├── compile.sh                 # Tests both bug and fix
│   └── workaround.sty             # Proven fix implementation
└── EMAIL-TEMPLATE.md              # Template for reporting to data editor
```

---

## Suggested Fix

### For Font Shape Warning

Add to `t1put.fd` or `econsocart.cls`:
```latex
\DeclareFontShape{T1}{put}{m}{scit}{<->ssub*put/m/sc}{}%
\DeclareFontShape{T1}{put}{m}{scsl}{<->ssub*put/m/sc}{}%
\DeclareFontShape{T1}{put}{m}{slit}{<->ssub*put/m/sl}{}%
```

---

## Contact

**Author**: Christopher Carroll  
**Affiliation**: Johns Hopkins University, National Bureau of Economic Research, and econ-ark.org  
**Email**: ccarroll@jhu.edu  
**Related Submission**: "Welfare and Spending Effects of Consumption Stimulus Policies" to Quantitative Economics

---

## License

This MWE is released into the public domain for the purpose of bug reporting and fixing. The `econsocart.cls` document class is copyright the Econometric Society.

---

**Repository Status**: Ready for submission to Econometric Society data editor

**Last Updated**: November 8, 2025
