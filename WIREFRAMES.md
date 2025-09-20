# VTrader App Wireframes

This document provides basic wireframes and layout descriptions for the main screens of the VTrader app.

## 1. Authentication Screens

### Sign In Page
```
┌─────────────────────────────────────┐
│                                     │
│           [VTrader Logo]            │
│                                     │
│         Welcome to VTrader          │
│      Sign in to your trading        │
│            journal                  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │ Email Address              │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │ Password              [👁]  │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │        Sign In              │  │
│    └─────────────────────────────┘  │
│                                     │
│         Forgot Password?            │
│                                     │
│              ─── or ───             │
│                                     │
│    ┌─────────────────────────────┐  │
│    │     Create Account          │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │ 💡 Demo Credentials         │  │
│    │ Email: demo@vtrader.in      │  │
│    │ Password: password123       │  │
│    └─────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
```

### Sign Up Page
```
┌─────────────────────────────────────┐
│ ← Join VTrader                   🌙 │
│                                     │
│           [VTrader Logo]            │
│                                     │
│         Join VTrader                │
│    Start your trading journal       │
│             today                   │
│                                     │
│ ┌─────────────┐ ┌─────────────────┐ │
│ │ First Name  │ │ Last Name       │ │
│ └─────────────┘ └─────────────────┘ │
│                                     │
│    ┌─────────────────────────────┐  │
│    │ Email Address              │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │ Password              [👁]  │  │
│    └─────────────────────────────┘  │
│                                     │
│    ┌─────────────────────────────┐  │
│    │ Confirm Password      [👁]  │  │
│    └─────────────────────────────┘  │
│                                     │
│ ☐ I agree to the Terms of Service   │
│   and Privacy Policy                │
│                                     │
│    ┌─────────────────────────────┐  │
│    │     Create Account          │  │
│    └─────────────────────────────┘  │
│                                     │
│  Already have an account? Sign In   │
│                                     │
└─────────────────────────────────────┘
```

## 2. Dashboard (Mobile)

```
┌─────────────────────────────────────┐
│ Dashboard                        ≡  │
├─────────────────────────────────────┤
│                                     │
│         Dashboard                   │
│   Welcome back to your trading      │
│           journal                   │
│                                     │
│ ┌─────────────┐ ┌─────────────────┐ │
│ │ Total P&L   │ │ Win Rate        │ │
│ │ +$2,450.50  │ │ 68.5%           │ │
│ │ +12.5% ↗    │ │ +2.1% ↗         │ │
│ └─────────────┘ └─────────────────┘ │
│                                     │
│ ┌─────────────┐ ┌─────────────────┐ │
│ │ Total Trades│ │ Active Positions│ │
│ │ 127         │ │ 5               │ │
│ │ +8 ↗        │ │ -2 ↘            │ │
│ └─────────────┘ └─────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │         Quick Actions           │ │
│ │                                 │ │
│ │ ➕ Add Trade    📊 View Journal │ │
│ │ Record new      Browse all      │ │
│ │ trade           trades          │ │
│ │                                 │ │
│ │ 📈 Live Trading 📊 Analytics    │ │
│ │ Open trading    View            │ │
│ │ interface       performance     │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Recent Trades        View All → │ │
│ │                                 │ │
│ │        📊 No recent trades      │ │
│ │                                 │ │
│ │    Add Your First Trade         │ │
│ └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
│ 🏠 📈 📖 🏦 📊                     │
└─────────────────────────────────────┘
```

