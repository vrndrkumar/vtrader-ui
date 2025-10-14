# WebSocket Implementation for Real-Time Option Chain

## 📋 Overview

This document describes the complete WebSocket implementation for real-time option chain data using **Protobuf** for binary message encoding.

---

## 🏗️ Architecture

### Components

1. **Protobuf Schema** (`protos/option_chain.proto`)
   - Defines the message structure for option data
   - Compiled to Dart classes in `lib/generated/protos/`

2. **WebSocket Service** (`lib/shared/services/option_chain_websocket_service.dart`)
   - Low-level WebSocket connection management
   - Handles binary Protobuf messages
   - Provides subscribe/unsubscribe functionality
   - Auto-reconnection with heartbeat

3. **Real Option Chain Service** (`lib/features/trade/data/services/real_option_chain_service.dart`)
   - Bridges WebSocket data with app's domain models
   - Converts Protobuf messages to `OptionChainModel`
   - Manages subscription lifecycle

4. **Trade Page Integration** (`lib/features/trade/presentation/pages/trade_page.dart`)
   - Consumes real-time option chain stream
   - Manages WebSocket subscriptions based on user selections
   - Updates UI with live data

---

## 🔌 WebSocket Connection

### URL
```
wss://apivtrader.a.pinggy.link
```

### Channel Format
```
OPTION_CHAIN_<INDEX>_<EXPIRY>
```

### Examples
- `OPTION_CHAIN_NIFTY_20OCT25`
- `OPTION_CHAIN_BANKNIFTY_28OCT25`
- `OPTION_CHAIN_SENSEX_27OCT25`

---

## 📦 Message Flow

### 1. Subscription Request (JSON)
```json
{
  "action": "subscribe",
  "channel": "OPTION_CHAIN_NIFTY_20OCT25"
}
```

### 2. Server Response (Binary Protobuf)
The server sends binary data encoded with the following Protobuf structure:

```protobuf
message OptionData {
  string symbol = 1;
  double ask = 2;
  double bid = 3;
  double ltp = 4;
  double ltpch = 5;
  double ltpchp = 6;
  string optionType = 7;
  double strikePrice = 8;
  double oi = 9;
  double oich = 10;
  double oichp = 11;
  double volume = 12;
  double fp = 13;
  double fpch = 14;
  double fpchp = 15;
}

message OptionChain {
  repeated OptionData options = 1;
}
```

### 3. Data Processing
1. Binary message received via WebSocket
2. Decoded using `OptionChain.fromBuffer(message)`
3. Converted to app's `OptionChainModel`
4. Emitted to UI via Stream

---

## 🚀 Usage

### On App Start
The WebSocket automatically connects and subscribes to the default index and expiry shown in the dropdown.

```dart
// In trade_page.dart - initState()
_realOptionChainService = RealOptionChainService.instance;
_initializeWebSocket();
```

### On Index/Expiry Change
When user changes index or expiry:
1. Unsubscribe from old channel
2. Subscribe to new channel

```dart
// Example: User changes from NIFTY to BANKNIFTY
_realOptionChainService.unsubscribe();
_realOptionChainService.subscribeToOptionChain('BANKNIFTY', '28OCT25');
```

---

## 🔧 Key Features

### ✅ Auto-Reconnection
If WebSocket disconnects, it automatically attempts to reconnect every 5 seconds.

### ✅ Heartbeat
Sends ping messages every 30 seconds to keep connection alive.

### ✅ Error Handling
All errors are logged and exposed via error stream for monitoring.

### ✅ Dynamic Subscriptions
Automatically manages subscriptions based on user's current selection.

### ✅ Format Conversion
Handles both dropdown format (`14/10/2025`) and API format (`14OCT25`).

---

## 📊 Data Flow Diagram

```
User Selection (NIFTY, 20OCT25)
        ↓
TradePage._subscribeToOptionChain()
        ↓
RealOptionChainService.subscribeToOptionChain()
        ↓
OptionChainWebSocketService.subscribe()
        ↓
[WebSocket] → Send JSON: {"action": "subscribe", "channel": "OPTION_CHAIN_NIFTY_20OCT25"}
        ↓
[Server] → Send Binary Protobuf Data
        ↓
OptionChainWebSocketService._handleMessage()
        ↓
Decode: OptionChain.fromBuffer(binaryData)
        ↓
RealOptionChainService._handleProtobufData()
        ↓
Convert to OptionChainModel
        ↓
Stream → _optionChainController.add(optionChain)
        ↓
TradePage listens to stream
        ↓
setState(() { _optionChain = optionChain; })
        ↓
UI Updates with Real-Time Data
```

---

## 🧪 Testing

### Check WebSocket Connection
Look for these logs in the console:

```
🔌 WebSocket: Connecting to wss://apivtrader.a.pinggy.link
✅ WebSocket: Connected successfully
📡 WebSocket: Subscribed to OPTION_CHAIN_NIFTY_20OCT25
📦 WebSocket: Received binary message (1234 bytes)
📊 WebSocket: Decoded 50 option data points
```

### Verify Subscription Changes
When changing index or expiry, you should see:

```
📡 WebSocket: Unsubscribed from OPTION_CHAIN_NIFTY_20OCT25
📡 WebSocket: Subscribed to OPTION_CHAIN_BANKNIFTY_28OCT25
📊 TradePage: Received option chain with 45 strikes
```

---

## 🛠️ Setup Instructions

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Protobuf Classes (Already Done)
```bash
protoc --dart_out=lib/generated protos/option_chain.proto
```

### 3. Run Application
```bash
flutter run -d web-server --web-port 3000 --web-hostname 0.0.0.0
```

---

## 📝 Files Created/Modified

### Created
- `protos/option_chain.proto` - Protobuf schema
- `lib/generated/protos/option_chain.pb.dart` - Generated Dart classes
- `lib/shared/services/option_chain_websocket_service.dart` - WebSocket service
- `lib/features/trade/data/services/real_option_chain_service.dart` - Data bridge service

### Modified
- `pubspec.yaml` - Added web_socket_channel, protobuf dependencies
- `lib/features/trade/presentation/pages/trade_page.dart` - Integrated WebSocket

---

## 🐛 Troubleshooting

### WebSocket Not Connecting?
1. Check console for connection logs
2. Verify URL: `wss://apivtrader.a.pinggy.link`
3. Check network/firewall settings
4. Ensure server is running

### No Data Received?
1. Verify subscription channel format
2. Check if expiry format conversion is correct
3. Look for error logs in console
4. Verify server is sending data for requested channel

### Connection Drops?
- Auto-reconnection will trigger after 5 seconds
- Heartbeat keeps connection alive (30s interval)
- Check network stability

---

## 🎯 Next Steps

### Optional Enhancements
1. **Add Loading Indicator** - Show WebSocket connection status
2. **Connection Status Widget** - Visual indicator for connected/disconnected state
3. **Historical Data Fallback** - Use cached data when WebSocket is disconnected
4. **Performance Optimization** - Throttle UI updates for high-frequency data

---

## 📞 Support

For issues or questions about the WebSocket implementation:
1. Check console logs for detailed error messages
2. Verify all files are properly created
3. Ensure dependencies are installed
4. Test WebSocket connection independently

---

**Implementation Date:** October 14, 2025  
**WebSocket Protocol:** WSS (Secure WebSocket)  
**Message Format:** Protobuf (Binary)  
**Status:** ✅ Implemented & Tested

