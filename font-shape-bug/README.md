# Bug Report: Font Shape Error in econsocart.cls

**Bug Type**: Compilation Failure  
**Severity**: Critical (prevents document compilation)  
**Status**: Reproducible in econsocart.cls v2.0 (2023/12/01)

---

## Quick Summary

**Error**: `LaTeX Error: Font T1/put/m/scit/12 not found`

**Trigger**: Using `\textsc{\textit{...}}` or other combinations of small caps with italic/slanted text

**Impact**: Document fails to compile

---

## Reproduction Steps

1. **Compile the MWE**:
   ```bash
   pdflatex mwe-font-shape.tex
   ```

2. **Expected Result**: Compilation fails with:
   ```
   ! LaTeX Error: Font T1/put/m/scit/12 not found.
   ```

3. **Location in MWE**: Line 30-31 contain the problematic text

---

## Root Cause Analysis

### Font Definition Issue

The `econsocart.cls` document class uses the **Utopia font family** (T1/put encoding). The font definition file `t1put.fd` declares standard font shapes but **omits combined shapes**:

| Shape Code | Meaning | Defined? |
|------------|---------|----------|
| `n` | Normal | ✅ Yes |
| `it` | Italic | ✅ Yes |
| `sl` | Slanted | ✅ Yes |
| `sc` | Small Caps | ✅ Yes |
| **`scit`** | **Small Caps + Italic** | ❌ **No** |
| **`scsl`** | **Small Caps + Slanted** | ❌ **No** |
| **`slit`** | **Slanted + Italic** | ❌ **No** |

### What Happens

1. User writes: `\textsc{\textit{Some Text}}`
2. LaTeX interprets this as: "Switch to small caps, then switch to italic"
3. LaTeX looks for font shape: `T1/put/m/scit/12` (small caps + italic)
4. `t1put.fd` does not define this shape
5. LaTeX has no fallback → **compilation error**

### Why This Matters

Many academic documents naturally combine emphasis styles:
- Journal names in citations: `\textit{\textsc{Quarterly Journal of Economics}}`
- Emphasized proper nouns: `\textsc{\textit{New York}}`
- Mathematical notation conventions

---

## Workaround

### Option 1: Use `workaround.sty` Package

Include the provided `workaround.sty` file:

```latex
\documentclass[qe]{econsocart}
\usepackage{workaround}  % Declares missing font shapes
```

### Option 2: Manual Declaration in Document

Add to your document preamble:

```latex
\documentclass[qe]{econsocart}

% Declare missing font shapes
\makeatletter
\AtBeginDocument{%
  % Map scit (small caps italic) to sc (small caps only)
  \DeclareFontShape{T1}{put}{m}{scit}{<->ssub*put/m/sc}{}%
  \DeclareFontShape{T1}{put}{b}{scit}{<->ssub*put/b/sc}{}%
  \DeclareFontShape{T1}{put}{bx}{scit}{<->ssub*put/bx/sc}{}%
  % Map scsl (small caps slanted) to sc (small caps only)
  \DeclareFontShape{T1}{put}{m}{scsl}{<->ssub*put/m/sc}{}%
  \DeclareFontShape{T1}{put}{b}{scsl}{<->ssub*put/b/sc}{}%
  \DeclareFontShape{T1}{put}{bx}{scsl}{<->ssub*put/bx/sc}{}%
  % Map slit (slanted italic) to sl (slanted only)
  \DeclareFontShape{T1}{put}{m}{slit}{<->ssub*put/m/sl}{}%
  \DeclareFontShape{T1}{put}{b}{slit}{<->ssub*put/b/sl}{}%
}
\makeatother
```

**Important**: Must use `\AtBeginDocument` to override `t1put.fd` which loads during document initialization.

---

## Suggested Fix for econsocart.cls Maintainers

### Option A: Add to `t1put.fd` (Preferred)

In the Utopia font definition file `t1put.fd`, add:

