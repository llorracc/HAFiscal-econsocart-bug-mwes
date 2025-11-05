#!/bin/bash
# Compilation script for font shape bug MWE
# Demonstrates BOTH the bug AND the working fix

set -e

echo "============================================"
echo "Font Shape Bug Demonstration"
echo "============================================"
echo ""

# Test 1: Compile WITHOUT workaround (should fail)
echo "Test 1: Compiling WITHOUT workaround (expected to fail)..."
echo "Command: pdflatex -interaction=nonstopmode mwe-font-shape.tex"
echo ""

if pdflatex -interaction=nonstopmode mwe-font-shape.tex > compile-output-broken.log 2>&1; then
    echo "❌ UNEXPECTED: Compilation succeeded without workaround"
    echo "   This may indicate the bug has been fixed in your TeX distribution"
    BUG_REPRODUCED=false
else
    echo "✅ EXPECTED: Compilation failed with font error"
    echo ""
    echo "Error message:"
    grep -A 2 "Font.*not found" compile-output-broken.log || echo "  (see compile-output-broken.log for details)"
    BUG_REPRODUCED=true
fi

echo ""
echo "============================================"
echo ""

# Test 2: Compile WITH workaround (should succeed)
echo "Test 2: Compiling WITH workaround (expected to succeed)..."
echo "Command: pdflatex -interaction=nonstopmode mwe-font-shape-fixed.tex"
echo ""

if pdflatex -interaction=nonstopmode mwe-font-shape-fixed.tex > compile-output-fixed.log 2>&1; then
    # Run twice for proper references
    pdflatex -interaction=nonstopmode mwe-font-shape-fixed.tex > /dev/null 2>&1
    echo "✅ SUCCESS: Compilation succeeded with workaround!"
    echo ""
    echo "Generated PDF: mwe-font-shape-fixed.pdf"
    WORKAROUND_WORKS=true
else
    echo "❌ UNEXPECTED: Compilation failed even with workaround"
    echo "   See compile-output-fixed.log for details"
    WORKAROUND_WORKS=false
fi

# Clean up auxiliary files
rm -f mwe-font-shape.aux mwe-font-shape.log mwe-font-shape.out
rm -f mwe-font-shape-fixed.aux mwe-font-shape-fixed.log mwe-font-shape-fixed.out

echo ""
echo "============================================"
echo "SUMMARY"
echo "============================================"
if [ "$BUG_REPRODUCED" = true ] && [ "$WORKAROUND_WORKS" = true ]; then
    echo "✅ Bug reproduced: Font shape error occurs without workaround"
    echo "✅ Workaround verified: Compilation succeeds with workaround.sty"
    echo ""
    echo "📄 Compare the results:"
    echo "   - Broken version: Fails to compile (see compile-output-broken.log)"
    echo "   - Fixed version:  mwe-font-shape-fixed.pdf"
    echo ""
    echo "🎉 WORKAROUND PROVEN TO WORK!"
elif [ "$BUG_REPRODUCED" = false ] && [ "$WORKAROUND_WORKS" = true ]; then
    echo "⚠️  Bug may be fixed in your TeX distribution"
    echo "✅ Workaround still works and causes no harm"
else
    echo "⚠️  Unexpected results - see log files for details"
fi
echo ""
echo "Log files saved:"
echo "  - compile-output-broken.log (without workaround)"
echo "  - compile-output-fixed.log (with workaround)"

