# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Zachraň oběd (Save Lunch) is a Flutter app connecting food providers with charities to redistribute surplus meals. Multi-platform: Android, iOS, Web.

- Flutter SDK: 3.32.4
- Dart: >= 3.4.3 < 4.0.0
- Backend: Firebase (Auth, Firestore, Cloud Functions, Messaging, Crashlytics)

## Essential Commands

```bash
# Setup & dependencies
flutter pub get

# Code generation (freezed, auto_route, json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner watch   # Watch mode

# Localization
flutter gen-l10n

# Run app with flavor
flutter run --flavor dev
flutter run --flavor stage
flutter run --flavor prod

# Build
flutter build apk --release --flavor prod
flutter build ipa --release --flavor prod
flutter build web --release

# Testing
flutter test
flutter test test/common/  # Specific directory

# Linting
dart run custom_lint
dart run custom_lint --watch
flutter analyze
```

## Architecture

### Feature-Based Clean Architecture

```
lib/
├── app/                    # App setup, DI, root widget
├── common/                 # Shared code across features
│   ├── data/              # DTOs, mappers, services, repositories
│   ├── domain/            # Models, repository interfaces, use cases
│   └── presentation/      # Widgets, notifiers, router, utils
├── features/              # Feature modules
│   ├── food/             # Food donations (domain/data/presentation/di)
│   ├── login/            # Authentication
│   ├── menu/             # Entity management
│   ├── notifications/    # Push notifications
│   └── ...
└── l10n/                  # Localization (.arb files)
```

### Layer Rules (Enforced by Linting)

- **Domain**: Pure business logic, no external dependencies
- **Data**: Firebase implementations, DTOs, mappers
- **Presentation**: UI, state management (ChangeNotifier)

### Key Patterns

**State Management**: Provider + ChangeNotifier
```dart
Consumer<UserNotifier>(
  builder: (context, notifier, child) => Text(notifier.user?.name ?? 'Guest'),
)
```

**Dependency Injection**: GetIt service locator
```dart
final repo = GetIt.I<FoodBoxRepository>();
```

**Routing**: auto_route with AuthGuard
```dart
MaterialRoute(page: OfferFoodAddNewRoute.page, guards: [AuthGuard()])
```

**Models**: Freezed for immutability
```dart
@freezed
class FoodInfo with _$FoodInfo {
  const factory FoodInfo({required String id, required String name}) = _FoodInfo;
}
```

## Enforced Lint Rules

Custom linting in `lint/arch/` enforces:
- **Absolute imports only**: Use `package:zachranobed/...`
- **No cross-feature dependencies**: Features can only import from common
- **Layer isolation**: Presentation → Domain → Data (not reverse)
- **No direct data access from presentation**: Must go through domain layer

## Build Flavors

Three environments with separate Firebase configs:
- `dev` - Development
- `stage` - Staging
- `prod` - Production

Firebase config files in `lib/app/data/firebase/firebase_options_*.dart`

## Code Generation

| Tool | Annotation | Output |
|------|-----------|--------|
| freezed | `@freezed` | `.freezed.dart` |
| json_serializable | `@JsonSerializable()` | `.g.dart` |
| auto_route | `@AutoRouterConfig` | `app_router.gr.dart` |

Always run after modifying annotated files:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Creating a New Feature

1. Create structure: `lib/features/feature_name/{domain,data,presentation,di}/`
2. Define models with `@freezed` in domain/model
3. Create repository interface in domain/repository
4. Implement repository in data/repository
5. Create DI container and register in `AppDependencyContainer.setup()`
6. Add screens with auto_route annotations
7. Register routes in `AppRouter`

## Important Locations

- **Router**: `lib/common/presentation/router/app_router.dart`
- **DI Setup**: `lib/app/di/app_dependency_container.dart`
- **Theme/Colors**: `lib/common/presentation/utils/ui_colors.dart`
- **Notifiers**: `lib/common/presentation/notifiers/`
- **Firebase Services**: `lib/common/data/service/`
