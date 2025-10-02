#!/bin/bash

echo "🚀 Deploying VTrader to Production..."
echo ""

# Check if build directory exists
if [ ! -d "build/web" ]; then
    echo "❌ Build directory not found. Building now..."
    flutter build web --release
fi

echo "✅ Build found at: build/web"
echo ""
echo "📦 Build Size:"
du -sh build/web
echo ""

# Show build timestamp
echo "📅 Build Timestamp:"
ls -la build/web/main.dart.js | awk '{print $6, $7, $8}'
echo ""

# Verify API URL in build
echo "🔍 Verifying API URLs in build:"
prod_count=$(grep -o "apivtrader.a.pinggy.link" build/web/main.dart.js | wc -l | tr -d ' ')
dev_count=$(grep -o "localhost:3001" build/web/main.dart.js | wc -l | tr -d ' ')
echo "  Production URL (apivtrader.a.pinggy.link): $prod_count occurrences"
echo "  Development URL (localhost:3001): $dev_count occurrences"
echo ""

if [ "$prod_count" -gt "$dev_count" ]; then
    echo "✅ Build is configured for PRODUCTION"
else
    echo "⚠️  Warning: Build might still have development URLs"
fi

echo ""
echo "================================"
echo "DEPLOYMENT OPTIONS:"
echo "================================"
echo ""
echo "1. FTP/SFTP Upload:"
echo "   Upload contents of 'build/web' to your web server"
echo ""
echo "2. SCP (for SSH access):"
echo "   scp -r build/web/* user@vtrader.in:/var/www/html/"
echo ""
echo "3. Netlify:"
echo "   netlify deploy --prod --dir=build/web"
echo ""
echo "4. Vercel:"
echo "   vercel --prod build/web"
echo ""
echo "5. Firebase:"
echo "   firebase deploy"
echo ""
echo "================================"
echo ""
echo "📋 Next Steps:"
echo "1. Upload 'build/web' contents to https://vtrader.in"
echo "2. Clear CDN cache if using one"
echo "3. Hard refresh browser (Cmd+Shift+R)"
echo ""