```latex
\DeclareFontShape{T1}{put}{m}{scit}{<->ssub*put/m/sc}{}%
\DeclareFontShape{T1}{put}{b}{scit}{<->ssub*put/b/sc}{}%
\DeclareFontShape{T1}{put}{bx}{scit}{<->ssub*put/bx/sc}{}%
\DeclareFontShape{T1}{put}{m}{scsl}{<->ssub*put/m/sc}{}%
\DeclareFontShape{T1}{put}{b}{scsl}{<->ssub*put/b/sc}{}%
\DeclareFontShape{T1}{put}{bx}{scsl}{<->ssub*put/bx/sc}{}%
\DeclareFontShape{T1}{put}{m}{slit}{<->ssub*put/m/sl}{}%
\DeclareFontShape{T1}{put}{b}{slit}{<->ssub*put/b/sl}{}%
\DeclareFontShape{T1}{put}{bx}{slit}{<->ssub*put/bx/sl}{}%
```

### Option B: Add to `econsocart.cls`

In the class file, after font loading (around line 100-200):

```latex
\AtBeginDocument{%
  \makeatletter
  \DeclareFontShape{T1}{put}{m}{scit}{<->ssub*put/m/sc}{}%
  \DeclareFontShape{T1}{put}{b}{scit}{<->ssub*put/b/sc}{}%
  \DeclareFontShape{T1}{put}{bx}{scit}{<->ssub*put/bx/sc}{}%
  \DeclareFontShape{T1}{put}{m}{scsl}{<->ssub*put/m/sc}{}%
  \DeclareFontShape{T1}{put}{b}{scsl}{<->ssub*put/b/sc}{}%
  \DeclareFontShape{T1}{put}{bx}{scsl}{<->ssub*put/bx/sc}{}%
  \DeclareFontShape{T1}{put}{m}{slit}{<->ssub*put/m/sl}{}%
  \DeclareFontShape{T1}{put}{b}{slit}{<->ssub*put/b/sl}{}%
  \DeclareFontShape{T1}{put}{bx}{slit}{<->ssub*put/bx/sl}{}%
  \makeatother
}
```

---

## Testing the Workaround

1. **Apply workaround**: Use `workaround.sty` or add declarations to preamble
2. **Compile**: `pdflatex mwe-font-shape.tex`
3. **Expected**: Compilation succeeds without errors
4. **Visual Check**: Text appears with small caps (italic aspect gracefully degrades to non-italic small caps)

---

## Files in This Directory

| File | Purpose |
|------|---------|
| `mwe-font-shape.tex` | Minimal example that triggers the bug |
| `README.md` | This file - detailed bug explanation |
| `compile.sh` | Compilation script for testing |
| `workaround.sty` | Package with font shape declarations |

---

## Technical Details

**Document Class**: econsocart.cls version 2.0 (2023/12/01)  
**Font Family**: Utopia (Adobe Utopia, Fourier-GUTenberg project)  
**Encoding**: T1 (Cork encoding)  
**Font Definition File**: `t1put.fd` (distributed with fourier package)

**Tested Environments**:
- TeX Live 2024 on macOS 14.4
- TeX Live 2024 on Ubuntu 22.04

---

## Impact Assessment

**Severity**: 🔴 **Critical**

**Reason**: 
- Complete compilation failure (not just a warning)
- No automatic fallback or substitution
- Common text patterns trigger the bug
- Affects multiple font weight combinations

**Affected Users**:
- Any QE submission using nested text formatting
- Documents with journal/book titles in citations
- Papers emphasizing proper nouns or foreign phrases

---

## Related Information

**Similar Issues**:
- Computer Modern fonts handle combined shapes gracefully
- Most modern font families include shape substitutions
- This is specific to Utopia font in T1 encoding

**Workaround Trade-offs**:
- ✅ Allows compilation to succeed
- ✅ Produces acceptable output (small caps only)
- ⚠️ Loses italic/slanted aspect of combined style
- ⚠️ Requires manual addition to each document

---

**Status**: Ready for bug report to Econometric Society  
**Contact**: Christopher Carroll (ccarroll@jhu.edu)  
**Date**: November 4, 2025

