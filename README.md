# Maega

A Flutter service-marketplace app for on-demand service technicians (cleaning, AC repair, and similar jobs), covering authentication, job and booking management, earnings tracking, and profile settings.

## What it does

- **Authentication & real-time sync** — Firebase Authentication and Cloud Firestore keep user profiles, saved addresses, and payment methods in sync, with stream subscriptions managed across the sign-in/sign-out lifecycle.
- **Job-tracking workflow** — status tabs (Assigned / In Progress / History), booking search, and an earnings dashboard with daily/weekly/monthly stats and withdrawal history.
- **State management** — reactive state via the Provider package, including app-wide light/dark theming persisted with Shared Preferences.
- **UI** — built directly from Figma designs, including animations and Material 3 theming.

## Security

Firestore access is scoped per authenticated user — see [`firestore.rules`](./firestore.rules). Each user can only read/write their own profile, saved addresses, and cards; there is no open or wildcard access.

## Stack

Flutter · Dart · Firebase (Authentication, Cloud Firestore) · Provider · Shared Preferences

## Getting started

```
flutter pub get
flutter run
```

Requires a Firebase project configured via `lib/firebase_options.dart` (FlutterFire CLI).
