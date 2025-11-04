#!/bin/bash
# Compilation script for font shape bug MWE
# Demonstrates the bug by attempting compilation without workaround

set -e

echo "============================================"
echo "Font Shape Bug Demonstration"
echo "============================================"
echo ""

# Test 1: Compile WITHOUT workaround (should fail)
echo "Test 1: Compiling WITHOUT workaround (will fail)..."
echo "Command: pdflatex -interaction=nonstopmode mwe-font-shape.tex"
echo ""

if pdflatex -interaction=nonstopmode mwe-font-shape.tex > compile-output.log 2>&1; then
    echo "❌ UNEXPECTED: Compilation succeeded without workaround"
    echo "   This may indicate the bug has been fixed in your TeX distribution"
else
    echo "✅ EXPECTED: Compilation failed with font error"
    echo ""
    echo "Error message:"
    grep -A 2 "Font.*not found" compile-output.log || echo "  (see compile-output.log for details)"
fi

echo ""
echo "============================================"
echo ""

# Clean up auxiliary files
rm -f mwe-font-shape.aux mwe-font-shape.log mwe-font-shape.out

echo "To test the workaround:"
echo "  1. Uncomment '% \\usepackage{workaround}' in mwe-font-shape.tex"
echo "  2. Run: pdflatex mwe-font-shape.tex"
echo "  3. Compilation should succeed"
echo ""
echo "Log file saved to: compile-output.log"

