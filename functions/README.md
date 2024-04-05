# How to deploy Firebase Functions
## Select correct Firebase project

There are two Firebase projects configured.
- (default) Prod environment `Zachran obed`
- (dev) DEV environment `Zachran obed DEV`

You can select project where you want deploy functions with `firebase use` e.g.
```
firebase use dev
```

By invoking `firebase use` you can see list of available projects and which one is currently selected.

## Using emulator for development

Use `firebase init emulators` for initialization and configuration of emulator. For this project select **Firestore** and **Functions** emulators.

```
firebase init emulators
```

After that you can run emulators by

```
firebase emulators:start
```