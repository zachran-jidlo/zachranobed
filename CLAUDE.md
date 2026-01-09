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

## UI Design System

### Design Principles

The app uses a custom UI component library with `Ui` prefix (e.g., `UiPrimaryButton`, `UiTextField`). These components provide a consistent design language across the app.

**Naming Convention**: All reusable UI components use the `Ui` prefix to distinguish them from feature-specific widgets.

**Context Extensions**: Access theme properties via extension methods:
- `context.uiColors` - Custom color palette from `UiColors` theme extension
- `context.textStyles` - Typography system from `UiTextStyles` wrapper
- `context.l10n` - Localization strings

### Component Categories

**Buttons** (`lib/common/presentation/widget/button/`):
- `UiPrimaryButton` - Primary CTA with gradient background
- `UiOutlineButton` - Secondary action with border
- `UiTextButton` - Tertiary text-only action
- `UiIconButton`, `UiFillIconButton`, `UiIconOutlineButton` - Icon-only variants
- Button sizing via `UiButtonSize` (large: 50px, medium: 40px, tiny: no minimum)

**Forms**:
- `UiTextField` - Standard text input with label, hint, error, and icon support
- `UiPasswordTextField` - Password input with visibility toggle (wraps UiTextField)
- `UiCounterField` - Numeric input with increment/decrement controls

**Cards & Tiles**:
- `UiCard` - Base container component
- `UiChip` - Small labeled tags with icons
- `UiFoodBoxTile` - Food box information display
- `UiFoodBoxReturnTile` - Box return tracking
- `UiBoxCounterTile` - Counter with label in tile format
- `UiNotificationTile` - Notification list items
- `UiMealTile`, `UiMealBadge` - Meal-related displays

**Navigation & Progress**:
- `UiAppBar` - Custom app bar following the design system
- `UiNavBar` - Bottom navigation with custom styling
- `UiProgressStepper` - Multi-step progress indicator
- `UiProgressBar` - Linear progress display

**Domain-Specific**:
- `UiDonationStatusCard` - Donation status display
- `UiDonationCountdownLabel` - Time remaining indicator
- `UiDonationTimeRangeLabel` - Time range display
- `UiIcon` - Standardized icon wrapper for SVG assets

### Typography System

Two font families with distinct roles:
- **Montserrat** - Used for display, headline, and title text (headers, navigation)
- **Plus Jakarta Sans** - Used for body and label text (content, buttons)

Access via `context.textStyles` with Material Design 3 scale (displayLarge, headlineLarge, titleMedium, bodyLarge, labelLarge, etc.). Custom variants include `headlineHeavy` and `titleHeavy` for bold weights.

### Color System

Custom color palette via `UiColors` theme extension includes:
- Primary colors with gradient variants
- Surface colors (white, gray shades)
- Text colors (primary, secondary, inverse)
- Semantic colors (success, warning, error, inactive)

Access via `context.uiColors.propertyName`.

### Spacing Guidelines

**Standard Approach**: Use hard-coded spacing values directly (e.g., `const SizedBox(height: 40)`, `const EdgeInsets.symmetric(horizontal: 16.0)`). Do NOT reference `GapSize` or `FontSize` constants from `UiConstants`.

**Rationale - Pros of Hard-coded Values**:
- **Pixel-perfect Figma alignment**: Direct numeric values match design specs exactly without translation layer
- **Explicit and readable**: Clear intent - `height: 24` is immediately understandable without looking up constant definitions
- **Reduced indirection**: No need to memorize or look up what `GapSize.m` translates to in pixels
- **Easier refactoring**: Changing spacing in one screen doesn't risk unintended side effects in unrelated screens
- **Designer-developer alignment**: Numeric values in code directly match numeric values in Figma specifications

**Examples**:
```dart
// ✅ Correct - Hard-coded values
const SizedBox(height: 40),
const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
const SizedBox(height: 12),

// ❌ Avoid - GapSize constants
const SizedBox(height: GapSize.xl),
const EdgeInsets.all(GapSize.m),
```

### Component Testing

Interactive component gallery available at `lib/features/debug/components_screen.dart` - accessible via Debug menu in dev/stage builds to preview all UI components.

## Important Locations

- **Router**: `lib/common/presentation/router/app_router.dart`
- **DI Setup**: `lib/app/di/app_dependency_container.dart`
- **UI Colors**: `lib/common/presentation/utils/ui_colors.dart`
- **Typography**: `lib/common/presentation/utils/ui_text_styles.dart`
- **Context Extensions**: `lib/common/presentation/utils/build_context_extensions.dart`
- **UI Components**: `lib/common/presentation/widget/ui_*.dart`
- **Button Components**: `lib/common/presentation/widget/button/ui_*.dart`
- **Component Gallery**: `lib/features/debug/components_screen.dart`
- **Notifiers**: `lib/common/presentation/notifiers/`
- **Firebase Services**: `lib/common/data/service/`
