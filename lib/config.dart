// Configuration file for the note uploader app
class Config {
  // TODO: Replace with your actual API server URL
  static const String apiBaseUrl = 'http://localhost:8080'; // Default for local development

  // Available models for note creation
  static const List<String> availableModels = [
    'gpt-4o',
    'gpt-4o-mini',
    'claude-3-5-sonnet',
    'claude-3-haiku',
    // Add more models as supported by your backend
  ];

  static const String defaultModel = 'gpt-4o';
}