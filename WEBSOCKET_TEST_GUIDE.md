# WebSocket Test Guide

## ✅ App is Running!

Your Flutter app is now running at: **http://localhost:3000**

---

## 🧪 How to Test WebSocket Implementation

### **Step 1: Open the App**
1. Open your browser
2. Go to: `http://localhost:3000`
3. Navigate to the **Trade** page

### **Step 2: Check Console Logs**
1. Open **Developer Tools** (F12 or right-click → Inspect)
2. Go to **Console** tab
3. Look for these logs:

```
✅ GOOD SIGNS:
🔌 WebSocket: Connecting to wss://apivtrader.a.pinggy.link
✅ WebSocket: Connected successfully
📡 WebSocket: Subscribed to OPTION_CHAIN_NIFTY_20OCT25
📦 WebSocket: Received binary message (1234 bytes)
📊 WebSocket: Decoded 50 option data points
📊 TradePage: Received option chain with 45 strikes
```

### **Step 3: Test Index Change**
1. Change the index dropdown from **NIFTY** to **BANKNIFTY**
2. Watch console for:
```
📡 WebSocket: Unsubscribed from OPTION_CHAIN_NIFTY_20OCT25
📡 WebSocket: Subscribed to OPTION_CHAIN_BANKNIFTY_28OCT25
📊 TradePage: Received option chain with 35 strikes
```

### **Step 4: Test Expiry Change**
1. Change the expiry dropdown to a different date
2. Watch console for new subscription message
3. Option chain should update with new data

### **Step 5: Verify Real-Time Updates**
1. Keep the page open for 30+ seconds
2. Watch for periodic binary message logs
3. Option chain values (LTP, volume, OI) should update

---

## 🔍 What to Look For

### **✅ Success Indicators:**
- Console shows "✅ WebSocket: Connected successfully"
- You see subscription messages when page loads
- Binary messages are received and decoded
- Option chain table shows data (not empty)
- Changing index/expiry updates the data
- No error messages in console

### **❌ Problem Indicators:**
- Console shows "❌ WebSocket: Connection failed"
- No subscription messages
- Option chain table is empty
- Error messages about protobuf decoding
- Connection timeout messages

---

## 🐛 Troubleshooting

### **Issue: "WebSocket not connecting"**
**Check:**
- Is `wss://apivtrader.a.pinggy.link` reachable?
- Are there any network/firewall issues?
- Check browser console for detailed error

### **Issue: "No data in option chain"**
**Check:**
- Are subscription messages appearing?
- Is the channel format correct?
- Are binary messages being received?
- Check for protobuf decoding errors

### **Issue: "Connection drops"**
**Expected behavior:**
- Auto-reconnection will trigger after 5 seconds
- Heartbeat keeps connection alive (30s interval)
- Temporary network issues are handled automatically

---

## 📊 Expected Console Output

### **On Page Load:**
```
🚀 TradePage: Initializing WebSocket service...
🔌 WebSocket: Connecting to wss://apivtrader.a.pinggy.link
✅ WebSocket: Connected successfully
📡 WebSocket: Subscribed to OPTION_CHAIN_NIFTY_20OCT25
📦 WebSocket: Received binary message (1234 bytes)
📊 WebSocket: Decoded 50 option data points
📊 TradePage: Received option chain with 45 strikes
✅ TradePage: WebSocket service initialized
```

### **On Index Change:**
```
Index changing from NIFTY to BANKNIFTY
📡 WebSocket: Unsubscribed from OPTION_CHAIN_NIFTY_20OCT25
📡 WebSocket: Subscribed to OPTION_CHAIN_BANKNIFTY_28OCT25
📦 WebSocket: Received binary message (987 bytes)
📊 WebSocket: Decoded 35 option data points
📊 TradePage: Received option chain with 30 strikes
```

### **Periodic Updates:**
```
📦 WebSocket: Received binary message (1234 bytes)
📊 WebSocket: Decoded 50 option data points
📊 TradePage: Received option chain with 45 strikes
💓 WebSocket: Heartbeat sent
```

---

## 🎯 Test Checklist

- [ ] **App loads successfully** at http://localhost:3000
- [ ] **Trade page accessible** and loads without errors
- [ ] **Console shows WebSocket connection** success message
- [ ] **Default subscription** appears (NIFTY + first expiry)
- [ ] **Option chain table** displays data (not empty)
- [ ] **Index change** triggers unsubscribe → subscribe
- [ ] **Expiry change** triggers new subscription
- [ ] **Real-time updates** appear periodically
- [ ] **No error messages** in console

---

## 📞 If Something's Not Working

### **Share these details:**
1. **Console logs** (copy/paste the error messages)
2. **Which step failed** (connection, subscription, data, etc.)
3. **Browser used** (Chrome, Firefox, Safari, etc.)
4. **Network environment** (corporate firewall, VPN, etc.)

### **Quick fixes to try:**
1. **Refresh the page** (Ctrl+F5 or Cmd+Shift+R)
2. **Clear browser cache** and reload
3. **Try different browser** (Chrome recommended)
4. **Check network connectivity** to the WebSocket URL

---

## 🎉 Success!

If you see the expected console logs and the option chain updates in real-time, then your WebSocket implementation is working perfectly! 

The app is now receiving live option chain data via WebSocket with Protobuf binary messages, exactly as requested.

---

**Status:** ✅ **READY FOR TESTING**  
**URL:** http://localhost:3000  
**Expected:** Real-time option chain data via WebSocket
