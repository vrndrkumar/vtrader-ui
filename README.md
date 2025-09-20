# VTrader - Trading Journal App

A comprehensive, production-ready Flutter application for managing trading journals across web, Android, and iOS platforms. Built with modern architecture patterns, responsive design, and extensible features.

## 🚀 Features

### Core Features (MVP)
- ✅ **Authentication System** - Sign up, sign in, password reset with service abstraction
- ✅ **Responsive Navigation** - Adaptive navigation for mobile, tablet, and desktop
- ✅ **Dark/Light Themes** - System theme support with manual toggle
- ✅ **Local Storage** - Offline-first data persistence with Hive
- 🔄 **Trade Journal** - Add, edit, delete trades with filtering and grouping
- 🔄 **Trading Interface** - Complex trade page with resizable chart and panels
- 🔄 **Broker Management** - Connect and sync with multiple brokers
- 🔄 **Analytics Dashboard** - Performance metrics and trade analysis

### Technical Features
- ✅ **Modern Architecture** - Clean architecture with Riverpod state management
- ✅ **Design System** - Consistent UI components and design tokens
- ✅ **Type Safety** - Comprehensive data models with JSON serialization
- ✅ **Responsive Design** - Mobile-first design with tablet and desktop support
- 🔄 **Testing** - Unit tests, widget tests, and CI/CD pipeline
- 🔄 **API Integration** - RESTful API client with error handling and retry logic

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/                           # Core functionality
│   ├── constants/                  # App-wide constants
│   ├── theme/                     # Design system (colors, typography, themes)
│   ├── router/                    # Navigation and routing
│   └── widgets/                   # Core reusable widgets
├── features/                      # Feature modules
│   ├── auth/                      # Authentication
│   ├── dashboard/                 # Dashboard and overview
│   ├── trade/                     # Trading and journal features
│   └── broker/                    # Broker management
├── shared/                        # Shared across features
│   ├── models/                    # Data models
│   ├── services/                  # Business logic services
│   ├── repositories/              # Data access layer
│   └── widgets/                   # Reusable UI components
└── main.dart                      # App entry point
```

### Architecture Patterns
- **Clean Architecture** - Separation of concerns with clear boundaries
- **Repository Pattern** - Abstraction layer for data access
- **Provider Pattern** - State management with Riverpod
- **Service Layer** - Business logic abstraction
- **MVVM** - Model-View-ViewModel pattern for UI

## 🛠️ Setup & Installation

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Git

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd vtrader
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   # Web
   flutter run -d chrome
   
   # Android
   flutter run -d android
   
   # iOS (macOS only)
   flutter run -d ios
   ```

### Development Setup

1. **Enable code generation watch mode**
   ```bash
   flutter packages pub run build_runner watch
   ```

2. **Run tests**
   ```bash
   flutter test
   ```

3. **Analyze code**
   ```bash
   flutter analyze
   ```

## 🎨 Design System

### Design Tokens
- **Colors** - Primary, secondary, semantic colors with light/dark variants
- **Typography** - Inter font family with consistent text styles
- **Spacing** - 8px grid system for consistent spacing
- **Breakpoints** - Mobile (≤450px), Tablet (451-800px), Desktop (≥801px)

### Components
- **AppButton** - Consistent button styling with variants
- **AppInput** - Form inputs with validation and accessibility
- **ThemeToggleButton** - System/light/dark theme switcher
- **MainLayout** - Responsive navigation shell

### Responsive Design
- **Mobile** - Bottom navigation with hamburger menu
- **Tablet** - Navigation rail with compact layout
- **Desktop** - Persistent sidebar navigation with full features

## 🔐 Authentication

### Mock Authentication Service
The app includes a mock authentication service for development and testing:

**Demo Credentials:**
- Email: `demo@vtrader.in`
- Password: `password123`

### Service Abstraction
The authentication system is designed with abstraction in mind:
- `AuthService` - Abstract base class
- `MockAuthService` - Development implementation
- Easy to swap with Firebase Auth, REST API, or other providers

### Features
- Sign up with email/password
- Sign in with session persistence
- Password reset flow
- Profile management
- Secure session storage

## 💾 Data Management

### Local Storage
- **Hive** - Primary local database for offline-first architecture
- **SharedPreferences** - User preferences and settings
- **Secure Storage** - Authentication tokens and sensitive data

