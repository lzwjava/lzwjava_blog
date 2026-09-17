# Note Uploader - Flutter iOS App

A Flutter iOS application for uploading notes to a backend server that creates formatted notes using AI.

## Features

- Multi-line text input for note content
- AI model selection (configurable in `lib/config.dart`)
- HTTP POST requests to backend API
- Loading states and error handling
- Success feedback after note creation

## Setup

### Prerequisites

- Flutter SDK
- iOS development environment (Xcode, simulators)

### Installation

```bash
# Clone or navigate to the project directory
cd /Users/lzwjava/projects/lzwjava_blog

# Get dependencies
flutter pub get

# Run on iOS simulator
flutter run
```

### Configuration

Edit `lib/config.dart` to configure:

- API base URL (where your Spring Boot server runs)
- Available AI models for note creation
- Default model selection

Example:
```dart
class Config {
  static const String apiBaseUrl = 'http://10.0.2.2:8080'; // Android emulator
  // static const String apiBaseUrl = 'http://localhost:8080'; // iOS simulator
  static const List<String> availableModels = ['gpt-4o', 'claude-3-5-sonnet'];
}
```

### API Backend

This app communicates with a Spring Boot server that:

1. Accepts note content via POST `/create-note`
2. Writes content to system clipboard
3. Calls Python `create_note_from_clipboard.py` script

Make sure the backend server is running and accessible from the device/emulator.

## Usage

1. Select your preferred AI model from the dropdown
2. Enter your note content in the text field
3. Tap "Create Note" to upload
4. Check the status message for success/error feedback

## Development

For help with Flutter development:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Online documentation](https://docs.flutter.dev/)
