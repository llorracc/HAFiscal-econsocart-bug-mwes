# HAFiscal econsocart.cls Bug Demonstrations

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/llorracc/HAFiscal-econsocart-bug-mwes/main?filepath=Interactive-Bug-Demonstrations-With-Workarounds.ipynb)

This repository contains Minimal Working Examples (MWEs) demonstrating two modest but problematic bugs in the `econsocart.cls` document class used by Quantitative Economics journal.

**Repository Purpose**: Standalone bug demonstrations for the Econometric Society data editor and maintainers

**Context**: These bugs were discovered while preparing a submission to Quantitative Economics using the official `econsocart` document class (version 2.0, 2023/12/01). While individually modest, diagnosing their root causes and constructing reliable workarounds required considerable effort.

**Interactive Demo**: Click the Binder badge above to launch an interactive environment where you can reproduce both bugs and test workarounds without any local installation. Alternatively, see the [Docker section](#docker-alternative) below for a containerized local environment.

---

## Bug Summary

| Bug | Status | MWE Directory | Impact |
|-----|--------|---------------|--------|
| **Font Shape Error** | Compilation Failure | `font-shape-bug/` | Documents using small caps + italic fail to compile |
| **Garbled Headers in Draft Mode** | Visual Defect | `headers-draft-bug/` | Page headers show concatenated journal name + title |

---

## Quick Start

Each bug has its own directory with:
- **MWE LaTeX file**: Minimal code to reproduce the bug
- **README.md**: Detailed explanation, root cause, workaround
- **Compilation script**: `compile.sh` to test the bug
- **Expected output**: Description of the bug symptoms

### Testing Font Shape Bug

```bash
cd font-shape-bug/
./compile.sh
# Should fail with: LaTeX Error: Font T1/put/m/scit/12 not found
```

### Testing Headers Bug

```bash
cd headers-draft-bug/
./compile.sh
# Compiles successfully but page headers are garbled
```

---

## Bug 1: Font Shape Error

**Error Message**: `LaTeX Error: Font T1/put/m/scit/12 not found`

**Root Cause**: The Utopia font (`t1put.fd`) does not define combined font shapes:
- `scit` (small caps + italic)
- `scsl` (small caps + slanted)
- `slit` (slanted + italic)

When LaTeX encounters text that requires these combinations (e.g., `\textsc{\textit{...}}`), compilation fails.

**Impact**: **Major** - Behavior varies by TeX distribution (warnings with font substitution or compilation errors)

**Workaround**: Declare missing font shapes manually (see `font-shape-bug/README.md`)

---

## Bug 2: Garbled Headers in Draft Mode

**Symptom**: Odd-page headers concatenate journal name and paper title:
```
Submitted to Quantitative EconomicsMinimal Working Example
```

**Root Cause**: `econsocart.cls` lines 1953-1956 incorrectly handle QE submissions in the `\ifecta@layout` conditional. QE sets `\qe@layouttrue` but not `\ecta@layouttrue`, causing headers to fall into the `\else` branch which is designed for other journals.

**Impact**: **Major** - Unprofessional appearance in draft submissions

**Workaround**: Override header definitions manually (see `headers-draft-bug/README.md`)

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

Inside the container, you can run the demonstration scripts:

```bash
cd font-shape-bug && ./compile.sh
cd ../headers-draft-bug && ./compile.sh
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
│   ├── mwe-font-shape.tex         # Minimal working example
│   ├── compile.sh                 # Compilation script
│   └── workaround.sty             # Fix implementation
├── headers-draft-bug/
│   ├── README.md                  # Detailed headers bug explanation
│   ├── mwe-headers-draft.tex      # Minimal working example
│   ├── compile.sh                 # Compilation script
│   └── workaround.sty             # Fix implementation
└── EMAIL-TEMPLATE.md              # Template for reporting to data editor
```

---

## How to Report These Bugs

1. **Fork this repository** (optional, for reference)
2. **Use the email template**: See `EMAIL-TEMPLATE.md`
3. **Include links** to specific bug directories in this repository
4. **Attach compiled PDFs** (if applicable) showing the visual defects

---

## Suggested Fixes

### For Font Shape Bug
Add to `t1put.fd` or `econsocart.cls`:
```latex
\DeclareFontShape{T1}{put}{m}{scit}{<->ssub*put/m/sc}{}%
\DeclareFontShape{T1}{put}{m}{scsl}{<->ssub*put/m/sc}{}%
\DeclareFontShape{T1}{put}{m}{slit}{<->ssub*put/m/sl}{}%
```

### For Headers Bug
In `econsocart.cls` line 1953, change:
```latex
% CURRENT (WRONG):
\ifecta@layout
    \markboth{{\let\.\econsocart@redef@uc@dot\@runauthor}}{\@runtitle}%
\else
    \markboth{\@runauthor\hfill\@runjournal}{\@runjournal\hfill\@runtitle}%
\fi

% SUGGESTED FIX:
\ifecta@layout
    \markboth{{\let\.\econsocart@redef@uc@dot\@runauthor}}{\@runtitle}%
\else
    \ifqe@layout
        % QE should behave like ECTA for headers
        \markboth{{\let\.\econsocart@redef@uc@dot\@runauthor}}{\@runtitle}%
    \else
        \markboth{\@runauthor\hfill\@runjournal}{\@runjournal\hfill\@runtitle}%
    \fi
\fi
```

---

## Contact

**Author**: Christopher Carroll  
**Affiliation**: Johns Hopkins University, National Bureau of Economic Research, and econ-ark.org  
**Email**: ccarroll@jhu.edu  
**Related Submission**: "Welfare and Spending Effects of Consumption Stimulus Policies" to Quantitative Economics

---

## License

These MWEs are released into the public domain for the purpose of bug reporting and fixing. The `econsocart.cls` document class is copyright the Econometric Society.

---

**Repository Status**: Ready for submission to Econometric Society data editor

**Last Updated**: November 4, 2025

