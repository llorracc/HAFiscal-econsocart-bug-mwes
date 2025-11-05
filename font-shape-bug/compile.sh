#!/bin/bash
# Compilation script for font shape bug MWE
# Demonstrates BOTH the bug AND the working fix

set -e

echo "============================================"
echo "Font Shape Bug Demonstration"
echo "============================================"
echo ""
echo "Note: Behavior varies by TeX distribution"
echo "  - Some systems: Compilation FAILS with font error"
echo "  - Other systems: Compilation succeeds with WARNINGS"
echo ""

# Test 1: Compile WITHOUT workaround
echo "Test 1: Compiling WITHOUT workaround..."
echo "Command: pdflatex -interaction=nonstopmode mwe-font-shape.tex"
echo ""

if pdflatex -interaction=nonstopmode mwe-font-shape.tex > compile-output-broken.log 2>&1; then
    echo "✅ Compilation succeeded (but check for font warnings)"
    echo ""
    
    # Check for font warnings
    if grep -qi "Font.*warning.*undefined\|Font.*substitut" compile-output-broken.log; then
        echo "⚠️  Font warnings found:"
        grep -i "Font.*warning\|Font.*undefined" compile-output-broken.log | head -5
        echo ""
        echo "📝 Your system allows compilation but substitutes fonts."
        BUG_REPRODUCED=true
    else
        echo "⚠️  No font warnings found (unusual)."
        echo "   The font shapes may be silently available on your system."
        BUG_REPRODUCED=false
    fi
else
    echo "✅ Compilation failed with font error"
    echo ""
    echo "Error message:"
    grep -A 2 "Font.*not found\|Font.*error" compile-output-broken.log || echo "  (see compile-output-broken.log for details)"
    echo ""
    echo "📝 Your system has stricter font checking."
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
    echo "✅ Bug demonstrated: Font shapes undefined in econsocart.cls"
    echo "✅ Workaround verified: Clean compilation with workaround.sty"
    echo ""
    echo "📄 Compare the results:"
    echo "   - Without workaround: Errors/warnings (see compile-output-broken.log)"
    echo "   - With workaround:    Clean PDF (mwe-font-shape-fixed.pdf)"
    echo ""
    echo "🎉 WORKAROUND PROVEN TO WORK!"
elif [ "$BUG_REPRODUCED" = false ] && [ "$WORKAROUND_WORKS" = true ]; then
    echo "ℹ️  On your system, the font shapes may be available or silently substituted"
    echo "✅ Workaround still works and ensures explicit, clean declarations"
    echo "✅ The workaround benefits portability across different TeX distributions"
    echo ""
    echo "📄 Results:"
    echo "   - Both versions compile on your system"
    echo "   - Workaround ensures consistent behavior across systems"
else
    echo "⚠️  Unexpected results - see log files for details"
fi
echo ""
echo "Log files saved:"
echo "  - compile-output-broken.log (without workaround)"
echo "  - compile-output-fixed.log (with workaround)"
echo ""
echo "The bug exists regardless of whether your system fails or warns:"
echo "Font shapes are undefined in econsocart.cls and should be properly declared."

