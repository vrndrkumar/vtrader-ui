# VTrader Architecture Documentation

## Overview

VTrader is built using Clean Architecture principles with Flutter, providing a scalable and maintainable codebase that supports web, Android, and iOS platforms from a single codebase.

## Architecture Layers

### 1. Presentation Layer (`lib/features/*/presentation/`)
- **Responsibility**: UI components, user interactions, and presentation logic
- **Components**:
  - **Pages**: Full-screen widgets representing app screens
  - **Widgets**: Reusable UI components specific to features
  - **Providers**: Riverpod providers for UI state management

### 2. Domain Layer (`lib/features/*/domain/`)
- **Responsibility**: Business logic, use cases, and domain entities
- **Components**:
  - **Entities**: Core business objects
  - **Use Cases**: Application-specific business rules
  - **Repositories**: Abstract interfaces for data access

### 3. Data Layer (`lib/features/*/data/`)
- **Responsibility**: Data access, external APIs, and local storage
- **Components**:
  - **Repositories**: Concrete implementations of domain repositories
  - **Data Sources**: Remote (API) and local (database) data sources
  - **Models**: Data transfer objects and serialization

### 4. Shared Layer (`lib/shared/`)
- **Responsibility**: Common functionality used across features
- **Components**:
  - **Models**: Shared data models
  - **Services**: Cross-cutting concerns (auth, storage, networking)
  - **Widgets**: Reusable UI components
  - **Utilities**: Helper functions and extensions

### 5. Core Layer (`lib/core/`)
- **Responsibility**: App-wide configuration and foundation
- **Components**:
  - **Theme**: Design system and styling
  - **Router**: Navigation configuration
  - **Constants**: App-wide constants
  - **Utils**: Core utilities and extensions

## State Management

### Riverpod Architecture

VTrader uses Riverpod for state management, providing:
- **Dependency Injection**: Clean separation of concerns
- **Reactive Programming**: Automatic UI updates when state changes
- **Testing Support**: Easy mocking and testing of providers

#### Provider Types Used

1. **Provider**: Immutable values and computed values
2. **StateProvider**: Simple mutable state
3. **StateNotifierProvider**: Complex state with business logic
4. **FutureProvider**: Async operations and data loading
5. **StreamProvider**: Real-time data streams

#### Example Provider Structure

```dart
// State class
class TradesState {
  final List<TradeModel> trades;
  final bool isLoading;
  final String? error;
  
  const TradesState({
    this.trades = const [],
    this.isLoading = false,
    this.error,
  });
}

// State notifier
class TradesNotifier extends StateNotifier<TradesState> {
  TradesNotifier(this._repository) : super(const TradesState());
  
  final TradeRepository _repository;
  
  Future<void> loadTrades() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final trades = await _repository.getAllTrades();
      state = state.copyWith(trades: trades, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

// Provider
final tradesProvider = StateNotifierProvider<TradesNotifier, TradesState>((ref) {
  final repository = ref.watch(tradeRepositoryProvider);
  return TradesNotifier(repository);
});
```

## Data Flow

### 1. User Interaction Flow
```
User Action → Widget → Provider → Use Case → Repository → Data Source
```

### 2. Data Update Flow
```
Data Source → Repository → Provider → Widget → UI Update
```

### 3. Error Handling Flow
```
Error → Repository → Provider → Widget → Error Display
```

## Feature Structure

Each feature follows a consistent structure:

```
features/
├── feature_name/
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── local/
│   │   │   └── remote/
│   │   ├── models/
│   │   └── repositories/
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   └── presentation/
│       ├── pages/
│       ├── widgets/
│       └── providers/
```

## Navigation Architecture

### Router Configuration

VTrader uses GoRouter for declarative routing:

```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      // Authentication routes
      GoRoute(path: '/auth/sign-in', builder: (context, state) => SignInPage()),
      
      // Main app shell
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(path: '/dashboard', builder: (context, state) => DashboardPage()),
          // ... other routes
        ],
      ),
    ],
  );
});
```

### Navigation Patterns

1. **Declarative Routes**: All routes defined in a single place
2. **Type-safe Navigation**: Helper methods for navigation
3. **Deep Linking**: Support for web URLs and mobile deep links
4. **Authentication Guards**: Automatic redirects based on auth state

## Responsive Design

### Breakpoint Strategy

```dart
// Breakpoints
- Mobile: ≤450px
- Tablet: 451-800px
- Desktop: ≥801px
```

### Layout Adaptation

