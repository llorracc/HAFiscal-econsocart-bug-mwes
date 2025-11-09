# Email Template for Reporting econsocart.cls Bug

**To**: Quantitative Economics Data Editor  
**Subject**: Bug Report in econsocart.cls Document Class

---

Dear Data Editor,

I am writing to report a problematic bug discovered in the `econsocart.cls` document class (version 2.0, 2023/12/01) while preparing my submission to Quantitative Economics. While modest in scope, diagnosing the root cause and constructing a reliable workaround required considerable effort.

I have created a standalone repository with a Minimal Working Example (MWE) that demonstrates the issue, along with a tested workaround:

**Repository**: https://github.com/llorracc/HAFiscal-econsocart-bug-mwes  
**Interactive Binder**: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/llorracc/HAFiscal-econsocart-bug-mwes/main?filepath=Interactive-Bug-Demonstrations-With-Workarounds.ipynb)
**Docker Alternative**: Available for local reproduction (see repository README)

---

## Bug: Font Shape Warning

**Warning Message**: `LaTeX Font Warning: Font shape 'T1/put/m/scit' undefined`

**Trigger**: Using `\textsc{\textit{...}}` (small caps + italic) or similar combined font shapes

**MWE Location**: `font-shape-bug/`

**Details**: The Utopia font family (`T1/put`) used by `econsocart.cls` does not define combined font shapes (`scit`, `scsl`, `slit`). When LaTeX encounters these combinations, it produces warnings and substitutes available fonts. While compilation succeeds, the warnings clutter the build logs and indicate missing font shape declarations.

**Suggested Fix**: Add `\DeclareFontShape` declarations to map missing shapes to available alternatives (detailed in the MWE README).

**Workaround**: Included in `font-shape-bug/workaround.sty`

---

## Reproduction

### Option 1: Use Binder (No Installation Required)

Click the Binder badge to launch an interactive environment:

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/llorracc/HAFiscal-econsocart-bug-mwes/main?filepath=Interactive-Bug-Demonstrations-With-Workarounds.ipynb)

Then run:
```bash
cd font-shape-bug/ && ./compile.sh
```

### Option 2: Use Docker (Containerized Local Environment)

```bash
git clone https://github.com/llorracc/HAFiscal-econsocart-bug-mwes.git
cd HAFiscal-econsocart-bug-mwes
docker build -t econsocart-bug-mwes .
docker run -it --rm econsocart-bug-mwes
# Then run compile script
cd font-shape-bug && ./compile.sh
```

### Option 3: Clone Repository Locally

```bash
git clone https://github.com/llorracc/HAFiscal-econsocart-bug-mwes.git
cd HAFiscal-econsocart-bug-mwes/font-shape-bug
pdflatex mwe-font-shape.tex  # Produces warnings
```

---

## Impact

**Font Warning**: 
- Severity: **Minor** (code quality issue)
- Produces compilation warnings but does not block compilation
- LaTeX automatically substitutes fonts and continues
- Affects any document using nested text formatting (e.g., `\textsc{\textit{...}}`)
- Workaround is straightforward once diagnosed, but diagnosing required considerable effort

While this bug is modest in scope, it required significant time to diagnose and construct a reliable workaround. Authors currently need this workaround to produce warning-free submissions.

---

## Request

I kindly request that this bug be:
1. Forwarded to the maintainers of `econsocart.cls`
2. Addressed in a future update to the document class
3. Documented in submission guidelines until fixed

I am happy to provide additional information or clarification if needed.

---

## Contact Information

**Name**: Christopher Carroll  
**Affiliation**: Johns Hopkins University, National Bureau of Economic Research, and econ-ark.org  
**Email**: ccarroll@jhu.edu  
**Related Submission**: "Welfare and Spending Effects of Consumption Stimulus Policies"

---

## Repository Structure

```
HAFiscal-econsocart-bug-mwes/
├── README.md                   # Overview and quick start
├── font-shape-bug/
│   ├── README.md              # Detailed analysis
│   ├── mwe-font-shape.tex     # Minimal example (produces warnings)
│   ├── mwe-font-shape-fixed.tex # Demonstrates workaround
│   ├── compile.sh             # Test script
│   └── workaround.sty         # Fix implementation
└── binder/                    # Binder configuration
```

---

Thank you for your attention to this matter.

Best regards,  
Christopher Carroll

---

**Date**: November 8, 2025  
**Repository**: https://github.com/llorracc/HAFiscal-econsocart-bug-mwes
