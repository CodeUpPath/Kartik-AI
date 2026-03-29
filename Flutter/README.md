# kartik_ai

Flutter app for Kartik Ai.

## Android package

- `applicationId`: `com.codeuppath.kartikai`
- `namespace`: `com.codeuppath.kartikai`

## Dart defines

Pass these at build/run time:

- `API_BASE_URL`
- `GOOGLE_CLIENT_ID`
- `GOOGLE_SERVER_CLIENT_ID`

Example:

```powershell
flutter run `
  --dart-define=API_BASE_URL=http://10.0.2.2:8080/api `
  --dart-define=GOOGLE_CLIENT_ID=your-google-client-id `
  --dart-define=GOOGLE_SERVER_CLIENT_ID=your-google-server-client-id
```

## Production build

1. Copy `env.production.example.json` to `env.production.json`
2. Set your live HTTPS backend URL and Google client IDs
3. Copy `android/key.properties.example` to `android/key.properties`
4. Point `storeFile` to your local upload keystore
5. Build the Play Store bundle:

```powershell
flutter build appbundle --release --dart-define-from-file=env.production.json
```

## Google Sign-In setup

Create Google OAuth credentials for package `com.codeuppath.kartikai`.

Android credential requires:

- package name: `com.codeuppath.kartikai`
- SHA-1 certificate fingerprint
- SHA-256 certificate fingerprint

The backend must also be configured with matching Google client IDs so it can
verify the incoming Google `idToken`.