## 3. Dashboard (Desktop)

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│ ┌─────────────────┐                                                                     │
│ │ [📈] VTrader    │                    Dashboard                                  🌙 👤 │
│ │                 │                                                                     │
│ │ 🏠 Dashboard    │ Welcome back to your trading journal                               │
│ │ 📈 Trade        │                                                                     │
│ │ 📖 Journal      │ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ │
│ │ 🏦 Brokers      │ │ Total P&L   │ │ Win Rate    │ │ Total Trades│ │ Active Pos. │ │
│ │ 📊 Analytics    │ │ +$2,450.50  │ │ 68.5%       │ │ 127         │ │ 5           │ │
│ │ ⚙️ Settings     │ │ +12.5% ↗    │ │ +2.1% ↗     │ │ +8 ↗        │ │ -2 ↘        │ │
│ │                 │ └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘ │
│ │                 │                                                                     │
│ │                 │ ┌─────────────────────────────────────────────────────────────┐   │
│ │                 │ │                    Quick Actions                            │   │
│ │                 │ │                                                             │   │
│ │                 │ │ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────┐ │   │
│ │                 │ │ │ ➕          │ │ 📖          │ │ 📈          │ │ 📊      │ │   │
│ │                 │ │ │ Add Trade   │ │ View Journal│ │ Live Trading│ │Analytics│ │   │
│ │                 │ │ │ Record new  │ │ Browse all  │ │ Open trading│ │ View    │ │   │
│ │                 │ │ │ trade       │ │ trades      │ │ interface   │ │ perform.│ │   │
│ │                 │ │ └─────────────┘ └─────────────┘ └─────────────┘ └─────────┘ │   │
│ │                 │ └─────────────────────────────────────────────────────────────┘   │
│ │                 │                                                                     │
│ │ ────────────────│ ┌──────────────────────────────┐ ┌─────────────────────────────┐ │
│ │ 🌙 Theme Toggle │ │ Recent Trades    View All → │ │ Portfolio Overview          │ │
│ │                 │ │                              │ │                             │ │
│ │ 👤 Demo User    │ │      📊 No recent trades     │ │    ┌─────────────────────┐  │ │
│ │ View profile    │ │                              │ │    │                     │  │ │
│ └─────────────────┘ │   Add Your First Trade       │ │    │   📈 Chart Area     │  │ │
│                     │                              │ │    │   Coming Soon       │  │ │
│                     └──────────────────────────────┘ │    │                     │  │ │
│                                                       │    └─────────────────────┘  │ │
│                                                       └─────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

## 4. Trade Journal Page

```
┌─────────────────────────────────────┐
│ ← Trade Journal               🔍 ➕  │
├─────────────────────────────────────┤
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 🔍 Search trades...             │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Filters: All ▼ | Strategy ▼ | P&L ▼│
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ NIFTY50 • Long • Closed         │ │
│ │ Entry: ₹19,250.50 → ₹19,380.75  │ │
│ │ P&L: +₹13,025 (+2.71%) 📈       │ │
│ │ Jan 15 • Momentum Trading       │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ BANKNIFTY • Short • Closed      │ │
│ │ Entry: ₹45,200.25 → ₹44,950.75  │ │
│ │ P&L: +₹12,475 (+1.38%) 📈       │ │
│ │ Jan 16 • Mean Reversion         │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ RELIANCE • Long • Open          │ │
│ │ Entry: ₹2,450.80 • Current: ?   │ │
│ │ P&L: Unrealized                 │ │
│ │ Jan 17 • Breakout Trading       │ │
│ └─────────────────────────────────┘ │
│                                     │
│               Load More...          │
│                                     │
└─────────────────────────────────────┘
```

## 5. Trade Page (Complex Layout)

### Desktop Layout
```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│ Trade Interface                                                               NIFTY50 ▼ │
├─────────────────────────────────────────────────┬───────────────────────────────────────┤
│                                                 │ ┌─────────────────────────────────┐   │
│                                                 │ │ Trade Controls                  │   │
│                                                 │ │                                 │   │
│                CHART AREA                       │ │ Symbol: NIFTY50 ▼              │   │
│                                                 │ │ Qty: [100] Price: [Market ▼]   │   │
│              ┌─────────────────┐                │ │                                 │   │
│              │                 │                │ │ ┌─────────┐ ┌─────────────────┐ │   │
│              │   Candlestick   │                │ │ │ BUY     │ │ SELL            │ │   │
│              │     Chart       │                │ │ └─────────┘ └─────────────────┘ │   │
│              │                 │                │ │                                 │   │
│              │   📈 Real-time  │                │ │ Stop Loss: [19100]             │   │
│              │     Updates     │                │ │ Take Profit: [19400]           │   │
│              │                 │                │ │                                 │   │
│              └─────────────────┘                │ │ Strategy: [Momentum ▼]         │   │
│                                                 │ │ Notes: [Optional...]           │   │
│                                                 │ └─────────────────────────────────┘   │
│                                                 ├───────────────────────────────────────┤
│                                                 │ ┌─────────────────────────────────┐   │
│                                                 │ │ Positions & Orders              │   │
│                                                 │ │                                 │   │
│                                                 │ │ Open Positions:                 │   │
│                                                 │ │ • RELIANCE +25 @ ₹2,450.80     │   │
│                                                 │ │   P&L: +₹1,250 (+2.04%)        │   │
│                                                 │ │                                 │   │
│                                                 │ │ Pending Orders:                 │   │
│                                                 │ │ • HDFC SELL 20 @ ₹1,580.25     │   │
│                                                 │ │   Type: Stop Loss               │   │
│                                                 │ │                                 │   │
│                                                 │ │ Recent Trades:                  │   │
│                                                 │ │ • NIFTY50 +₹13,025 (Closed)    │   │
│                                                 │ │ • BANKNIFTY +₹12,475 (Closed)  │   │
│                                                 │ └─────────────────────────────────┘   │
└─────────────────────────────────────────────────┴───────────────────────────────────────┘
```

