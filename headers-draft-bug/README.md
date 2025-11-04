# Bug Report: Garbled Headers in Draft Mode (econsocart.cls)

**Bug Type**: Visual Defect  
**Severity**: Major (affects all QE draft submissions)  
**Status**: Reproducible in econsocart.cls v2.0 (2023/12/01)  
**Note**: While individually modest, this bug's interaction with the line numbering system made constructing a reliable workaround non-trivial

---

## Quick Summary

**Symptom**: Odd-page headers show concatenated journal name + title without spacing

**Example**: 
```
Submitted to Quantitative EconomicsMinimal Working Example1
```

**Expected**: 
```
                    Minimal Working Example                    1
```

**Impact**: Unprofessional appearance, difficult to read

---

## Reproduction Steps

1. **Compile the MWE in draft mode**:
   ```bash
   pdflatex mwe-headers-draft.tex
   ```

2. **Open the generated PDF**: `mwe-headers-draft.pdf`

3. **Examine page 2**: Look at the top-right corner (odd-page header)

4. **Observe**: Journal name and title are concatenated without separation

---

## Root Cause Analysis

### The Bug Location

**File**: `econsocart.cls`  
**Lines**: 1953--1956  
**Section**: `\end{frontmatter}` processing

```latex
\ifecta@layout
    \markboth{{\let\.\econsocart@redef@uc@dot\@runauthor}}{\@runtitle}%
\else
    \markboth{\@runauthor\hfill\@runjournal}{\@runjournal\hfill\@runtitle}%
\fi
```

### What Goes Wrong

1. **QE Class Option**: Using `\documentclass[qe]{econsocart}` sets the flag `\qe@layouttrue`

2. **Conditional Logic**: The conditional checks `\ifecta@layout`, which is **false** for QE submissions

3. **Fallthrough to `\else`**: QE falls into the `\else` branch, which is designed for journals other than ECTA

4. **Wrong Header Setup**: The `\else` branch sets:
   ```latex
   \markboth{\@runauthor\hfill\@runjournal}{\@runjournal\hfill\@runtitle}
   ```
   
   This means:
   - `\leftmark = \@runauthor\hfill\@runjournal` (even pages: authors + journal)
   - `\rightmark = \@runjournal\hfill\@runtitle` (odd pages: **journal + title**)

5. **Result**: Odd pages show both journal name and title

### Why This Design Exists

The `\else` branch was likely designed for journals that want **both** journal name and title in headers (like some other Econometric Society publications). However, **QE should behave like ECTA**, with clean separation:
- Even pages: Authors only
- Odd pages: Title only

### Architectural Issue

The code treats `\ifecta@layout` as a binary decision:
- ECTA layout → Clean headers
- Everything else → Journal name + title headers

But QE needs ECTA-style headers, not "everything else" headers. The fix is to add explicit QE handling.

---

## Visual Comparison

### Current (Buggy) Output

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│  Page 2 (Odd)                                          │
│  Submitted to Quantitative EconomicsMinimal Working Example1 │
│                                                        │
│  [Document content...]                                 │
└────────────────────────────────────────────────────────┘
```

### Expected Output

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│  Page 2 (Odd)                                          │
│                  Minimal Working Example              1 │
│                                                        │
│  [Document content...]                                 │
└────────────────────────────────────────────────────────┘
```

---

## Workaround

### Option 1: Use `workaround.sty` Package

Include the provided `workaround.sty` file:

```latex
\documentclass[qe,draft]{econsocart}
\usepackage{workaround}  % Fixes headers
```

### Option 2: Manual Header Redefinition

Add after `\end{frontmatter}`:

```latex
\documentclass[qe,draft]{econsocart}

\begin{document}
\begin{frontmatter}
  % ... title, author, abstract ...
\end{frontmatter}

% FIX HEADERS (workaround for econsocart.cls bug)
\makeatletter
\def\@oddhead{\runninghead@size\hfill\@runtitle\hfill\llap{\pagenumber@size\thepage}\put@numberlines@box}%
\def\@evenhead{\runninghead@size\rlap{\pagenumber@size\thepage}\hfill Submitted to Quantitative Economics\hfill\put@numberlines@box}%
\makeatother

% Continue with document content...
\section{Introduction}
```

**Important**: In draft mode, must include `\put@numberlines@box` to preserve line numbers.

---

## Suggested Fix for econsocart.cls Maintainers

### Recommended Change

In `econsocart.cls`, lines 1953--1956, add explicit QE handling:

