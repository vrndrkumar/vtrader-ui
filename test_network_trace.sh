#!/bin/bash

echo "======================================"
echo "🔍 NETWORK TRACE VERIFICATION"
echo "======================================"
echo ""
echo "✅ VERIFICATION RESULTS:"
echo ""
echo "1. Localhost:3001 references in compiled JS:"
LOCALHOST_COUNT=$(strings /Users/virendrakumar/trade-knowingly-project/vtrader/build/web/main.dart.js | grep -c 'localhost:3001' || echo "0")
echo "   Count: $LOCALHOST_COUNT (MUST BE 0)"
if [ "$LOCALHOST_COUNT" -eq 0 ]; then
    echo "   ✅ PASS: No localhost references found!"
else
    echo "   ❌ FAIL: localhost:3001 still exists in compiled code!"
fi
echo ""

echo "2. Production URL references in compiled JS:"
PROD_COUNT=$(strings /Users/virendrakumar/trade-knowingly-project/vtrader/build/web/main.dart.js | grep -c 'apivtrader.a.pinggy.link' || echo "0")
echo "   Count: $PROD_COUNT (SHOULD BE >0)"
if [ "$PROD_COUNT" -gt 0 ]; then
    echo "   ✅ PASS: Production URL found $PROD_COUNT times!"
else
    echo "   ❌ FAIL: Production URL not found!"
fi
echo ""

echo "3. All production URL references:"
strings /Users/virendrakumar/trade-knowingly-project/vtrader/build/web/main.dart.js | grep 'apivtrader.a.pinggy.link' | sort | uniq
echo ""

echo "4. Source code verification (lib files):"
LOCALHOST_IN_SOURCE=$(grep -r 'localhost:3001' /Users/virendrakumar/trade-knowingly-project/vtrader/lib 2>/dev/null | wc -l | tr -d ' ')
echo "   Localhost references in source: $LOCALHOST_IN_SOURCE (MUST BE 0)"
if [ "$LOCALHOST_IN_SOURCE" -eq 0 ]; then
    echo "   ✅ PASS: No localhost in source code!"
else
    echo "   ❌ FAIL: localhost:3001 still in source code!"
    grep -r 'localhost:3001' /Users/virendrakumar/trade-knowingly-project/vtrader/lib
fi
echo ""

echo "======================================"
echo "📋 TESTING INSTRUCTIONS:"
echo "======================================"
echo ""
echo "Test on localhost:3000:"
echo "1. Open http://localhost:3000 in browser"
echo "2. Open DevTools (F12) -> Network tab"
echo "3. Clear browser cache (Cmd+Shift+Delete)"
echo "4. Hard refresh (Cmd+Shift+R)"
echo "5. Try to login"
echo "6. Verify ALL API calls go to: https://apivtrader.a.pinggy.link"
echo ""
echo "Test on vtrader.in:"
echo "1. UNREGISTER SERVICE WORKER:"
echo "   - Open DevTools -> Application -> Service Workers"
echo "   - Click 'Unregister'"
echo "   - Clear Storage -> 'Clear site data'"
echo "2. Open https://vtrader.in in NEW INCOGNITO window"
echo "3. Open DevTools -> Network tab"
echo "4. Try to login"
echo "5. Verify ALL API calls go to: https://apivtrader.a.pinggy.link"
echo ""
echo "======================================"
echo "📝 EXPECTED API CALLS:"
echo "======================================"
echo "- Login: https://apivtrader.a.pinggy.link/users/api/login"
echo "- Trades: https://apivtrader.a.pinggy.link/trades"
echo "- Tags: https://apivtrader.a.pinggy.link/tags"
echo "- Positions: https://apivtrader.a.pinggy.link/trade/positions"
echo "- Orders: https://apivtrader.a.pinggy.link/trade/orders"
echo "- Indices: https://apivtrader.a.pinggy.link/broker-mstr"
echo ""

