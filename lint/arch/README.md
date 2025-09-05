# Lint rules for architecture

This package provides custom lint rules for the project. It uses the `custom_lint_builder` and `analyzer` packages to define and enforce these rules.

## Project structure

- `lib/`: Contains the main linting logic.
    - `lint_arch.dart`: The entry point for defining or exporting lint rules.
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

Use this command to run custom lint rules in command line:

```
dart run custom_lint
```
