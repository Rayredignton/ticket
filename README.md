# ticket mobile test
 Ensure you have the following installed:

Flutter SDK (latest stable version)

Dart SDK (included with Flutter)
Android Studio / Xcode (for running the app on emulators/simulators)

VScode text editor

Clone the repository:
install dependencies flutter pub get

flutter run
Architecture
The application follows the MVVM (Model-View-ViewModel) pattern for better separation of concerns and testability.
Models: Defines the data structures and business logic.
ViewModels: Manages the UI logic and interacts with repositories.
Views: The UI components using Flutter widgets.
Repositories: Handles data sources (API calls, local cache).



For tests just run flutter test
