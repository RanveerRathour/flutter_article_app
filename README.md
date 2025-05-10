# Flutter Article App
A Flutter app that fetches and displays a list of articles from a public
API.
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

## Screenshots (Optional)

<img src="https://github.com/user-attachments/assets/e60de8e4-1e30-431b-af3d-7ecb99cf2e84" width="300">
<img src="https://github.com/user-attachments/assets/849f464e-f417-4c39-b23a-4f1400015d04" width="300">
<img src="https://github.com/user-attachments/assets/37ba367c-d5d3-4833-8cd9-cc76579bba48" width="300">



