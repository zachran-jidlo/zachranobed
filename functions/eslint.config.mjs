import typescriptParser from "@typescript-eslint/parser";
import eslintPluginTypeScript from "@typescript-eslint/eslint-plugin";
import eslintPluginImport from "eslint-plugin-import";

export default [
  {
    ignores: ["lib/**/*", "lib/*"],
  },
  {
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      parser: typescriptParser,
      parserOptions: {
        tsconfigRootDir: new URL(".", import.meta.url).pathname,
      },
      globals: {
        // Node.js globals
        require: "readonly",
        module: "readonly",
        process: "readonly",
        __dirname: "readonly",
        URL: "readonly", 
      },
    },
    plugins: {
      "@typescript-eslint": eslintPluginTypeScript,
      "import": eslintPluginImport,
    },
    rules: {
      // These are the key rules from `eslint:recommended`
      "no-unused-vars": "warn",
      "no-undef": "error",
      "no-console": "warn",

      // Google style guide key rules
      "quotes": ["error", "double"],
      "require-jsdoc": "off",
      "valid-jsdoc": "off",

      // TypeScript-specific rules
      "@typescript-eslint/no-unused-vars": "warn",
      "@typescript-eslint/no-explicit-any": "warn",

      // Import plugin rules
      "import/no-unresolved": "off",
      "import/order": ["error", { "groups": [["builtin", "external", "internal"]] }],

      // Your custom rules
      "indent": ["error", 2],
    },
  },
];
