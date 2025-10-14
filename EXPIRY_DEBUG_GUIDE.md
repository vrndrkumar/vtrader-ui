# Expiry Dropdown Debug Guide

## ✅ **App is Running with Expiry Dropdown in Top Controls!**

### **🎯 What You Should See Now:**

**At the TOP of the Trade page:**
```
[Trade Terminal] [Index: NIFTY ▼] [Expiry: 14/10/2025 ▼] [Last Updated: 09:49:00] [🔄]
```

### **🔍 If You Still See "Expiry: NOT SET":**

The issue is that the expiry dropdown is not being populated or the initialization is not working. Here's how to debug:

---

## 🧪 **Step-by-Step Debug:**

### **Step 1: Check Top Controls**
Look at the very top of the Trade page. You should see:
- ✅ "Trade Terminal" title
- ✅ "Index: NIFTY ▼" dropdown
- ✅ "Expiry: [something] ▼" dropdown ← **This should be there now**

### **Step 2: Check Browser Console**
Open F12 → Console and look for these logs:
```
📅 Available expiries: [14OCT25, 20OCT25, 28OCT25]
📅 Setting expiry: API=14OCT25, Dropdown=14/10/2025
📡 Subscribing to: NIFTY - 14OCT25
```

### **Step 3: Check Master Data**
The expiry dropdown depends on master data. Look for:
```
📅 Index already selected: NIFTY, expiries: [14OCT25, 20OCT25, 28OCT25]
```

---

## 🐛 **If Expiry Dropdown is Missing:**

### **Possible Issues:**

1. **Master Data Not Loaded**
   - Check console for master data loading
   - Look for API calls to indices endpoint

2. **Provider Not Working**
   - `availableExpiriesProvider` might not be providing data
   - Check if `selectedIndexProvider` has data

3. **UI Not Updating**
   - Hot reload might not have applied
   - Try hard refresh: Ctrl+Shift+R

---

## 🔧 **Quick Fixes:**

### **Fix 1: Hard Refresh**
```
Ctrl+Shift+R (Windows/Linux)
Cmd+Shift+R (Mac)
```

### **Fix 2: Check Console Logs**
Open F12 → Console and look for:
- Any error messages
- Master data loading logs
- Expiry initialization logs

### **Fix 3: Manual Test**
If you see the expiry dropdown but it's empty:
1. Click on it
2. Check if it shows "Select Expiry" or has options
3. If empty, the provider is not getting data

---

## 📊 **Expected Flow:**

```
1. Page loads
   ↓
2. Master data API called
   ↓
3. Indices loaded (NIFTY, BANKNIFTY, SENSEX)
   ↓
4. First index selected (NIFTY)
   ↓
5. Expiries extracted from NIFTY data
   ↓
6. First expiry selected (14OCT25)
   ↓
7. Converted to dropdown format (14/10/2025)
   ↓
8. Expiry dropdown shows "14/10/2025"
   ↓
9. WebSocket subscribes to OPTION_CHAIN_NIFTY_14OCT25
```

---

## 🎯 **What to Report:**

Please tell me:

1. **Do you see the expiry dropdown?** (next to Index dropdown at top)
2. **What does it show?** (empty, "Select Expiry", or a date)
3. **Browser console logs?** (F12 → Console, look for 📅 logs)
4. **Any error messages?** (red text in console)

---

## 📝 **Current Status:**

✅ **App is running** at http://localhost:3000  
✅ **Expiry dropdown added** to top controls  
✅ **Debug logs added** for troubleshooting  
⏳ **Waiting for you to test** and report what you see  

---

**Please refresh http://localhost:3000 and check if you can see the expiry dropdown next to the index dropdown at the top!** 🚀
