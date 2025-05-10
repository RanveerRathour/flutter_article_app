# Flutter Article App
A Flutter app that fetches and displays a list of articles from a public API.

## Features
- Article listings
- Favorite article tracking
- Search functionality
- Favorite marking system that persist
- Detailed article view

## Setup Instructions
1. Clone the repo:
    git clone https://github.com/RanveerRathour/flutter_article_app.git
    
    cd flutter_article_app
2. Install dependencies:
    flutter pub get
3. Run the app:
    flutter run

## Tech Stack
- Flutter SDK: Flutter 3.29.3 • channel stable 
- State Management: Riverpod
- HTTP Client: http
- Persistence: shared_preferences

## State Management Explanation
  I have used Riverpod as my state management solution. It is easy to read and understand.

## Known Issues / Limitations
  As such there is no issues, but scope of improvements. Like in search screen we can use debouncer to avoid unnecessary search call while user is still typing.

## Screenshots

<img src="https://github.com/user-attachments/assets/6b72f034-c853-4fce-9bfd-9b62ab7982db" width="300">
<img src="https://github.com/user-attachments/assets/1313d511-93a3-4cb9-87e5-53cfc895de67" width="300">
<img src="https://github.com/user-attachments/assets/78aa92e9-b778-4587-a07f-e3a574f759a5" width="300">



