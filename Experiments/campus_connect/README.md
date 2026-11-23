# CampusConnect – Student Event & Notes Hub

A campus utility app built with Flutter and Firebase. Students can browse and
create events, RSVP, keep personal notes, and (for staff) manage a student
directory. Data syncs in real time through Cloud Firestore and keeps working
offline.

## Features

- **Authentication:** Firebase Auth (email and password), splash and onboarding.
- **Home:** `CustomScrollView` with a `SliverAppBar`, sticky category headers,
  mixed grid and list, and a public events feed loaded from a REST API.
- **Events:** real-time Firestore events, create events, RSVP, upcoming /
  my events / notes tabs, Hero image animation, search.
- **Offline support:** optimistic UI, "Syncing" badges and an offline banner;
  RSVPs use `arrayUnion` / `arrayRemove` so concurrent changes never overwrite
  each other.
- **Notes:** saved to a local JSON file (`shared_preferences` on the web).
- **Students:** add, edit, delete, photo from gallery or camera, search, filter
  by department and year, sort, and a statistics dashboard.
- **Settings:** dark mode, color themes, language (English, Hindi, Gujarati),
  clear local data, logout.
- **Quality:** form validation, loading skeletons, empty and error states,
  unit and widget tests.

## Tech stack

Flutter, Provider (`ChangeNotifier`), Firebase Auth, Cloud Firestore,
`shared_preferences`, `path_provider`, `image_picker`, `http`,
`flutter_localizations`.

## Architecture

```
+-------------------------------------------------------------------+
|  UI: screens/ and widgets/                                        |
|  Splash, Onboarding, Login, Register                              |
|  Home: Discover | Events (tabs + drawer) | Students | Dashboard    |
|        | Settings                                                 |
+---------------------------^---------------------------------------+
                            |  context.watch / context.read
+---------------------------+---------------------------------------+
|  State: providers/ (Provider + ChangeNotifier)                    |
|  AuthProvider    StudentProvider   EventProvider                  |
|  PublicEventProvider   NoteProvider   ThemeProvider   LocaleProvider |
+---------------------------^---------------------------------------+
                            |
+---------------------------+---------------------------------------+
|  Services: services/                                              |
|  AuthService  StudentService  EventSyncService  PublicEventService|
|  NoteStorage  PrefsService                                        |
+-----^-------------^----------------^--------------^----------^----+
      |             |                |              |          |
 Firebase Auth   Firestore        Firestore     REST API    Device
                 "students"       "events"   (JSONPlaceholder) notes.json
                                                            SharedPreferences
```

Data flow: a screen calls a provider method, the provider calls a service,
and the service talks to Firebase, the API or the device. Firestore streams
push changes back to the provider, which calls `notifyListeners()` and the
screens rebuild.

Models (`Student`, `Event`, `Note`) are plain Dart classes with `toMap`,
`fromMap`, `toJson`, `fromJson`, `copyWith` and `==`.

## Project structure

```
lib/
  main.dart            app entry, providers, localization
  models/              student.dart, event.dart, note.dart
  services/            Firebase, API and local storage access
  providers/           app state
  screens/             one file per screen
  widgets/             reusable components
  utils/               routes, themes, validators, extensions, strings
test/                  unit and widget tests
```

## Data model (Firestore)

| Collection | Fields |
|---|---|
| `students` | name, rollNo, department, year, email, phone, photo (base64) |
| `events` | title, description, location, category, organizer, dateTime (ms), attendees (list of user ids), image |

Security rules (signed-in users only):

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Setup

1. Install Flutter and clone the project.
2. Create a Firebase project, enable **Authentication -> Email/Password** and
   create a **Firestore** database. Publish the rules above.
3. Run:
   ```
   flutter pub get
   dart pub global run flutterfire_cli:flutterfire configure
   flutter run -d chrome
   ```
4. Android: set `minSdk = 23` in `android/app/build.gradle.kts`.

## Tests

```
flutter test
```

Covers validators, model serialization and equality, date and search
extensions, localization strings and the login form.

## Release build

1. Create a keystore and `android/key.properties`
   (this file and the `.jks` must never be committed).
2. Build:
   ```
   flutter build apk --release
   flutter build appbundle --release
   ```
3. Outputs:
   `build/app/outputs/flutter-apk/app-release.apk` and
   `build/app/outputs/bundle/release/app-release.aab`.

## Known limitations

- Notes and settings are stored per device, not synced to the cloud.
- Public events come from a mock API and are read-only.
- Security rules allow any signed-in user to edit any event or student.