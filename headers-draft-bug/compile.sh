#!/bin/bash
# Compilation script for headers bug MWE
# Demonstrates garbled headers in QE draft mode

set -e

echo "============================================"
echo "Garbled Headers Bug Demonstration"
echo "============================================"
echo ""

# Compile the MWE
echo "Compiling mwe-headers-draft.tex..."
echo "Command: pdflatex mwe-headers-draft.tex"
echo ""

if pdflatex -interaction=nonstopmode mwe-headers-draft.tex > /dev/null 2>&1; then
    echo "✅ Compilation succeeded"
else
    echo "❌ Compilation failed (unexpected)"
    exit 1
fi

# Run again for proper page headers (LaTeX needs 2 passes for headers)
echo "Running second pass for header setup..."
pdflatex -interaction=nonstopmode mwe-headers-draft.tex > /dev/null 2>&1

echo ""
echo "============================================"
echo "PDF Generated: mwe-headers-draft.pdf"
echo "============================================"
echo ""
echo "To observe the bug:"
echo "  1. Open mwe-headers-draft.pdf"
echo "  2. Navigate to page 2 (an odd page)"
echo "  3. Look at the top-right corner (header)"
echo ""
echo "Expected header:"
echo "                    Minimal Working Example                    2"
echo ""
echo "Actual header (buggy):"
echo "    Submitted to Quantitative EconomicsMinimal Working Example2"
echo ""
echo "Notice: Journal name and title are concatenated without spacing"
echo ""
echo "============================================"
echo ""
echo "To test the workaround:"
echo "  1. Add '\\usepackage{workaround}' after \\begin{document}"
echo "  2. Recompile: pdflatex mwe-headers-draft.tex"
echo "  3. Headers should show only title on odd pages"

