# Recipe Book App - Quick Start Guide

## 🚀 Running the App

### Option 1: Android Emulator/Device
```bash
flutter run
```

### Option 2: iOS Simulator/Device (Mac only)
```bash
flutter run -d ios
```

### Option 3: Web Browser
```bash
flutter run -d chrome
```

### Option 4: Specific Device
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

## 📱 Features Demo Flow

### 1. Home Page
- App launches to the home page
- Auto-playing carousel shows 6 random recipes
- Scroll down to see categories in 3-row layout
- Scroll horizontally to see all categories (rows move together)
- View "Today's Choice" special meal
- Browse cuisines in a grid at the bottom

### 2. Search Recipes
- Tap search icon in app bar
- Type at least 3 characters
- Results appear automatically
- Tap any recipe to view details

### 3. View Recipe Details
- Tap any meal card from home or search
- See full details: image, category, area
- View ingredients list
- Read step-by-step instructions
- Tap ingredients to see meals with that ingredient

### 4. Browse by Category
- From home page, tap any category
- See all meals in that category
- Tap any meal to view details

### 5. Browse by Cuisine
- From home page, tap any country/region
- See all meals from that cuisine
- Tap any meal to view details

## 🎨 Theme Switching

The app automatically follows your device's theme setting:
- Light mode during day
- Dark mode at night
- Or manually set in device settings

## 🔄 Refresh Data

- Pull down on home page to refresh all data
- Get new random meals and today's choice

## ⚡ Performance Tips

1. **First Launch**: May take a few seconds to load all data
2. **Images**: Cached automatically for faster subsequent loads
3. **Search**: Waits 500ms after typing to reduce API calls
4. **Offline**: App requires internet connection for all features

## 🐛 Troubleshooting

### App won't build?
```bash
flutter clean
flutter pub get
flutter run
```

### Network errors?
- Check internet connection
- API might be temporarily down
- Try again after a few moments

### Images not loading?
- Check internet connection
- Clear app cache and restart

### Slow performance?
- Close other apps
- Restart the device
- Use release build: `flutter run --release`

## 📂 Key Files to Explore

### Entry Point
- `lib/main.dart` - App initialization and setup

### Pages
- `lib/presentation/pages/home/home_page.dart` - Home screen
- `lib/presentation/pages/search/search_page.dart` - Search screen
- `lib/presentation/pages/meal_detail/meal_detail_page.dart` - Recipe details
- `lib/presentation/pages/category_meals/category_meals_page.dart` - Filtered meals

### State Management
- `lib/presentation/blocs/home/home_bloc.dart` - Home logic
- `lib/presentation/blocs/search/search_bloc.dart` - Search logic
- `lib/presentation/blocs/meal_detail/meal_detail_bloc.dart` - Details logic

### Theme
- `lib/core/theme/app_theme.dart` - Light & dark themes
- `lib/core/theme/app_colors.dart` - Color palette

### API
- `lib/data/datasources/meal_remote_datasource.dart` - API calls
- `lib/core/constants/api_constants.dart` - Endpoints

## 🎯 Testing Different Screen Sizes

### Mobile
```bash
flutter run --device-id=<mobile-device>
```

### Tablet
```bash
flutter run --device-id=<tablet-device>
```

### Web (Responsive)
```bash
flutter run -d chrome
# Resize browser window to see responsive layout changes:
# - Mobile: < 650px (2 columns)
# - Tablet: 650-1099px (3 columns)
# - Desktop: ≥ 1100px (4 columns)
```

## 📊 Build Variants

### Debug Build (Development)
```bash
flutter run
```

### Release Build (Production - Much Faster)
```bash
flutter run --release
```

### Profile Build (Performance Analysis)
```bash
flutter run --profile
```

## 🔧 Development Tips

### Hot Reload
- Press `r` in terminal while app is running
- Changes appear instantly

### Hot Restart
- Press `R` in terminal
- Full restart with new state

### Clear Cache
```bash
flutter clean
```

### Update Dependencies
```bash
flutter pub upgrade
```

### Check for Issues
```bash
flutter analyze
```

### Format Code
```bash
flutter format .
```

## 📱 Platform-Specific Notes

### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: Latest
- Permissions: Internet (auto-granted)

### iOS
- Minimum iOS: 12.0
- Requires Xcode on Mac
- Auto-signed for debug builds

### Web
- Works on all modern browsers
- Best experience on Chrome/Edge
- Requires internet connection

### Desktop (Future Support)
- Windows: Experimental
- macOS: Experimental
- Linux: Experimental

## 🎓 Learning Resources

### Understanding the Code
1. Start with `main.dart` to see app initialization
2. Look at `home_page.dart` to understand UI structure
3. Check `home_bloc.dart` to see state management
4. Explore `meal_remote_datasource.dart` for API integration

### Flutter Concepts Used
- Stateless & Stateful Widgets
- BLoC Pattern
- Async/Await
- Futures & Streams
- Navigation
- Responsive Design
- Animations
- Image Caching
- HTTP Requests

## 💡 Customization Ideas

1. Change color scheme in `app_colors.dart`
2. Modify API endpoints in `api_constants.dart`
3. Add new animations in widgets
4. Customize card designs
5. Add more filtering options
6. Implement favorites feature
7. Add offline caching

---

**Happy Cooking! 👨‍🍳👩‍🍳**
