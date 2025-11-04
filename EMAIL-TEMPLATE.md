# Email Template for Reporting econsocart.cls Bugs

**To**: Quantitative Economics Data Editor  
**Subject**: Bug Reports in econsocart.cls Document Class

---

Dear Data Editor,

I am writing to report two bugs discovered in the `econsocart.cls` document class (version 2.0, 2023/12/01) while preparing my submission to Quantitative Economics.

I have created a standalone repository with Minimal Working Examples (MWEs) that demonstrate both issues:

**Repository**: https://github.com/llorracc/HAFiscal-econsocart-bug-mwes  
**Interactive Binder**: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/llorracc/HAFiscal-econsocart-bug-mwes/main)

---

## Bug #1: Font Shape Error (Critical - Prevents Compilation)

**Error Message**: `LaTeX Error: Font T1/put/m/scit/12 not found`

**Trigger**: Using `\textsc{\textit{...}}` (small caps + italic) or similar combined font shapes

**MWE Location**: `font-shape-bug/`

**Details**: The Utopia font family (`T1/put`) used by `econsocart.cls` does not define combined font shapes (`scit`, `scsl`, `slit`). When LaTeX encounters these combinations, compilation fails.

**Suggested Fix**: Add `\DeclareFontShape` declarations to map missing shapes to available alternatives (detailed in the MWE README).

**Workaround**: Included in `font-shape-bug/workaround.sty`

---

## Bug #2: Garbled Headers in Draft Mode (Major - Visual Defect)

**Symptom**: Odd-page headers show concatenated journal name + title:
```
Submitted to Quantitative EconomicsWelfare and Spending Effects...
```

**Expected**: Only the paper title should appear on odd pages (right side)

**MWE Location**: `headers-draft-bug/`

**Details**: The `econsocart.cls` file (lines 1953-1956) incorrectly handles QE submissions in the `\ifecta@layout` conditional. QE sets `\qe@layouttrue` but not `\ecta@layouttrue`, causing it to fall into an `\else` branch designed for other journals.

**Suggested Fix**: Add explicit QE handling to treat it like ECTA for header formatting (detailed in the MWE README).

**Workaround**: Included in `headers-draft-bug/workaround.sty`

---

## Reproduction

### Option 1: Use Binder (No Installation Required)

Click the Binder badge to launch an interactive environment:

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/llorracc/HAFiscal-econsocart-bug-mwes/main)

Then run:
```bash
cd font-shape-bug/ && ./compile.sh
cd ../headers-draft-bug/ && ./compile.sh
```

### Option 2: Clone Repository Locally

```bash
git clone https://github.com/llorracc/HAFiscal-econsocart-bug-mwes.git
cd HAFiscal-econsocart-bug-mwes/font-shape-bug
pdflatex mwe-font-shape.tex  # Will fail with font error
cd ../headers-draft-bug
pdflatex mwe-headers-draft.tex  # Compiles but headers are garbled
```

---

## Impact

**Font Bug**: 
- Severity: **Critical**
- Prevents document compilation
- Affects any document using nested text formatting

**Headers Bug**:
- Severity: **Major**
- Creates unprofessional appearance
- Affects all QE draft submissions

Both bugs require workarounds for authors to produce acceptable submissions.

---

## Request

I kindly request that these bugs be:
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
│   ├── mwe-font-shape.tex     # Minimal example
│   ├── compile.sh             # Test script
│   └── workaround.sty         # Fix implementation
├── headers-draft-bug/
│   ├── README.md              # Detailed analysis
│   ├── mwe-headers-draft.tex  # Minimal example
│   ├── compile.sh             # Test script
│   └── workaround.sty         # Fix implementation
└── binder/                    # Binder configuration
```

---

Thank you for your attention to these matters.

Best regards,  
Christopher Carroll

---

**Date**: November 4, 2025  
**Repository**: https://github.com/llorracc/HAFiscal-econsocart-bug-mwes

