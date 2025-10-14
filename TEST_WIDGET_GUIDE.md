# WebSocket Test Widget Guide

## 🎯 NEW: Interactive Test Panel

I've created a **prominent test widget** at the top of the Trade page that lets you manually test the WebSocket connection!

---

## 🖼️ What You'll See

A large, colored panel at the top with:
- **Status Indicator** (Green/Red/Grey circle icon)
- **Message Counter** (shows incoming messages)
- **Test Channel Input Field**
- **4 Action Buttons**: CONNECT, DISCONNECT, SUBSCRIBE, CLEAR LOGS
- **Active Channel Display** (shows current subscription)
- **Live Logs** (black console showing what's happening)

---

## 🧪 How to Test

### **Step 1: Open the Trade Page**
Go to: **http://localhost:3000** → Click "Trade"

### **Step 2: Look at the Top**
You should see a **large colored panel** with "WebSocket Test Panel" title

### **Step 3: Click "CONNECT" Button**
- Button is **GREEN**
- This will connect to `wss://apivtrader.a.pingpy.link`
- Watch the **logs** in the black box below
- You should see: `[HH:MM:SS] Connecting to WebSocket...`
- Then: `[HH:MM:SS] Status changed: connected`

### **Step 4: Click "SUBSCRIBE" Button**
- Button is **BLUE**
- Default channel is `OPTION_CHAIN_NIFTY_14OCT25`
- You can change it in the text field
- Watch logs for: `[HH:MM:SS] Subscribing to: OPTION_CHAIN_NIFTY_14OCT25`

### **Step 5: Watch for Data**
- If server sends data, you'll see:
  - Message counter increases
  - Logs show: `[HH:MM:SS] Received data: XX options`

---

## 🎨 Visual Indicators

### **Status Colors:**
- **GREY**: Disconnected (not connected yet)
- **ORANGE**: Connecting (in progress)
- **GREEN**: Connected (ready to receive data)
- **RED**: Error (something went wrong)

### **Log Colors:**
- **GREEN text**: Normal logs
- **All logs timestamped**: `[HH:MM:SS] Message`

---

## 🔧 Test Buttons

| Button | Color | What It Does |
|--------|-------|-------------|
| **CONNECT** | Green | Connects to WebSocket server |
| **DISCONNECT** | Red | Disconnects from WebSocket |
| **SUBSCRIBE** | Blue | Subscribes to channel in text field |
| **CLEAR LOGS** | Grey | Clears the log console |

---

## 📝 Testing Different Channels

You can test any channel by editing the text field:

### **NIFTY:**
```
OPTION_CHAIN_NIFTY_14OCT25
OPTION_CHAIN_NIFTY_20OCT25
OPTION_CHAIN_NIFTY_28OCT25
```

### **BANKNIFTY:**
```
OPTION_CHAIN_BANKNIFTY_28OCT25
```

### **SENSEX:**
```
OPTION_CHAIN_SENSEX_16OCT25
OPTION_CHAIN_SENSEX_23OCT25
OPTION_CHAIN_SENSEX_30OCT25
```

---

## 🐛 Troubleshooting

### **Issue: Status stays GREY**
**Check:**
1. Click "CONNECT" button - did you click it?
2. Look at logs - any errors?
3. Open browser console (F12) - any network errors?

### **Issue: Connected but no data**
**Check:**
1. Did you click "SUBSCRIBE"?
2. Is the channel format correct?
3. Server might not be sending data for that channel
4. Check browser console for WebSocket messages

### **Issue: Can't see the test panel**
**Check:**
1. Are you on the Trade page?
2. Scroll to the very top of the page
3. Hard refresh: Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)

### **Issue: Errors in logs**
**Common errors:**
- `Connection timeout` - Server not responding
- `Invalid channel format` - Check channel string
- `WebSocket error` - Check browser console (F12)

---

## 🎯 Expected Flow

```
1. Click CONNECT
   ↓
   Status turns ORANGE (connecting)
   ↓
   Status turns GREEN (connected)
   ↓
2. Click SUBSCRIBE
   ↓
   Logs show: "Subscribing to: OPTION_CHAIN_..."
   ↓
   Active Channel box appears (blue)
   ↓
3. Wait for data
   ↓
   Message counter increases
   ↓
   Logs show: "Received data: XX options"
   ↓
   Option chain table populates below
```

---

## 📊 What to Report

If it's not working, please tell me:

1. **Status color** (Grey/Orange/Green/Red)
2. **What you see in logs** (copy the messages)
3. **Browser console errors** (F12 → Console tab)
4. **Network tab** (F12 → Network → WS filter)

---

## 🚀 Current Status

**App is rebuilding now...**

Once it's ready:
1. Refresh http://localhost:3000
2. Go to Trade page
3. You'll see the **BIG TEST PANEL** at the top
4. Click the buttons and watch what happens!

---

**The test widget will show you EXACTLY what's happening with the WebSocket in real-time!** 🎉

