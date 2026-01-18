# Architecture Documentation

## Overview

This Recipe Book app is built using **Clean Architecture** principles, ensuring maintainability, testability, and scalability. The codebase is organized into distinct layers, each with specific responsibilities.

## Layer Structure

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI, BLoCs, Widgets, Pages)           │
└─────────────┬───────────────────────────┘
              │
              │ Uses
              ▼
┌─────────────────────────────────────────┐
│          Domain Layer                   │
│  (Repository Interfaces, Entities)      │
└─────────────┬───────────────────────────┘
              │
              │ Implements
              ▼
┌─────────────────────────────────────────┐
│           Data Layer                    │
│  (Repositories, DataSources, Models)    │
└─────────────────────────────────────────┘
```

## Detailed Layer Breakdown

### 1. Presentation Layer (`lib/presentation/`)

**Responsibility**: User interface and user interaction

#### Components:

**A. Pages** (`pages/`)
- Full-screen widgets representing app screens
- Minimal business logic
- Delegates state management to BLoCs

Files:
- `home/home_page.dart` - Main landing page
- `search/search_page.dart` - Recipe search interface
- `meal_detail/meal_detail_page.dart` - Recipe details view
- `category_meals/category_meals_page.dart` - Filtered meals list

**B. BLoCs** (`blocs/`)
- Business Logic Components
- Manages app state
- Handles events and emits states
- Pure Dart logic (UI independent)

Structure per BLoC:
```
bloc_name/
├── bloc_name_bloc.dart   # Main logic
├── bloc_name_event.dart  # Input events
└── bloc_name_state.dart  # Output states
```

BLoCs:
1. **HomeBloc**: Manages home page data (random meals, categories, cuisines)
2. **SearchBloc**: Handles search with debouncing
3. **MealDetailBloc**: Fetches and manages meal details
4. **CategoryMealsBloc**: Manages filtered meal lists

**C. Widgets** (`widgets/`)
- Reusable UI components
- Stateless when possible
- Accepts data via constructor

Common Widgets:
- `meal_card.dart` - Displays meal with image overlay
- `category_card.dart` - Shows category thumbnail
- `custom_button.dart` - Themed button component
- `section_title.dart` - Consistent section headers
- `loading_shimmer.dart` - Loading skeleton
- `empty_state.dart` - Empty results UI
- `error_view.dart` - Error handling UI
- `animations.dart` - Reusable animations

### 2. Domain Layer (`lib/domain/`)

**Responsibility**: Business rules and core logic

#### Components:

**A. Repository Interfaces** (`repositories/`)
- Abstract contracts for data operations
- Independent of implementation details
- Pure Dart (no Flutter dependencies)

Example:
```dart
abstract class MealRepository {
  Future<Either<Failure, List<MealModel>>> getRandomMeals({int count});
  Future<Either<Failure, MealModel>> getMealById(String id);
  // ... more methods
}
```

**Key Principles:**
- Return types use `Either<Failure, Success>` for error handling
- Async operations return Futures
- No implementation details leak

### 3. Data Layer (`lib/data/`)

**Responsibility**: Data management and external communication

#### Components:

**A. Models** (`models/`)
- Data transfer objects (DTOs)
- JSON serialization/deserialization
- Equatable for value comparison

Files:
- `meal_model.dart` - Complete meal data
- `category_model.dart` - Category information
- `area_model.dart` - Cuisine/region data

Example:
```dart
class MealModel extends Equatable {
  final String id;
  final String name;
  // ... fields
  
