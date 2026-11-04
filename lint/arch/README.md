# Lint rules for architecture

This package provides custom lint rules for the project. It is an analyzer plugin built on `analysis_server_plugin`. The rules run inside the Dart analysis server, so they show up in the IDE and in `dart analyze`.

## Project structure

- `lib/`: Contains the main linting logic.
    - `main.dart`: The plugin entry point. It registers all rules.
    - `lib/rule/`: This directory contains the implementations of individual custom lint rules.

## Available Rules

This package includes the following custom lint rules:

*   **`avoid_relative_imports`**: Prevents using relative imports (e.g., `../file.dart`). Encourages using package imports (e.g., `package:your_project_name/file.dart`) for better clarity.
*   **`invalid_feature_layering`**: Ensures files within a feature's subdirectories (`lib/features/<feature_name>/...`) are correctly placed in one of the allowed architectural layers: `domain/`, `data/`, `presentation/`, or `di/`.
*   **`avoid_cross_feature_dependency`**: Prohibits a feature module from directly importing code from another feature module. Shared code should be in a `common/` directory.
*   **`invalid_feature_layer_dependency`**: Enforces correct dependency flow between Clean Architecture layers within the same feature:
    *   `domain` cannot import from `data`, `presentation`, or `di`.
    *   `data` can only import from `domain`.
    *   `presentation` can only import from `domain`.
    *   `di` can import from `domain`, `data`, and `presentation`.

## How to run

The plugin is enabled in the root `analysis_options.yaml`. Run it from the project root through [FVM](https://fvm.app):

```
fvm dart analyze --fatal-infos
```

Use `fvm` so the analyzer comes from the SDK pinned in `.fvmrc`. A global `dart` may be older and report false errors.

`flutter analyze` exits before analyzer plugins report, so it does not show these rules.

After changing a rule, restart the analysis server in the IDE. If `fvm dart analyze` still runs the old code, delete `~/.dartServer/.plugin_manager` to force a rebuild.