1. **Mobile**: Bottom navigation, single column layout
2. **Tablet**: Navigation rail, adaptive two-column layout
3. **Desktop**: Persistent sidebar, multi-column layout

### Responsive Widgets

```dart
Widget build(BuildContext context) {
  return ResponsiveBreakpoints.of(context).isMobile
      ? MobileLayout()
      : ResponsiveBreakpoints.of(context).isTablet
          ? TabletLayout()
          : DesktopLayout();
}
```

## Data Persistence

### Storage Strategy

1. **Hive**: Primary local database for structured data
2. **SharedPreferences**: Simple key-value storage for preferences
3. **Secure Storage**: Sensitive data like tokens

### Data Models

All data models implement:
- **JSON Serialization**: For API communication
- **Hive Serialization**: For local storage
- **Equality**: For state comparison
- **Immutability**: For predictable state updates

```dart
@JsonSerializable()
@HiveType(typeId: 0)
class TradeModel extends Equatable {
  @HiveField(0)
  final String id;
  
  // ... other fields
  
  factory TradeModel.fromJson(Map<String, dynamic> json) =>
      _$TradeModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$TradeModelToJson(this);
  
  @override
  List<Object?> get props => [id, /* ... other fields */];
}
```

## Testing Strategy

### Test Pyramid

1. **Unit Tests**: Business logic, models, utilities
2. **Widget Tests**: UI components and interactions
3. **Integration Tests**: End-to-end user flows

### Testing Architecture

```dart
// Unit test example
void main() {
  group('TradeModel', () {
    test('should calculate P&L correctly', () {
      final trade = TradeModel(/* ... */);
      expect(trade.pnl, equals(expectedPnl));
    });
  });
}

// Widget test example
void main() {
  testWidgets('SignInPage should show error for invalid credentials', (tester) async {
    await tester.pumpWidget(createApp(SignInPage()));
    
    await tester.enterText(find.byType(AppInput), 'invalid@email.com');
    await tester.tap(find.byType(AppButton));
    await tester.pump();
    
    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}
```

### Mocking Strategy

- **Mockito**: For mocking dependencies in unit tests
- **Provider Overrides**: For mocking providers in widget tests
- **Test Doubles**: For integration test scenarios

## Performance Considerations

### Optimization Strategies

1. **Lazy Loading**: Load data and widgets on demand
2. **State Optimization**: Minimize unnecessary rebuilds
3. **Image Caching**: Efficient image loading and caching
4. **Bundle Splitting**: Code splitting for web builds

### Memory Management

1. **Provider Disposal**: Automatic cleanup of providers
2. **Stream Subscriptions**: Proper subscription management
3. **Animation Controllers**: Dispose controllers properly
4. **Large Lists**: Use ListView.builder for large datasets

## Security Considerations

### Authentication

1. **Token Storage**: Secure storage for authentication tokens
2. **Session Management**: Automatic token refresh
3. **Logout Handling**: Secure cleanup on logout

### Data Protection

1. **Input Validation**: Validate all user inputs
2. **SQL Injection Prevention**: Use parameterized queries
3. **XSS Prevention**: Sanitize data for web display
4. **Sensitive Data**: Encrypt sensitive information

## Deployment Architecture

### Build Configurations

1. **Development**: Local development with mock data
2. **Staging**: Testing environment with staging APIs
3. **Production**: Live environment with production APIs

### Platform-Specific Builds

```dart
// Web
flutter build web --release --web-renderer canvaskit

// Android
flutter build apk --release
flutter build appbundle --release

// iOS
flutter build ios --release
```

## Monitoring and Analytics

### Error Tracking

1. **Crash Reporting**: Automatic crash reporting
2. **Error Boundaries**: Graceful error handling
3. **Logging**: Structured logging for debugging

### Performance Monitoring

1. **App Performance**: Monitor app startup and navigation
2. **Network Performance**: Track API response times
3. **User Analytics**: Track user behavior and engagement

## Future Considerations

### Scalability

1. **Microservices**: Prepare for microservice architecture
2. **Caching Strategy**: Implement advanced caching
3. **Offline Support**: Enhanced offline capabilities
4. **Real-time Updates**: WebSocket integration

### Maintenance

1. **Code Generation**: Automate repetitive code
2. **Documentation**: Keep architecture docs updated
3. **Dependencies**: Regular dependency updates
4. **Refactoring**: Continuous code improvement

This architecture provides a solid foundation for VTrader's current needs while remaining flexible for future enhancements and scaling requirements.