### Data Models
- **UserModel** - User profile and preferences
- **TradeModel** - Trading transactions with P&L calculations
- **BrokerModel** - Broker connections and sync settings
- **StrategyModel** - Trading strategies with risk management
- **PositionModel** - Current market positions

### Data Flow
1. **UI Layer** - Widgets and pages
2. **State Layer** - Riverpod providers and notifiers
3. **Service Layer** - Business logic and validation
4. **Repository Layer** - Data access abstraction
5. **Storage Layer** - Local database and preferences

## 🔄 State Management

### Riverpod Architecture
- **Providers** - Dependency injection and state management
- **StateNotifiers** - Complex state management with immutable updates
- **FutureProviders** - Async data loading with error handling
- **StreamProviders** - Real-time data updates

### Key Providers
- `themeModeProvider` - Theme state management
- `routerProvider` - Navigation configuration
- `authStateProvider` - Authentication state
- `tradesProvider` - Trade data management

## 📱 Platform Support

### Web
- Responsive design for desktop and mobile browsers
- PWA capabilities (future enhancement)
- URL-based routing with deep linking

### Android
- Material Design 3 components
- Adaptive layouts for phones and tablets
- Android-specific optimizations

### iOS
- Cupertino design elements where appropriate
- iOS-specific navigation patterns
- Safe area handling

## 🧪 Testing Strategy

### Test Types
- **Unit Tests** - Business logic and data models
- **Widget Tests** - UI components and interactions
- **Integration Tests** - End-to-end user flows

### Test Structure
```
test/
├── unit/                          # Unit tests
│   ├── models/                    # Data model tests
│   ├── services/                  # Service layer tests
│   └── utils/                     # Utility function tests
├── widget/                        # Widget tests
│   ├── components/                # Component tests
│   └── pages/                     # Page tests
└── integration/                   # Integration tests
    └── flows/                     # User flow tests
```

### Running Tests
```bash
# All tests
flutter test

# Unit tests only
flutter test test/unit

# Widget tests only
flutter test test/widget

# Integration tests
flutter test integration_test
```

## 🚀 Deployment

### Web Deployment
```bash
# Build for web
flutter build web --release

# Deploy to hosting service
# (Firebase Hosting, Netlify, Vercel, etc.)
```

### Android Deployment
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS Deployment
```bash
# Build for iOS
flutter build ios --release

# Archive and upload via Xcode
```

## 🔧 Configuration

### Environment Variables
Create `.env` file in project root:
```env
API_BASE_URL=https://api.vtrader.in/v1
SENTRY_DSN=your_sentry_dsn
ANALYTICS_KEY=your_analytics_key
```

### Build Flavors
- **Development** - Local development with mock data
- **Staging** - Testing environment with staging APIs
- **Production** - Live environment with production APIs

## 📈 Performance

### Optimization Strategies
- **Lazy Loading** - Load data and widgets on demand
- **Image Caching** - Efficient image loading and caching
- **State Optimization** - Minimal rebuilds with Riverpod
- **Bundle Splitting** - Code splitting for web builds

### Monitoring
- Performance metrics tracking
- Error reporting with Sentry (future)
- Analytics with Firebase Analytics (future)

## 🔮 Future Enhancements

### Phase 2 Features
- [ ] Real-time chart integration
- [ ] Broker API integrations (Zerodha, Upstox, etc.)
- [ ] Advanced analytics and reporting
- [ ] Trade strategy backtesting
- [ ] Social features and community
- [ ] Mobile notifications
- [ ] Export/import functionality
- [ ] Multi-language support

### Technical Improvements
- [ ] Comprehensive test coverage (>90%)
- [ ] CI/CD pipeline with GitHub Actions
- [ ] Performance monitoring
- [ ] Accessibility improvements
- [ ] Offline-first synchronization
- [ ] Real-time data streaming

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make changes with tests
4. Run linting and tests
5. Submit pull request

### Code Standards
- Follow Flutter/Dart style guide
- Write comprehensive tests
- Document public APIs
- Use meaningful commit messages

### Pull Request Template
- Description of changes
- Testing approach
- Screenshots (for UI changes)
- Breaking changes (if any)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

### Documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Material Design 3](https://m3.material.io/)

### Community
- [Flutter Discord](https://discord.gg/flutter)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [GitHub Issues](https://github.com/your-repo/vtrader/issues)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Riverpod for excellent state management
- Material Design team for design system
- Open source community for packages and inspiration

---

**Built with ❤️ using Flutter**