### Mobile Layout
```
┌─────────────────────────────────────┐
│ ← Trade                    NIFTY50 ▼│
├─────────────────────────────────────┤
│                                     │
│        ┌─────────────────────┐      │
│        │                     │      │
│        │   Candlestick       │      │
│        │     Chart           │      │
│        │                     │      │
│        │   📈 Real-time      │      │
│        │     Updates         │      │
│        │                     │      │
│        └─────────────────────┘      │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Trade Controls                  │ │
│ │                                 │ │
│ │ Qty: [100]  Price: [Market ▼]  │ │
│ │                                 │ │
│ │ ┌─────────┐ ┌─────────────────┐ │ │
│ │ │ BUY     │ │ SELL            │ │ │
│ │ └─────────┘ └─────────────────┘ │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Positions    Orders    History  │ │
│ ├─────────────────────────────────┤ │
│ │ RELIANCE +25 @ ₹2,450.80        │ │
│ │ P&L: +₹1,250 (+2.04%) 📈        │ │
│ │                                 │ │
│ │ HDFC Pending SELL 20            │ │
│ │ @ ₹1,580.25 (Stop Loss)         │ │
│ └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

## 6. Broker Management Page

```
┌─────────────────────────────────────┐
│ ← Brokers                        ➕  │
├─────────────────────────────────────┤
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 🟢 Zerodha (ZD1234)             │ │
│ │ Connected • Last sync: 2m ago   │ │
│ │                                 │ │
│ │ Auto-sync: ON • Every 15 min    │ │
│ │ Syncing: Orders, Positions,     │ │
│ │          Trades                 │ │
│ │                                 │ │
│ │ [Sync Now] [Settings] [Edit]    │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 🔴 Upstox (UP5678)              │ │
│ │ Disconnected • Last sync: 2d ago│ │
│ │                                 │ │
│ │ Auto-sync: OFF                  │ │
│ │ Syncing: Orders, Positions,     │ │
│ │          Holdings, Trades       │ │
│ │                                 │ │
│ │ [Connect] [Settings] [Edit]     │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 🟢 Angel One (AO9012)           │ │
│ │ Connected • Last sync: 5m ago   │ │
│ │                                 │ │
│ │ Auto-sync: ON • Every 10 min    │ │
│ │ Syncing: Orders, Positions,     │ │
│ │          Trades                 │ │
│ │                                 │ │
│ │ [Sync Now] [Settings] [Edit]    │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ➕ Add New Broker                │ │
│ │                                 │ │
│ │ Connect your trading account    │ │
│ │ for automatic trade sync        │ │
│ └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

## 7. Add/Edit Trade Page

```
┌─────────────────────────────────────┐
│ ← Add Trade                      ✓  │
├─────────────────────────────────────┤
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Symbol *                        │ │
│ │ NIFTY50                      ▼  │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Trade Type: ◉ Long  ○ Short         │
│                                     │
│ ┌─────────────┐ ┌─────────────────┐ │
│ │ Quantity *  │ │ Entry Price *   │ │
│ │ 100         │ │ 19250.50        │ │
│ └─────────────┘ └─────────────────┘ │
│                                     │
│ ┌─────────────┐ ┌─────────────────┐ │
│ │ Stop Loss   │ │ Take Profit     │ │
│ │ 19100.00    │ │ 19400.00        │ │
│ └─────────────┘ └─────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Entry Date & Time               │ │
│ │ Jan 15, 2024 09:30 AM        📅 │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Strategy                        │ │
│ │ Momentum Trading             ▼  │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Tags (comma separated)          │ │
│ │ intraday, trending, bullish     │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ Notes                           │ │
│ │ Strong momentum after gap up... │ │
│ │                                 │ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │           Save Trade            │ │
│ └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

## Design Principles

### 1. Mobile-First Approach
- Start with mobile design constraints
- Scale up for larger screens
- Touch-friendly interface elements

### 2. Information Hierarchy
- Clear visual hierarchy with typography
- Important actions prominently displayed
- Secondary information appropriately de-emphasized

### 3. Consistent Navigation
- Familiar navigation patterns per platform
- Clear back navigation and breadcrumbs
- Consistent placement of actions

### 4. Data Visualization
- Charts and graphs for trading data
- Color coding for profit/loss
- Real-time updates where applicable

### 5. Accessibility
- High contrast ratios
- Proper touch target sizes (44px minimum)
- Screen reader support
- Keyboard navigation support

These wireframes serve as a foundation for the UI implementation and can be refined based on user feedback and usability testing.