  factory MealModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

**B. DataSources** (`datasources/`)
- Raw data fetching logic
- API communication
- Local storage operations

File:
- `meal_remote_datasource.dart` - HTTP API calls

Pattern:
```dart
abstract class MealRemoteDataSource {
  Future<List<MealModel>> getRandomMeals({int count});
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final http.Client client;
  // Implementation
}
```

**C. Repository Implementations** (`repositories/`)
- Concrete implementation of domain interfaces
- Orchestrates data sources
- Handles error mapping

File:
- `meal_repository_impl.dart`

Pattern:
```dart
class MealRepositoryImpl implements MealRepository {
  final MealRemoteDataSource remoteDataSource;
  
  @override
  Future<Either<Failure, List<MealModel>>> getRandomMeals({int count}) async {
    try {
      final meals = await remoteDataSource.getRandomMeals(count: count);
      return Either.right(meals);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
```

### 4. Core Layer (`lib/core/`)

**Responsibility**: Shared utilities and configurations

#### Components:

**A. Constants** (`constants/`)
- API endpoints
- App-wide constants
- Configuration values

File:
- `api_constants.dart` - TheMealDB API URLs

**B. Theme** (`theme/`)
- Color schemes
- Text styles
- Component themes

Files:
- `app_colors.dart` - Color palette
- `app_theme.dart` - Light & dark themes

**C. Error Handling** (`error/`)
- Failure types
- Error hierarchies

File:
- `failures.dart` - Failure classes

Types:
```dart
abstract class Failure extends Equatable {
  final String message;
}

class ServerFailure extends Failure {}
class NetworkFailure extends Failure {}
class CacheFailure extends Failure {}
```

**D. Utilities** (`utils/`)
- Helper classes
- Extensions
- Shared logic

Files:
- `either.dart` - Functional error handling
- `responsive_layout.dart` - Screen size utilities

**E. Dependency Injection** (`di/`)
- Service locator setup
- Dependency registration

File:
- `injection_container.dart` - GetIt configuration

Pattern:
```dart
final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(() => HomeBloc(repository: sl()));
  
  // Repositories
  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(remoteDataSource: sl()),
  );
  
  // DataSources
  sl.registerLazySingleton<MealRemoteDataSource>(
    () => MealRemoteDataSourceImpl(client: sl()),
  );
  
  // External
  sl.registerLazySingleton(() => http.Client());
}
```

## Design Patterns Used

### 1. BLoC Pattern (Business Logic Component)

**Purpose**: Separate UI from business logic

**Flow**:
```
User Input → Event → BLoC → State → UI Update
```

**Example**:
```dart
// Event
class SearchMeals extends SearchEvent {
  final String query;
}

// BLoC
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  on<SearchMeals>(_onSearchMeals);
  
  Future<void> _onSearchMeals(SearchMeals event, emit) async {
    emit(SearchLoading());
    final result = await repository.searchByName(event.query);
    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (meals) => emit(SearchLoaded(meals)),
    );
  }
}

// State
abstract class SearchState {}
class SearchLoading extends SearchState {}
class SearchLoaded extends SearchState {
  final List<MealModel> meals;
}
```

### 2. Repository Pattern

**Purpose**: Abstract data layer

**Benefits**:
- Swap data sources easily
- Test without real API
- Consistent error handling

**Example**:
```dart
// Domain interface
abstract class MealRepository {
  Future<Either<Failure, List<MealModel>>> getRandomMeals();
}

// Data implementation
class MealRepositoryImpl implements MealRepository {
  final MealRemoteDataSource remoteDataSource;
  // Implementation
}
```

### 3. Dependency Injection

**Purpose**: Loose coupling and testability

**Pattern**: Service Locator (GetIt)

**Usage**:
```dart
// Registration in main()
await di.init();

// Usage in widget
BlocProvider(
  create: (context) => HomeBloc(
    repository: di.sl<MealRepository>(),
  ),
)
```

### 4. Either Pattern

**Purpose**: Functional error handling

**Benefits**:
- Type-safe errors
- Force error handling
- No try-catch needed

**Example**:
```dart
final result = await repository.getMealById(id);

result.fold(
  (failure) => showError(failure.message),  // Left = error
  (meal) => displayMeal(meal),              // Right = success
);
```

## State Management Flow

### Home Page Example

```
1. User opens app
   ↓
2. HomePage created
   ↓
3. HomeBloc initialized (via DI)
   ↓
4. LoadHomeData event dispatched
   ↓
5. HomeBloc emits HomeLoading
   ↓
6. UI shows shimmer loading
   ↓
7. BLoC calls repository
   ↓
8. Repository calls datasource
   ↓
9. DataSource makes HTTP requests
   ↓
10. Data returned through layers
    ↓
11. BLoC emits HomeLoaded with data
    ↓
12. UI rebuilds with actual content
```

## Data Flow

### Search Example

```
┌──────────┐    Event      ┌────────────┐
│   User   │──────────────→│ SearchBloc │
│  Types   │               └──────┬─────┘
└──────────┘                      │
                                  │ State
                                  │ (Loading)
                                  ▼
                           ┌─────────────┐
                           │  SearchPage │
                           │  (Shows     │
                           │  shimmer)   │
                           └─────────────┘
                                  ▲
                                  │ State
                                  │ (Loaded)
                           ┌──────┴─────┐
                           │ SearchBloc │
                           └──────┬─────┘
                                  │ Calls
                                  ▼
                           ┌─────────────────┐
                           │ MealRepository  │
                           └──────┬──────────┘
                                  │ Delegates to
                                  ▼
                           ┌─────────────────┐
                           │ RemoteDataSource│
                           └──────┬──────────┘
                                  │ HTTP GET
                                  ▼
                           ┌─────────────────┐
                           │  TheMealDB API  │
                           └─────────────────┘
```

## Responsive Design Strategy

### Breakpoints:
- **Mobile**: < 650px → 2 columns
- **Tablet**: 650-1099px → 3 columns
- **Desktop**: ≥ 1100px → 4 columns

### Implementation:
```dart
class ResponsiveLayout {
  static int getCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }
}

// Usage
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: ResponsiveLayout.getCrossAxisCount(context),
  ),
)
```

## Testing Strategy

### Unit Tests (BLoCs)
```dart
test('emits [Loading, Loaded] when search succeeds', () {
  when(() => repository.searchByName(any()))
      .thenAnswer((_) async => Either.right(meals));
      
  expect(
    bloc.stream,
    emitsInOrder([SearchLoading(), SearchLoaded(meals)]),
  );
  
  bloc.add(SearchMeals('chicken'));
});
```

### Widget Tests (UI)
```dart
testWidgets('displays meals when loaded', (tester) async {
  await tester.pumpWidget(makeTestableWidget(
    BlocProvider(
      create: (_) => mockBloc,
      child: HomePage(),
    ),
  ));
  
  expect(find.byType(MealCard), findsWidgets);
});
```

### Integration Tests (E2E)
```dart
testWidgets('full search flow', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.byIcon(Icons.search));
  await tester.enterText(find.byType(TextField), 'pasta');
  await tester.pumpAndSettle();
  expect(find.byType(MealCard), findsWidgets);
});
```

## Error Handling Strategy

### Levels:

1. **Data Layer**: Catch exceptions, return Failure
2. **Domain Layer**: Pass Failure through Either
3. **Presentation Layer**: Map Failure to UI state
4. **UI Layer**: Display error to user

### Example:
```dart
// Data Layer
try {
  final response = await client.get(url);
  return MealModel.fromJson(response);
} catch (e) {
  throw ServerException(e.toString());
}

// Repository
try {
  final meal = await dataSource.getMeal(id);
  return Either.right(meal);
} catch (e) {
  return Either.left(ServerFailure(e.toString()));
}

// BLoC
result.fold(
  (failure) => emit(ErrorState(failure.message)),
  (meal) => emit(LoadedState(meal)),
);

// UI
if (state is ErrorState) {
  return ErrorView(message: state.message);
}
```

## Performance Optimizations

### 1. Image Caching
```dart
CachedNetworkImage(
  imageUrl: meal.thumbnail,
  placeholder: (context, url) => Shimmer(...),
)
```

### 2. Debounced Search
```dart
Timer? _debounce;

void _onSearchChanged(String query) {
  _debounce?.cancel();
  _debounce = Timer(Duration(milliseconds: 500), () {
    bloc.add(SearchMeals(query));
  });
}
```

### 3. Const Constructors
```dart
const MealCard({required this.meal});
```

### 4. Lazy Loading
```dart
sl.registerLazySingleton(() => MealRepository());
```

## Best Practices Followed

✅ Single Responsibility Principle
✅ Dependency Inversion
✅ Interface Segregation
✅ Separation of Concerns
✅ DRY (Don't Repeat Yourself)
✅ Immutable State
✅ Pure Functions
✅ Null Safety
✅ Type Safety

## Future Architecture Enhancements

1. **Use Cases Layer**: Add between domain and presentation
2. **Local Storage**: Add local data source
3. **Cache Strategy**: Implement caching policy
4. **Offline Support**: Add offline-first architecture
5. **Testing**: Comprehensive test coverage
6. **CI/CD**: Automated testing and deployment
7. **Analytics**: Add analytics layer
8. **Logging**: Structured logging system

---

**This architecture ensures the app is:**
- ✅ Testable
- ✅ Maintainable
- ✅ Scalable
- ✅ Flexible
- ✅ Clean
