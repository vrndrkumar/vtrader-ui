# WebSocket Quick Start Guide

## ✅ Implementation Complete!

Your Flutter app now has **real-time WebSocket support** for option chain data using Protobuf binary messages.

---

## 🎯 What Was Implemented

### 1. **Protobuf Schema**
- ✅ Created `protos/option_chain.proto`
- ✅ Generated Dart classes in `lib/generated/protos/`

### 2. **WebSocket Service**
- ✅ `OptionChainWebSocketService` - Connects to `wss://apivtrader.a.pinggy.link`
- ✅ Handles binary Protobuf messages
- ✅ Auto-reconnection + heartbeat
- ✅ Subscribe/unsubscribe methods

### 3. **Data Bridge Service**
- ✅ `RealOptionChainService` - Converts Protobuf → App Models
- ✅ Manages option chain stream
- ✅ Groups strikes (CE/PE pairs)

### 4. **UI Integration**
- ✅ Trade page listens to real-time stream
- ✅ Auto-subscribes on index/expiry change
- ✅ Updates option chain table in real-time

---

## 🚀 How It Works

### On App Load
```
1. App starts
2. WebSocket connects to wss://apivtrader.a.pinggy.link
3. Trade page subscribes to default index (e.g., NIFTY) and first expiry
4. Channel: OPTION_CHAIN_NIFTY_20OCT25
5. Server sends binary Protobuf data
6. UI updates with real-time option chain
```

### When User Changes Selection
```
1. User selects BANKNIFTY from dropdown
2. Unsubscribe: OPTION_CHAIN_NIFTY_20OCT25
3. Subscribe: OPTION_CHAIN_BANKNIFTY_28OCT25
4. Server sends new data
5. UI updates automatically
```

---

## 🔍 How to Verify It's Working

### Check Console Logs
Open browser DevTools console and look for:

```
✅ GOOD SIGNS:
🔌 WebSocket: Connecting to wss://apivtrader.a.pinggy.link
✅ WebSocket: Connected successfully
📡 WebSocket: Subscribed to OPTION_CHAIN_NIFTY_20OCT25
📦 WebSocket: Received binary message (1234 bytes)
📊 WebSocket: Decoded 50 option data points
📊 TradePage: Received option chain with 45 strikes
```

```
❌ BAD SIGNS (if you see these):
❌ WebSocket: Connection failed: [error]
❌ WebSocket: Error occurred: [error]
⚠️ WebSocket: Connection timeout after 10 seconds
```

---

## 📊 Testing Checklist

- [ ] **Check WebSocket Connection**
  - Open browser console
  - Look for "✅ WebSocket: Connected successfully"

- [ ] **Test Default Subscription**
  - Page loads with NIFTY selected
  - Check console for "📡 WebSocket: Subscribed to OPTION_CHAIN_NIFTY_..."
  - Option chain table shows data

- [ ] **Test Index Change**
  - Change from NIFTY to BANKNIFTY
  - Check console for unsubscribe → subscribe messages
  - Option chain updates with BANKNIFTY data

- [ ] **Test Expiry Change**
  - Select different expiry from dropdown
  - Check console for new subscription
  - Option chain updates with new expiry data

- [ ] **Test Real-Time Updates**
  - Keep page open
  - Watch for periodic binary message logs
  - Option chain values should update (LTP, volume, OI)

---

## 🛠️ Key Files

```
vtrader/
├── protos/
│   └── option_chain.proto                     # Protobuf schema
│
├── lib/
│   ├── generated/protos/
│   │   ├── option_chain.pb.dart              # Generated Protobuf classes
│   │   ├── option_chain.pbenum.dart
│   │   └── option_chain.pbjson.dart
│   │
│   ├── shared/services/
│   │   └── option_chain_websocket_service.dart  # WebSocket connection
│   │
│   └── features/trade/
│       ├── data/services/
│       │   └── real_option_chain_service.dart   # Data conversion
│       │
│       └── presentation/pages/
│           └── trade_page.dart                  # UI integration
│
└── pubspec.yaml                               # Dependencies added
```

---

## 📦 Dependencies Added

```yaml
# WebSocket
web_socket_channel: ^2.4.0

# Protobuf
protobuf: ^3.1.0
fixnum: ^1.1.0
```

---

## 🔧 Configuration

### WebSocket URL
```dart
static const String _webSocketUrl = 'wss://apivtrader.a.pinggy.link';
```

### Channel Format
```dart
'OPTION_CHAIN_${index.toUpperCase()}_$expiry'
// Examples:
// OPTION_CHAIN_NIFTY_20OCT25
// OPTION_CHAIN_BANKNIFTY_28OCT25
```

### Reconnection Settings
- **Timeout:** 10 seconds
- **Reconnect Delay:** 5 seconds
- **Heartbeat Interval:** 30 seconds

---

## 💡 Usage Examples

### Subscribe to Option Chain
```dart
final service = RealOptionChainService.instance;
await service.initialize();
await service.subscribeToOptionChain('NIFTY', '20OCT25');
```

### Listen to Real-Time Data
```dart
service.optionChainStream.listen((optionChain) {
  if (optionChain != null) {
    print('Received ${optionChain.strikes.length} strikes');
    // Update UI
  }
});
```

### Unsubscribe
```dart
await service.unsubscribe();
```

---

## 🎨 UI Behavior

### Option Chain Widget
- Shows real-time data from WebSocket
- Updates automatically when data arrives
- No manual refresh needed
- Loading indicator while waiting for first data

### Dropdown Behavior
- **Index Dropdown:** Changes subscription to new index
- **Expiry Dropdown:** Changes subscription to new expiry
- Both trigger unsubscribe → subscribe sequence

---

## 🐛 Common Issues & Solutions

### Issue: "WebSocket not connecting"
**Solution:**
- Check if `wss://apivtrader.a.pinggy.link` is reachable
- Verify network/firewall settings
- Check browser console for detailed error

### Issue: "No data in option chain"
**Solution:**
- Verify subscription channel format is correct
- Check if server is sending data for that channel
- Look for Protobuf decoding errors in console

### Issue: "Connection drops frequently"
**Solution:**
- Check network stability
- Heartbeat will keep connection alive
- Auto-reconnection will handle temporary drops

---

## 📈 Performance Notes

- **Binary Protobuf** is more efficient than JSON (smaller payload)
- **Streaming** provides real-time updates without polling
- **Broadcast Stream** allows multiple widgets to listen
- **Auto-reconnection** ensures reliability

---

## 🎯 Success Criteria

✅ Your implementation is successful if:

1. Console shows "✅ WebSocket: Connected successfully"
2. You see "📡 WebSocket: Subscribed to..." messages
3. Binary messages are received and decoded
4. Option chain table displays data
5. Changing index/expiry updates the data
6. No error messages in console

---

## 📞 Next Actions

1. **Test the app** - Load the trade page and check console logs
2. **Verify subscriptions** - Change index/expiry and monitor logs
3. **Monitor real-time updates** - Watch for periodic data updates
4. **Report issues** - Share console logs if something isn't working

---

**Status:** ✅ **READY TO TEST**  
**URL:** `http://localhost:3000` (or your configured URL)  
**Console:** Browser DevTools → Console tab  
**Expected:** Real-time option chain data via WebSocket

