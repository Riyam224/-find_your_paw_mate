# Animals Tasks - Find Your Paw Mate 🐾

[![codecov](https://codecov.io/gh/riyam224/-find_your_paw_mate/branch/main/graph/badge.svg)](https://codecov.io/gh/riyam224/-find_your_paw_mate)
[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)](https://dart.dev)

A comprehensive Flutter application for browsing dog and cat breeds with favorites functionality, built using Clean Architecture principles, BLoC pattern, and comprehensive test coverage.

## Table of Contents

- [Demo](#demo)
- [Overview](#overview)
- [Features](#features)
- [UI Screens](#ui-screens)
- [Architecture](#architecture)
- [Logic Implementation](#logic-implementation)
- [Project Structure](#project-structure)
- [Testing Coverage](#testing-coverage)
- [Getting Started](#getting-started)
- [API Integration](#api-integration)
- [State Management](#state-management)
- [Dependencies](#dependencies)

---

## Demo

### App Walkthrough

![App Demo](screenshots/demo.gif)

### Test Coverage Report

![Test Coverage](screenshots/tests_report.png)

**Coverage Summary:**
- Total Test Files: 39
- Total Test Cases: 200+
- Overall Coverage: 87.3%
- Goal: 90%+ coverage

---

## Overview

This project is a full-featured mobile application that allows users to:

- Browse dog and cat breeds
- Search for specific breeds
- View detailed breed information
- Add/remove favorites
- Filter by categories
- Navigate through a clean, intuitive interface

**Key Highlights:**

- 🏗️ **Clean Architecture** with clear separation of concerns
- 🧪 **39 test files** with 200+ test cases covering all layers
- 🎨 **Modern UI** with custom widgets and animations
- 🔄 **BLoC State Management** with 5 dedicated Cubits
- 🌐 **Dual API Integration** (The Dog API + The Cat API)
- 📱 **Responsive Design** for various screen sizes
- ⚡ **Performance Optimized** with caching and debouncing
- 🎯 **87.3% Test Coverage** with Codecov integration

---

## UI Screens

### 1. Splash Screen
**[splash_screen.dart](lib/features/splash/presentation/screens/splash_screen.dart)**

- App entry point with branding
- 3-second auto-navigation to Onboarding
- Logo display with centered positioning
- Timer-safe for test environments

### 2. Onboarding Screen
**[onboarding_screen.dart](lib/features/onboarding/presentation/screens/onboarding_screen.dart)**

**Features:**
- Welcome image asset display
- Title: "Find Your Best Companion With Us"
- Descriptive subtitle with location features
- "Get Started" button with pet icon
- Routes to Home screen via GoRouter

### 3. Home Screen
**[home_screen.dart](lib/features/home/presentation/screens/home_screen.dart)**

**Key Components:**
- **Search Bar**: Real-time breed search with 500ms debouncing
- **Category Filters**: Horizontal scrollable chip selection
- **Breed Group Filter**: Bottom sheet modal for dog breeds
- **Pet Grid Display**: Vertical list of pet cards
- **Loading States**: Shimmer effect placeholders
- **Empty States**: "No dogs found" message
- **Pull-to-Refresh**: Manual data reload
- **Bottom Navigation**: Access to Favorites tab
- **Pagination**: Configurable limit and page parameters

**Managed by 3 Cubits:**
- `GetDogsCubit` - Fetch dogs/cats
- `SearchDogsCubit` - Real-time search
- `GetCategoriesCubit` - Category management

### 4. Details Screen
**[details_screen.dart](lib/features/details/presentation/screens/details_screen.dart)**

**Display Components:**
- Large hero image with loading/error states
- Pet name and breed group
- Info tiles with icons:
  - Gender
  - Age
  - Weight
- "About" section with description/temperament
- "Adopt me" button with snackbar feedback
- Favorite icon toggle in app bar

**Features:**
- Temperature-colored info tiles (teal background)
- Error retry button
- Full-screen loading state
- Dynamic data fetching via `GetDogDetailsCubit`

### 5. Favorites Screen
**[favorite_screen.dart](lib/features/favorite/presentation/screens/favorite_screen.dart)**

**Layout:**
- "Your Favorite Pets" title
- Category filter chips (horizontal scroll)
- 2-column grid view of favorite cards
- Empty state with heart icon

**Favorite Card Features:**
- Cached network image with placeholder
- Remove button (close icon) with confirmation dialog
- Pet name and breed name display
- "Added Xd ago" timestamp with relative time
- Tap to navigate to Details screen
- SnackBar feedback on removal

### Custom Widgets

**[pet_card.dart](lib/features/home/presentation/widgets/pet_card.dart)**
- Reusable pet display card
- Cached network image
- Name, breed, distance display
- Favorite toggle button
- Tap navigation to details

**[search_bar_widget.dart](lib/features/home/presentation/widgets/search_bar_widget.dart)**
- Custom search bar with debouncing
- Clear button (X icon)
- Real-time search trigger

**[category_chip.dart](lib/features/home/presentation/widgets/category_chip.dart)**
- Selectable category chips
- Active/inactive states
- Horizontal scrollable list

**[breed_filter_bottom_sheet.dart](lib/features/home/presentation/widgets/breed_filter_bottom_sheet.dart)**
- Modal bottom sheet for breed groups
- Selection with visual feedback
- Apply/cancel actions

---

## Features

### Core Functionality

#### 🏠 Home Screen

- Display grid of dog breeds with images  
- Search functionality with real-time results  
- Category filtering (Cute, Funny, etc.)  
- Breed group filtering  
- Pull-to-refresh  
- Pagination support  
- Add to favorites from home  

#### ❤️ Favorites Screen

- View all favorited breeds  
- Remove from favorites  
- Persistent storage via API  
- Empty state handling  

#### 📋 Details Screen

- Comprehensive breed information  
- Large hero image  
- Breed characteristics (temperament, size, lifespan)  
- Breed group and purpose  
- Add/remove favorite toggle  

#### 🎯 Additional Features

- Onboarding screen for first-time users  
- Splash screen with branding  
- Bottom navigation for easy access  
- Custom back button navigation  
- Error handling with user-friendly messages  

---

## Logic Implementation

### State Management: BLoC/Cubit Pattern

The app uses **5 main Cubits** for state management:

#### 1. GetDogsCubit
**[get_dogs_cubit.dart](lib/features/home/presentation/cubit/get_dogs_cubit.dart)**

- **Purpose**: Fetches and manages dog/cat list state
- **Methods**:
  - `fetchDogs(limit, page)` - Get paginated dog list
  - `fetchCatsByCategory(category, limit)` - Get cats by category
- **States**: `Initial`, `Loading`, `Loaded`, `Error`
- **Dependencies**: `GetDogsUseCase`

#### 2. SearchDogsCubit
**[search_dogs_cubit.dart](lib/features/home/presentation/cubit/search_dogs_cubit.dart)**

- **Purpose**: Handles real-time search functionality
- **Methods**:
  - `searchDogs(query)` - Search breeds by name
  - `clearSearch()` - Reset search state
- **States**: `Initial`, `Loading`, `Loaded`, `Empty`, `Error`
- **Features**: 500ms debouncing to reduce API calls
- **Dependencies**: `SearchDogsUseCase`

#### 3. GetCategoriesCubit
**[get_categories_cubit.dart](lib/features/home/presentation/cubit/get_categories_cubit.dart)**

- **Purpose**: Manages pet categories
- **Methods**: `fetchCategories()` - Get all categories
- **States**: `Initial`, `Loading`, `Loaded`, `Error`
- **Dependencies**: `GetCategoriesUseCase`

#### 4. GetDogDetailsCubit
**[get_dog_details_cubit.dart](lib/features/details/presentation/cubit/get_dog_details_cubit.dart)**

- **Purpose**: Fetches individual pet details
- **Methods**: `fetchDogDetails(dogId)` - Get single pet
- **States**: `Initial`, `Loading`, `Loaded`, `Error`
- **Dependencies**: `GetDogDetailsUseCase`

#### 5. FavoriteCubit
**[favorite_cubit.dart](lib/features/favorite/presentation/cubit/favorite_cubit.dart)**

- **Purpose**: Manages all favorites operations
- **Methods**:
  - `getFavorites()` - Fetch user favorites
  - `addFavorite(imageId, subId)` - Add to favorites
  - `removeFavorite(favoriteId)` - Remove from favorites
- **States**: `Initial`, `Loading`, `Loaded`, `Added`, `Removed`, `Error`
- **Dependencies**: `GetFavoritesUseCase`, `AddFavoriteUseCase`, `RemoveFavoriteUseCase`

### Use Cases (Domain Layer)

**7 Use Cases implementing functional programming:**

| Use Case | File | Purpose | Returns |
|----------|------|---------|---------|
| `GetDogsUseCase` | [get_dogs_usecase.dart](lib/features/home/domain/usecases/get_dogs_usecase.dart) | Fetch paginated dog list | `Either<Failure, List<DogEntity>>` |
| `SearchDogsUseCase` | [search_dogs_usecase.dart](lib/features/home/domain/usecases/search_dogs_usecase.dart) | Search dogs by breed | `Either<Failure, List<DogEntity>>` |
| `GetCategoriesUseCase` | [get_categories_usecase.dart](lib/features/home/domain/usecases/get_categories_usecase.dart) | Fetch categories | `Either<Failure, List<CategoryEntity>>` |
| `GetDogDetailsUseCase` | [get_dog_details_usecase.dart](lib/features/details/domain/usecases/get_dog_details_usecase.dart) | Fetch single pet details | `Either<Failure, DogEntity>` |
| `GetFavoritesUseCase` | [get_favorites_usecase.dart](lib/features/favorite/domain/usecases/get_favorites_usecase.dart) | Get all favorites | `Either<Failure, List<FavoriteEntity>>` |
| `AddFavoriteUseCase` | [add_favorite_usecase.dart](lib/features/favorite/domain/usecases/add_favorite_usecase.dart) | Add pet to favorites | `Either<Failure, FavoriteEntity>` |
| `RemoveFavoriteUseCase` | [remove_favorite_usecase.dart](lib/features/favorite/domain/usecases/remove_favorite_usecase.dart) | Remove from favorites | `Either<Failure, Unit>` |

**Pattern**: All use cases return `Either<Failure, T>` from Dartz for functional error handling.

### Data Models & Entities

#### DogEntity (Domain Layer)
**[dog_entity.dart](lib/features/home/domain/entities/dog_entity.dart)**

```dart
class DogEntity extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String? imageId;
  final String? gender;
  final String? age;
  final String? weight;
  final String? distance;
  final String? lifeSpan;
  final String? breedGroup;
  final String? description;
  final bool isFavorite;
}
```

#### DogModel (Data Layer)
**[dog_model.dart](lib/features/home/data/models/dog_model.dart)**

- Extends DogEntity
- `fromJson()` factory for API response parsing
- CDN URL construction from image ID
- Mock data generation for missing fields

#### FavoriteEntity (Domain Layer)
**[favorite_entity.dart](lib/features/favorite/domain/entities/favorite_entity.dart)**

```dart
class FavoriteEntity extends Equatable {
  final String id;
  final String imageId;
  final String imageUrl;
  final String? subId;
  final DateTime createdAt;
  final String? petName;
  final String? breedName;
  final String? breedId;
}
```

#### FavoriteModel (Data Layer)
**[favorite_model.dart](lib/features/favorite/data/models/favorite_model.dart)**

- Constructed from API response
- Handles missing image metadata
- CDN URL fallback construction

### Repository Pattern

**4 Repository Interfaces (Domain):**
1. **DogRepository** - [dog_repository.dart](lib/features/home/domain/repositories/dog_repository.dart)
2. **CategoryRepository** - [category_repository.dart](lib/features/home/domain/repositories/category_repository.dart)
3. **DogDetailsRepository** - [dog_details_repository.dart](lib/features/details/domain/repositories/dog_details_repository.dart)
4. **FavoriteRepository** - [favorite_repository.dart](lib/features/favorite/domain/repositories/favorite_repository.dart)

**4 Repository Implementations (Data):**
1. **DogRepositoryImpl** - [dog_repository_impl.dart](lib/features/home/data/repositories/dog_repository_impl.dart)
2. **CategoryRepositoryImpl** - [category_repository_impl.dart](lib/features/home/data/repositories/category_repository_impl.dart)
3. **DogDetailsRepositoryImpl** - [dog_details_repository_impl.dart](lib/features/details/data/repositories/dog_details_repository_impl.dart)
4. **FavoriteRepositoryImpl** - [favorite_repository_impl.dart](lib/features/favorite/data/repositories/favorite_repository_impl.dart)

**Error Handling:**
- Catches `DioException` and maps to domain `Failure` types
- Graceful null/malformed data handling
- Three failure types: `ServerFailure`, `NetworkFailure`, `UnknownFailure`

### Dependency Injection (GetIt)

**[di.dart](lib/core/di/di.dart)**

**Lazy Singleton Registrations:**
- `Dio` instance for Dog API
- `DogApiService` for Dog API
- Named `Dio` instance for Cat API
- Named `DogApiService` for Cat API

**Factory Registrations:**
- All 5 Cubits (fresh instance per use)
- All 7 Use Cases
- All 4 Repository Implementations

**Safety Features:**
- `_isDependenciesSetup` flag prevents re-registration
- `isRegistered()` checks before each registration

### Error Handling Framework

**[failure.dart](lib/core/error/failure.dart)**

```dart
abstract class Failure {
  final String message;
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

class UnknownFailure extends Failure {
  UnknownFailure(String message) : super(message);
}
```

**Error Flow:**
1. API throws `DioException` or generic `Exception`
2. Repository catches and maps to domain `Failure`
3. UseCase returns `Either<Failure, T>`
4. Cubit folds result and emits appropriate state
5. UI displays error message via `BlocBuilder`

### Networking Layer

**[dio_client.dart](lib/core/networking/dio_client.dart)** - DIO configuration
**[api_constants.dart](lib/core/networking/api_constants.dart)** - URLs and keys
**[dog_api_service.dart](lib/core/services/dog_api_service.dart)** - API endpoints

**Dual API Setup:**
- **Primary**: The Dog API (for dogs and searches)
- **Secondary**: The Cat API (for cats, categories, favorites)

**Key Endpoints:**
- `GET /images/search` - Dog/cat images
- `GET /breeds` - All breeds
- `GET /breeds/search` - Search breeds
- `POST /favourites` - Add favorite
- `GET /favourites` - Get favorites
- `DELETE /favourites/{id}` - Remove favorite
- `GET /categories` - Get cat categories

**Features:**
- 10-second timeout
- API key headers
- Structured error messages
- CDN URL construction

---

## Architecture

This project follows **Clean Architecture** principles with clear layer separation:

┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI, Widgets, Cubits, States)          │
└──────────────┬──────────────────────────┘
│
┌──────────────▼──────────────────────────┐
│         Domain Layer                    │
│  (Entities, Use Cases, Repositories)    │
└──────────────┬──────────────────────────┘
│
┌──────────────▼──────────────────────────┐
│         Data Layer                      │
│  (Models, Repository Impl, API)         │
└─────────────────────────────────────────┘

### Layer Responsibilities

#### Presentation Layer

- **Screens**: UI pages (Home, Favorites, Details, etc.)  
- **Widgets**: Reusable UI components  
- **Cubits**: State management (BLoC pattern)  
- **States**: State classes for each feature  

#### Domain Layer

- **Entities**: Business objects (DogEntity, FavoriteEntity)  
- **Use Cases**: Business logic (GetDogsUseCase, AddFavoriteUseCase)  
- **Repositories**: Abstract interfaces  

#### Data Layer

- **Models**: Data transfer objects with JSON serialization  
- **Repository Implementations**: Concrete repository classes  
- **API Services**: Network calls and error handling  

---

## Project Structure

lib/
├── core/
│   ├── common_ui/
│   │   └── widgets/          # Reusable UI components
│   ├── di/                   # Dependency Injection
│   ├── error/                # Error classes
│   ├── networking/           # API clients and constants
│   ├── routing/              # Navigation setup
│   ├── services/             # API services
│   ├── storage/              # Local storage
│   └── styling/              # Theme and colors
│
├── features/
│   ├── details/
│   │   ├── data/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── cubit/
│   │       └── screens/
│   │
│   ├── favorite/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── cubit/
│   │       └── screens/
│   │
│   ├── home/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── cubit/
│   │       ├── screens/
│   │       └── widgets/
│   │
│   ├── onboarding/
│   └── splash/
│
└── layout/                   # Main layout wrapper

test/                         # Mirror structure of lib/
├── core/
├── features/
└── layout/

---

## Testing Coverage

### Coverage Summary

- **Total Test Files:** 39
- **Total Test Cases:** 200+
- **Overall Coverage:** 87.3% (LCOV Report)
- **Testing Framework:** Flutter Test + BLoC Test + Mocktail
- **CI/CD:** Codecov integration with GitHub Actions

📊 **Codecov Dashboard:** [View full report](https://app.codecov.io/gh/riyam224/-find_your_paw_mate)

![Test Coverage Report](screenshots/tests_report.png)

### Test Categories

#### Core Tests (4 files - 25+ test cases)
- **[di_test.dart](test/core/di/di_test.dart)** - Dependency injection registration
- **[failure_test.dart](test/core/error/failure_test.dart)** - Failure hierarchy validation
- **[dog_api_service_test.dart](test/core/services/dog_api_service_test.dart)** - API endpoint coverage
- **API Services Tests** - Network layer testing

#### Data Layer Tests (4 files - 50+ test cases)
- **[dog_repository_impl_test.dart](test/features/home/data/repositories/dog_repository_impl_test.dart)** - Dog repository operations
- **[category_repository_impl_test.dart](test/features/home/data/repositories/category_repository_impl_test.dart)** - Category repository
- **[dog_details_repository_impl_test.dart](test/features/details/data/repositories/dog_details_repository_impl_test.dart)** - Details repository
- **[favorite_repository_impl_test.dart](test/features/favorite/data/repositories/favorite_repository_impl_test.dart)** - **55 comprehensive tests!**
  - getFavorites group: 6 tests (success, empty, missing data, errors)
  - addFavorite group: 6 tests (success, parameters, null handling)
  - removeFavorite group: 10 tests (valid/invalid IDs, edge cases)

#### Domain Layer Tests (7 files - 45+ test cases)
- **[get_dogs_usecase_test.dart](test/features/home/domain/usecases/get_dogs_usecase_test.dart)**
- **[search_dogs_usecase_test.dart](test/features/home/domain/usecases/search_dogs_usecase_test.dart)**
- **[get_categories_usecase_test.dart](test/features/home/domain/usecases/get_categories_usecase_test.dart)**
- **[get_dog_details_usecase_test.dart](test/features/details/domain/usecases/get_dog_details_usecase_test.dart)**
- **[get_favorites_usecase_test.dart](test/features/favorite/domain/usecases/get_favorites_usecase_test.dart)**
- **[add_favorite_usecase_test.dart](test/features/favorite/domain/usecases/add_favorite_usecase_test.dart)**
- **[remove_favorite_usecase_test.dart](test/features/favorite/domain/usecases/remove_favorite_usecase_test.dart)**

#### Presentation Layer Tests (24+ files - 80+ test cases)

**Cubit Tests (10 files):**
- **[get_dogs_cubit_test.dart](test/features/home/presentation/cubit/get_dogs_cubit_test.dart)** - 10 tests (success, failure, edge cases)
- **[search_dogs_cubit_test.dart](test/features/home/presentation/cubit/search_dogs_cubit_test.dart)** - 8 tests
- **[get_categories_cubit_test.dart](test/features/home/presentation/cubit/get_categories_cubit_test.dart)** - 7 tests
- **[get_dog_details_cubit_test.dart](test/features/details/presentation/cubit/get_dog_details_cubit_test.dart)** - 10 tests
- **[favorite_cubit_test.dart](test/features/favorite/presentation/cubit/favorite_cubit_test.dart)** - 12 tests
- Plus state tests for each cubit

**Screen Tests (6 files):**
- **[home_screen_test.dart](test/features/home/presentation/screens/home_screen_test.dart)**
- **[details_screen_test.dart](test/features/details/presentation/screens/details_screen_test.dart)**
- **[favorite_screen_test.dart](test/features/favorite/presentation/screens/favorite_screen_test.dart)**
- **[splash_screen_test.dart](test/features/splash/presentation/screens/splash_screen_test.dart)**
- **[onboarding_screen_test.dart](test/features/onboarding/presentation/screens/onboarding_screen_test.dart)**
- **[main_layout_test.dart](test/layout/main_layout_test.dart)**

**Widget Tests (8+ files):**
- **[pet_card_test.dart](test/features/home/presentation/widgets/pet_card_test.dart)** - Card interactions
- **[search_bar_widget_test.dart](test/features/home/presentation/widgets/search_bar_widget_test.dart)** - Search with debounce
- **[search_results_widget_test.dart](test/features/home/presentation/widgets/search_results_widget_test.dart)** - Results display
- **[category_chip_test.dart](test/features/home/presentation/widgets/category_chip_test.dart)** - Category selection
- **[breed_filter_bottom_sheet_test.dart](test/features/home/presentation/widgets/breed_filter_bottom_sheet_test.dart)** - Filter modal
- Plus additional widget tests

### Test Best Practices

- **Mocking**: Mocktail for service/repository mocks
- **BLoC Testing**: bloc_test for cubit state emissions
- **Arrange-Act-Assert**: Clear test structure
- **Edge Cases**: Null values, empty lists, invalid data
- **Error Scenarios**: Network failures, malformed JSON
- **Type Checking**: `isA<Type>()` for state verification

### Example Test: FavoriteRepositoryImpl

**[favorite_repository_impl_test.dart](test/features/favorite/data/repositories/favorite_repository_impl_test.dart)** includes:

**getFavorites tests:**
- ✅ Success with valid data
- ✅ Empty list handling
- ✅ Missing image object handling
- ✅ DioException with response
- ✅ DioException without response
- ✅ Generic exception handling

**addFavorite tests:**
- ✅ Successful addition
- ✅ Correct API parameters
- ✅ Null ID handling
- ✅ Server failure scenarios
- ✅ Network timeouts

**removeFavorite tests:**
- ✅ Valid ID parsing (numeric strings)
- ✅ Invalid ID formats
- ✅ Empty ID handling
- ✅ Very large IDs
- ✅ DioException handling

---

## Getting Started

### Prerequisites  

- Flutter SDK (3.0+)  
- Dart SDK (3.0+)  
- An IDE (VS Code, Android Studio, or IntelliJ)

### Installation

```bash
git clone <repository-url>
cd animals_tasks
flutter pub get
flutter run
```

### Run Tests

```bash
# Run all tests
flutter test

# Generate coverage report
flutter test --coverage

# View coverage in HTML
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```


---

## API Integration

### The Dog API
**Base URL:** `https://api.thedogapi.com/v1/`
**Usage:** Dog breeds, images, search

**Endpoints:**
- `GET /breeds` - Get all dog breeds
- `GET /breeds/search?q={query}` - Search breeds
- `GET /images/search?limit={limit}&page={page}` - Get dog images

### The Cat API
**Base URL:** `https://api.thecatapi.com/v1/`
**Usage:** Cat breeds, categories, favorites

**Endpoints:**
- `GET /images/search?category_ids={id}&limit={limit}` - Get cat images by category
- `GET /categories` - Get all categories
- `POST /favourites` - Add favorite
- `GET /favourites?sub_id={userId}` - Get user favorites
- `DELETE /favourites/{id}` - Remove favorite

**Authentication:**
- API keys stored in `api_constants.dart`
- Headers automatically added via Dio interceptors

---

## State Management

This app uses **BLoC/Cubit** pattern for state management:

### Example: GetDogsCubit

```dart
class GetDogsCubit extends Cubit<GetDogsState> {
  final GetDogsUseCase getDogsUseCase;

  GetDogsCubit(this.getDogsUseCase) : super(GetDogsInitial());

  Future<void> fetchDogs({int limit = 10, int page = 0}) async {
    emit(GetDogsLoading());

    final result = await getDogsUseCase(limit: limit, page: page);

    result.fold(
      (failure) => emit(GetDogsError(failure.message)),
      (dogs) => emit(GetDogsLoaded(dogs)),
    );
  }
}
```

### State Flow

```
Initial State
    ↓
Loading State (show spinner)
    ↓
Loaded/Error State (show data/error)
    ↓
[user interaction triggers new cycle]
```

### BlocBuilder Usage

```dart
BlocBuilder<GetDogsCubit, GetDogsState>(
  builder: (context, state) {
    if (state is GetDogsLoading) {
      return ShimmerLoadingWidget();
    } else if (state is GetDogsLoaded) {
      return PetGridView(dogs: state.dogs);
    } else if (state is GetDogsError) {
      return ErrorWidget(message: state.message);
    }
    return SizedBox.shrink();
  },
)
```

---

## Dependencies

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7

  # Networking
  dio: ^5.9.0

  # Dependency Injection
  get_it: ^8.2.0

  # Navigation
  go_router: ^16.2.4

  # Local Storage
  shared_preferences: ^2.5.3

  # UI Components
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0

  # Functional Programming
  dartz: ^0.10.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

  # Testing
  bloc_test: ^10.0.0
  mocktail: ^1.0.4
```

---

## Development Practices

### Clean Architecture Principles

**Separation of Concerns:**
- Presentation layer knows only about domain
- Domain is framework-independent
- Data layer isolated from UI

**Dependency Inversion:**
- High-level modules don't depend on low-level modules
- Both depend on abstractions (interfaces)

### SOLID Principles

- **S** (Single Responsibility): Each class has one job
- **O** (Open/Closed): Open for extension, closed for modification
- **L** (Liskov Substitution): Repository implementations are substitutable
- **I** (Interface Segregation): Small focused interfaces
- **D** (Dependency Inversion): Depend on abstractions

### Testing Strategy

- **Unit Tests**: All use cases, cubits, repositories
- **Widget Tests**: All screens and custom widgets
- **Integration Tests**: End-to-end user flows
- **Mocking**: Mocktail for external dependencies
- **Coverage Goal**: 90%+

### Git Workflow

**Branching Strategy:**
- `main` - Production-ready code
- `develop` - Development branch
- Feature branches for new features
- Testing branch for test implementations

**Recent Commits:**
- ✅ Merged testing branch
- ✅ Updated README with Codecov badge
- ✅ Added Flutter tests workflow
- ✅ Refactored logic
- ✅ Completed favorite screen tests

---

## Key Learnings & Achievements

### Architecture
- ✅ Full implementation of Clean Architecture
- ✅ Proper layer separation (Presentation → Domain → Data)
- ✅ Dependency injection with GetIt
- ✅ Repository pattern for data abstraction
- ✅ Use cases for business logic encapsulation

### Testing
- ✅ 39 test files with 200+ test cases
- ✅ 87.3% code coverage
- ✅ Comprehensive unit, widget, and integration tests
- ✅ Mocking external dependencies
- ✅ Testing all state emissions
- ✅ Edge case and error scenario coverage

### API Integration
- ✅ Dual API integration (Dog API + Cat API)
- ✅ Proper error handling with Either type
- ✅ Network timeout management
- ✅ Response parsing and validation
- ✅ CDN URL construction

### UI/UX
- ✅ Modern Material Design 3
- ✅ Smooth animations and transitions
- ✅ Loading states with shimmer effects
- ✅ Empty states with helpful messages
- ✅ Error handling with retry options
- ✅ Responsive design for various screen sizes
- ✅ Image caching for performance

### State Management
- ✅ BLoC pattern implementation
- ✅ 5 dedicated Cubits for feature isolation
- ✅ Predictable state handling
- ✅ Separation of business logic from UI
- ✅ Testable state transitions

---

## Future Enhancements

- [ ] Increase test coverage to 90%+
- [ ] Add integration tests for complete user flows
- [ ] Implement infinite scroll pagination
- [ ] Add filters for age, size, temperament
- [ ] Implement dark mode theme
- [ ] Add animations for screen transitions
- [ ] Implement offline mode with local caching
- [ ] Add user authentication
- [ ] Implement sharing favorite pets
- [ ] Add breed comparison feature
- [ ] Implement advanced search filters
- [ ] Add location-based nearby shelters

---

## Features Summary

| Category | Feature | Implementation | Test Coverage |
|----------|---------|----------------|---------------|
| **Browsing** | Browse dogs | GetDogsCubit + API | 10 tests |
| | Browse cats | GetDogsCubit + API | 8 tests |
| | Pagination | UseCase params | Implicit |
| **Search** | Real-time search | SearchDogsCubit | 8 tests |
| | Empty state | SearchDogsEmpty | 2 tests |
| | Clear search | clearSearch() | 2 tests |
| **Filtering** | Category chips | GetCategoriesCubit | 7 tests |
| | Breed group filter | Bottom sheet + state | 5 tests |
| **Details** | View pet details | GetDogDetailsCubit | 10 tests |
| | Image display | Cached network image | Widget tests |
| | Adoption request | Button callback | Widget test |
| **Favorites** | Add favorite | FavoriteCubit + API | 15 tests |
| | Remove favorite | FavoriteCubit + API | 12 tests |
| | Get favorites | FavoriteCubit + API | 8 tests |
| | Persistent storage | Server-side (Cat API) | 8 tests |
| **Navigation** | Splash → Onboarding | GoRouter + Timer | 3 tests |
| | Home → Details | Navigator + params | 4 tests |
| | Bottom nav | Tab navigation | Widget test |
| **UI/UX** | Shimmer loading | Custom widget | Widget test |
| | Pull-to-refresh | RefreshIndicator | Widget test |
| | Error handling | Dialogs + snackbars | Widget tests |
| | Empty states | Custom messages | Widget tests |

---

## License

This project is created for educational purposes as part of the Flutter Mentorship program.

---

## Contact & Support

For questions or support, please reach out through the mentorship program channels.

---

## Acknowledgments

- **The Dog API** for providing comprehensive dog breed data
- **The Cat API** for cat breeds and favorites functionality
- **Flutter Community** for excellent packages and resources
- **Mentorship Program** for guidance and support

---

Built with ❤️ using Flutter

**Developer:** Riyam
**Project:** Animals Tasks - Find Your Paw Mate
**Date:** 2025
**Framework:** Flutter 3.0+
**Architecture:** Clean Architecture + BLoC Pattern