```latex
% CURRENT (WRONG):
\ifecta@layout
    \markboth{{\let\.\econsocart@redef@uc@dot\@runauthor}}{\@runtitle}%
\else
    \markboth{\@runauthor\hfill\@runjournal}{\@runjournal\hfill\@runtitle}%
\fi

% SUGGESTED FIX:
\ifecta@layout
    % ECTA: Authors on even pages, title on odd pages
    \markboth{{\let\.\econsocart@redef@uc@dot\@runauthor}}{\@runtitle}%
\else
    \ifqe@layout
        % QE: Same as ECTA (clean headers)
        \markboth{{\let\.\econsocart@redef@uc@dot\@runauthor}}{\@runtitle}%
    \else
        % Other journals: Journal name + title on odd pages
        \markboth{\@runauthor\hfill\@runjournal}{\@runjournal\hfill\@runtitle}%
    \fi
\fi
```

### Alternative: Treat QE as ECTA

Even simpler fix - modify the conditional check on line 1953:

```latex
% CURRENT:
\ifecta@layout

% ALTERNATIVE FIX:
\ifecta@layout\else\ifqe@layout\fi
```

This would make QE trigger the same branch as ECTA.

---

## Testing the Workaround

1. **Apply workaround**: Use `workaround.sty` or add header redefinitions
2. **Compile**: `pdflatex mwe-headers-draft.tex`
3. **Check page 2**: Header should show only the title (right side) and only journal name (left side, if on even page)
4. **Verify line numbers**: In draft mode, line numbers should still appear

---

## Impact Assessment

**Severity**: 🟡 **Major**

**Reason**:
- Does not prevent compilation (unlike font bug)
- Creates unprofessional, hard-to-read output
- Affects **all** QE draft submissions
- Workaround is required for acceptable appearance

**Affected Users**:
- Any author submitting to Quantitative Economics
- Any reviewer receiving draft PDFs
- Data editor receiving replication packages

**Professional Impact**:
- Looks careless or rushed
- May cause confusion about document structure
- Detracts from content quality perception

---

## Draft Mode vs. Regular Mode

**Important**: This bug affects both draft mode (`[qe,draft]`) and regular mode (`[qe]`), but is **most noticeable in draft mode** because:

1. Draft mode uses line numbers, making header text more crowded
2. Draft submissions are what reviewers typically see
3. Final submissions may have custom headers anyway

---

## Interaction with Line Numbers

An additional complexity: when fixing headers in draft mode, the workaround must preserve `\put@numberlines@box` which `econsocart.cfg` adds for line numbering.

**Incorrect workaround** (loses line numbers after page 1):
```latex
\def\@oddhead{\runninghead@size\hfill\@runtitle\hfill\llap{\pagenumber@size\thepage}}%
```

**Correct workaround** (preserves line numbers):
```latex
\def\@oddhead{\runninghead@size\hfill\@runtitle\hfill\llap{\pagenumber@size\thepage}\put@numberlines@box}%
```

---

## Files in This Directory

| File | Purpose |
|------|---------|
| `mwe-headers-draft.tex` | Minimal example demonstrating the bug |
| `README.md` | This file - detailed bug explanation |
| `compile.sh` | Compilation script for testing |
| `workaround.sty` | Package with header redefinitions |

---

## Related Issues

**Similar Patterns**:
- Other journals in the `econsocart` family may have similar issues
- The three-way distinction (ECTA / QE / Other) should be clearly documented

**Best Practice**:
- Journal-specific layout flags should have explicit handling
- Default `\else` branches should be avoided for journal-specific formatting

---

## Technical Details

**Document Class**: econsocart.cls version 2.0 (2023/12/01)  
**Journal**: Quantitative Economics (QE)  
**Mode**: Draft mode (line-numbered submissions)  
**LaTeX Command**: `\markboth{left-mark}{right-mark}`

**Page Header Layout**:
- Even pages use `\leftmark` (left side content)
- Odd pages use `\rightmark` (right side content)

**Tested Environments**:
- TeX Live 2024 on macOS 14.4
- TeX Live 2024 on Ubuntu 22.04

---

## Contact and References

**Bug Reporter**: Christopher Carroll (ccarroll@jhu.edu)  
**Affiliation**: Johns Hopkins University, NBER, econ-ark.org  
**Related Submission**: "Welfare and Spending Effects of Consumption Stimulus Policies"  
**Date**: November 4, 2025

---

**Status**: Ready for bug report to Econometric Society  
**Workaround Available**: Yes (see `workaround.sty`)  
**Fix Complexity**: Low (5-line change in econsocart.cls)

