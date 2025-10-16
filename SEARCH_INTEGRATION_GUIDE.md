# Search Feature Integration Guide

This guide shows how to integrate the search feature into your home screen.

## Architecture Overview

The search feature follows **Clean Architecture** with these layers:

### 1. Domain Layer (Business Logic)
- `DogEntity` - Core domain entity
- `DogRepository` - Repository interface with `searchDogs()` method
- `SearchDogsUseCase` - Use case for searching dogs

### 2. Data Layer (Data Management)
- `DogModel` - Data model with JSON serialization
- `DogRepositoryImpl` - Repository implementation with search API calls
- `DogApiService.searchBreeds()` - API method for breed search

### 3. Presentation Layer (UI State Management)
- `SearchDogsState` - States (Initial, Loading, Loaded, Empty, Error)
- `SearchDogsCubit` - Cubit for managing search state
- `SearchBarWidget` - Search input with debouncing
- `SearchResultsWidget` - Display search results

## How to Integrate Search in Home Screen

### Option 1: Simple Integration (Show search results when searching)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animals_tasks/core/di/di.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs_cubit.dart';
import 'package:animals_tasks/features/home/presentation/widgets/search_bar.dart';
import 'package:animals_tasks/features/home/presentation/widgets/search_results_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchDogsCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Forever Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchBarWidget(
              onSearch: (query) {
                setState(() {
                  _isSearching = query.isNotEmpty;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isSearching
                  ? const SearchResultsWidget()
                  : const YourNormalDogsList(),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Option 2: Advanced Integration (With both search and normal list)

Update your existing home screen to add search capability:

```dart
class _HomeViewState extends State<_HomeView> {
  bool _isSearchActive = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<GetDogsCubit>()..fetchDogs(),
        ),
        BlocProvider(
          create: (_) => getIt<SearchDogsCubit>(),
        ),
      ],
      child: Scaffold(
        body: Column(
          children: [
            // Search Bar
            SearchBarWidget(
              onSearch: (query) {
                setState(() {
                  _isSearchActive = query.isNotEmpty;
                });
              },
            ),

            // Dynamic Content: Show search results or normal list
            Expanded(
              child: _isSearchActive
                  ? const SearchResultsWidget()
                  : BlocBuilder<GetDogsCubit, GetDogsState>(
                      builder: (context, state) {
                        if (state is GetDogsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is GetDogsLoaded) {
                          return ListView.builder(
                            itemCount: state.dogs.length,
                            itemBuilder: (context, index) =>
                                PetCard(dog: state.dogs[index]),
                          );
                        } else if (state is GetDogsError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Features

### 1. Debounced Search
- Search triggers 500ms after user stops typing
- Prevents excessive API calls

### 2. Clear Button
- Shows clear button when text is entered
- Clears search and returns to normal list

### 3. Empty State
- Shows friendly message when no results found

### 4. Error Handling
- Displays error messages from API failures

### 5. Loading State
- Shows loading indicator during search

## API Endpoint Used

```
GET https://api.thedogapi.com/v1/breeds/search?q={query}&limit=10&page=0
```

## State Management Flow

```
User types → SearchBarWidget
          → SearchDogsCubit.searchDogs(query)
          → SearchDogsUseCase
          → DogRepository.searchDogs()
          → DogApiService.searchBreeds()
          → API Response
          → DogModel → DogEntity
          → SearchDogsLoaded/Empty/Error
          → SearchResultsWidget updates UI
```

## All Created Files

### Domain Layer
- `lib/features/home/domain/repositories/dog_repo.dart` (updated)
- `lib/features/home/domain/usecases/search_dogs_usecase.dart`

### Data Layer
- `lib/core/services/dog_api_service.dart` (updated - added searchBreeds)
- `lib/features/home/data/repositories/dog_repo_impl.dart` (updated)

### Presentation Layer
- `lib/features/home/presentation/cubit/search_dogs_state.dart`
- `lib/features/home/presentation/cubit/search_dogs_cubit.dart`
- `lib/features/home/presentation/widgets/search_bar.dart` (updated)
- `lib/features/home/presentation/widgets/search_results_widget.dart`

### Dependency Injection
- `lib/core/di/di.dart` (updated - added SearchDogsUseCase and SearchDogsCubit)

## Next Steps

1. Update your `home_screen.dart` with one of the integration options above
2. Test the search functionality
3. Customize the UI as needed
4. Add any additional features (filters, sorting, etc.)
