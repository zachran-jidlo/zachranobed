# Maestro UI tests

End-to-end UI tests driven by [Maestro](https://docs.maestro.dev). The flows run the real app against the real
dev Firebase backend, so they cover the whole stack from the UI down to Firestore.

## Install

Install the Maestro CLI:

```bash
curl -fsSL "https://get.maestro.mobile.dev" | bash
```

Check the install and make sure the version is 2.x or newer:

```bash
maestro --version
```

The CLI lands in `~/.maestro/bin`. Add it to your `PATH` if the shell cannot find it.

## Run the tests

Build and install the dev flavor first. The flows target `cz.etnetera.mobile.zachranobed.dev` and rely on the
quick login button, which only the dev build has.

```bash
flutter build apk --flavor dev -t lib/main_dev.dart --debug
adb install -r build/app/outputs/flutter-apk/app-dev-debug.apk
```

Start an emulator or connect a device, then run the flows:

```bash
# Everything
maestro test maestro/

# One folder
maestro test maestro/login/

# One flow
maestro test maestro/login/quick_login.yaml
```

Pick a different test user with an environment variable:

```bash
maestro test -e USER=test-zo-jidelna maestro/login/quick_login.yaml
```

To watch what the flow does, open the Maestro viewer:

```bash
maestro studio
```

## Flows

```
maestro/
├── config.yaml             # Tells Maestro to pick up flows in subfolders
└── login/
    └── quick_login.yaml    # Sign in through the quick login button, land on the overview screen
```

New flows go in a folder named after the area they cover. `config.yaml` already matches every subfolder, so
nothing needs registering.

## Test users

The dev build has a quick login button on the login screen. It opens a sheet with the test accounts defined in
`lib/common/presentation/widget/dev/quick_login_button.dart`. Every account has a stable id, for example
`test-zo-charita` or `test-zo-jidelna`. Flows select an account by that id, never by its display name.

Accounts cover both roles and several pairing setups, including accounts with no history and accounts with
multiple pairs. Prefer an account that matches what the flow needs instead of adding new data to a shared one.

## How flows find elements

Flows match elements by semantics identifier, not by visible text:

```yaml
- tapOn:
    id: "login_submit_button"
```

Translations can change and would break text based flows for no good reason. Identifiers are set in Dart and stay 
stable.

Reusable UI components take an optional `semanticsIdentifier`. Pass it from the screen that uses the component:

```dart
UiPrimaryButton(
  text: context.l10n.signIn,
  semanticsIdentifier: 'login_submit_button',
  onPressed: _logIn,
)
```

Add the same optional parameter to other components when a flow needs them. For anything else, wrap the widget directly:

```dart
Semantics(
  identifier: 'overview_screen',
  container: true,
  child: content,
)
```

`container: true` matters. Without it Flutter can merge the node into a parent, most often a scroll view, and the
identifier never reaches the native tree. The element then looks invisible to Maestro even though it is on screen.

## Things to know before writing new flows

**Flows write to dev Firebase.** There is no fake backend. Anything a flow creates stays in the dev project.

**Donations depend on the day.** The overview screen only offers the donation actions when the active pair has a
delivery scheduled for today. On other days it shows a message instead, so donation flows cannot run.

**Delivery state moves one way.** A delivery goes from prepared through to done and never back. A flow that
accepts a delivery can only run once per pair per day.
