# Recipe Book App

A comprehensive Flutter application that helps users discover and learn cooking recipes from around the world. Built with clean architecture, BLoC state management, and beautiful UI with animations.

## Features

### 🏠 Home Page
- **Featured Carousel**: 6 random meals displayed in an auto-playing carousel
- **Categories Section**: Browse all meal categories in a unique 3-row synchronized horizontal scroll
- **Today's Choice**: A special random meal recommendation for the day
- **Cuisine Grid**: Explore meals by country/region in a beautiful grid layout

### 🔍 Search Screen
- **Smart Search**: Type 3+ characters to search for recipes
- **Debounced API Calls**: Optimized search with 500ms debounce
- **Responsive Grid**: Adaptive layout for mobile, tablet, and desktop
- **Search by**: Name, category, ingredient, or cuisine

### 📖 Cooking Details Screen
- **Full Recipe Information**: Meal name, category, area, and image
- **Ingredients List**: Clickable ingredients that navigate to filtered meals
- **Step-by-Step Instructions**: Numbered cooking instructions
- **Video Tutorial**: YouTube link integration (when available)
- **Hero Animation**: Smooth image transitions

### 📋 Category Items Screen
- **Filter Options**: Browse meals by category, ingredient, or cuisine
- **Responsive Grid**: Adaptive layout based on screen size
- **Pull to Refresh**: Easy data refresh

## Architecture

The app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/
│   ├── constants/      # API endpoints and app constants
│   ├── di/            # Dependency injection setup
│   ├── error/         # Error handling and failures
│   ├── theme/         # App theming (light & dark mode)
│   └── utils/         # Utility classes (Either, Responsive)
├── data/
│   ├── datasources/   # Remote data sources (API calls)
│   ├── models/        # Data models
│   └── repositories/  # Repository implementations
├── domain/
│   └── repositories/  # Repository interfaces
└── presentation/
    ├── blocs/         # BLoC state management
    ├── pages/         # UI screens
    └── widgets/       # Reusable widgets
```

### Key Design Patterns

1. **BLoC Pattern**: State management using flutter_bloc
2. **Repository Pattern**: Abstract data layer
3. **Dependency Injection**: GetIt for service location
4. **Either Type**: Functional error handling
5. **Responsive Design**: Adaptive UI for all screen sizes

## State Management

Using **BLoC (Business Logic Component)** pattern with the following blocs:

- `HomeBloc`: Manages home page state (random meals, categories, cuisines)
- `SearchBloc`: Handles search functionality with debouncing
- `MealDetailBloc`: Manages meal details fetching
- `CategoryMealsBloc`: Handles filtered meal lists

## UI/UX Features

### 🎨 Theming
- Light and Dark mode support
- Custom color schemes
- Material 3 design
- Consistent typography

### ✨ Animations
- Fade-in animations for content
- Slide-in animations for sections
- Scale-in animations for grid items
- Hero transitions between screens
- Carousel auto-play with smooth transitions

### 📱 Responsive Design
- **Mobile**: 2 columns grid
- **Tablet**: 3 columns grid
- **Desktop**: 4 columns grid
- Adaptive carousel viewport
- Platform-aware UI components

## API Integration

Using [TheMealDB API](https://www.themealdb.com/api.php):

- `GET /random.php` - Get random meals
- `GET /categories.php` - Get all categories
- `GET /lookup.php?i={id}` - Get meal by ID
- `GET /filter.php?c={category}` - Filter by category
- `GET /filter.php?i={ingredient}` - Filter by ingredient
- `GET /filter.php?a={area}` - Filter by area
- `GET /search.php?s={name}` - Search by name
- `GET /list.php?a=list` - List all areas

## Dependencies

### State Management & DI
- `flutter_bloc: ^8.1.3` - BLoC state management
- `equatable: ^2.0.5` - Value equality
- `get_it: ^7.6.4` - Dependency injection

### Network
- `http: ^1.1.0` - HTTP client
- `dio: ^5.4.0` - Advanced HTTP client

### UI Components
- `carousel_slider: ^4.2.1` - Carousel widget
- `cached_network_image: ^3.3.0` - Image caching
- `shimmer: ^3.0.0` - Loading shimmer effect
- `flutter_staggered_grid_view: ^0.7.0` - Advanced grid layouts

## Getting Started

### Prerequisites
- Flutter SDK (3.7.0 or higher)
- Dart SDK (^3.7.0)
- Android Studio / Xcode for native builds

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd flutter_demo_hopscotch
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Build for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## Project Structure Details

### Data Layer
- **Models**: Plain data classes with JSON serialization
- **DataSources**: API communication logic
- **Repositories**: Implementation of domain contracts

### Domain Layer
- **Repositories**: Abstract interfaces for data operations
- **Use Cases**: (Can be added for complex business logic)

### Presentation Layer
- **BLoCs**: Business logic and state management
- **Pages**: Full screen widgets
- **Widgets**: Reusable UI components

## Common Widgets

### Reusable Components
- `MealCard`: Displays meal with image and overlay
- `CategoryCard`: Shows category with circular image
- `CustomButton`: Themed buttons with loading states
- `SectionTitle`: Consistent section headers
- `LoadingShimmer`: Skeleton loading effect
- `EmptyState`: Empty state messaging
- `ErrorView`: Error handling UI

### Animations
- `FadeInAnimation`: Smooth fade-in effect
- `SlideInAnimation`: Slide from offset
- `ScaleInAnimation`: Scale up with elastic curve

## Code Quality

### Best Practices
- Clean Architecture separation
- SOLID principles
- Proper error handling with Either type
- Null safety enabled
- Type-safe code
- Proper documentation

### Testing
- Unit tests for BLoCs
- Widget tests for UI components
- Integration tests for workflows

## Performance Optimizations

- Image caching for better performance
- Debounced search to reduce API calls
- Lazy loading with pagination support
- Optimized build methods
- Const constructors where possible
- Efficient state management

## Future Enhancements

- [ ] Add favorites functionality
- [ ] Implement local storage/caching
- [ ] Add meal planning feature
- [ ] Shopping list generation
- [ ] Social sharing
- [ ] User authentication
- [ ] Recipe ratings and reviews
- [ ] Offline mode support
- [ ] Multi-language support
- [ ] Voice search

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

## Acknowledgments

- [TheMealDB](https://www.themealdb.com/) for providing the free recipe API
- Flutter team for the amazing framework
- All open-source package contributors

---

**Built with ❤️ using Flutter**
