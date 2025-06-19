# Music Player App

A modern iOS music player application built with SwiftUI and MVVM architecture, featuring a sleek dark theme and integration with the iTunes Search API.

## 🎵 Features

### Core Functionality
- **Song Search & Discovery**: Search for songs using the iTunes Search API
- **Album View**: Browse songs within albums with detailed track information
- **Music Player Interface**: Clean, modern player with navigation controls
- **Playlist Management**: Seamless navigation between songs in a playlist
- **Error Handling**: Graceful error states with retry functionality
- **Pull-to-Refresh**: Refresh song lists with swipe gesture

### User Interface
- **Dark Theme**: Consistent black background with white/gray text
- **Responsive Design**: Optimized for iOS devices with proper safe area handling
- **Loading States**: Smooth loading indicators during data fetching
- **Empty States**: User-friendly empty state views for search results
- **Bottom Sheets**: Interactive bottom sheets for additional options

### Technical Features
- **MVVM Architecture**: Clean separation of concerns with ViewModels
- **Async/Await**: Modern Swift concurrency for network operations
- **Protocol-Oriented Design**: Service layer with protocol abstractions
- **Unit Testing**: Comprehensive test coverage for ViewModels and Services
- **Mock Services**: Testable architecture with mock implementations

## 🏗️ Architecture

### Project Structure
```
MusicPlayer/
├── Core/
│   ├── Models/
│   │   ├── MusicPlayerViewState.swift
│   │   └── MusicPlayerManager.swift
│   └── Views/
│       ├── MusicPlayerErrorView.swift
│       └── MusicPlayerEmptyStateView.swift
├── Features/
│   ├── Album/
│   │   ├── Model/
│   │   ├── View/
│   │   ├── ViewModel/
│   │   └── Service/
│   ├── SongPlayer/
│   │   ├── Model/
│   │   ├── View/
│   │   └── ViewModel/
│   └── MoreOptionsBottomSheet/
│       ├── Model/
│       ├── View/
│       └── ViewModel/
├── Home/
│   ├── Model/
│   ├── View/
│   ├── ViewModel/
│   └── Service/
└── Utils/
    └── Extensions/
```

### Key Components

#### MusicPlayerManager
- Global singleton for managing playlist state
- Handles navigation between songs (previous/next)
- Maintains current song and playlist information

#### ViewModels
- **SongsViewModel**: Manages song search and pagination
- **AlbumViewModel**: Handles album data and song lists
- **SongPlayerViewModel**: Controls player state and navigation

#### Services
- **SongsService**: Fetches songs from iTunes Search API
- **AlbumService**: Retrieves album information and tracks
- All services implement protocols for testability

#### State Management
- **MusicPlayerViewState**: Enum for managing loading, error, and content states
- Consistent state handling across all views
- Error states with retry functionality

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- macOS 14.0 or later (for development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd music-player-code-challenge
   ```

2. **Open the project**
   ```bash
   open MusicPlayer/MusicPlayer.xcodeproj
   ```

3. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` or click the Run button
   - The app will launch with the Songs view

### Running Tests

1. **Run all tests**
   ```bash
   cd MusicPlayer
   xcodebuild test -scheme MusicPlayer -destination 'platform=iOS Simulator,name=iPhone 15'
   ```

2. **Run specific test classes**
   ```bash
   xcodebuild test -scheme MusicPlayer -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:MusicPlayerTests/SongsViewModelTests
   ```

## 📱 Usage

### Main Features

1. **Song Search**
   - The app opens to a searchable song list
   - Use the search bar to find specific songs or artists
   - Results are fetched from iTunes Search API
   - Pull down to refresh the song list

2. **Song Player**
   - Tap any song to open the player view
   - Navigate between songs using previous/next buttons
   - Access more options via the bottom sheet
   - View song details and duration

3. **Album View**
   - Access album view from the more options menu
   - Browse all songs in the album
   - Tap songs to play them in the player

4. **Error Handling**
   - Network errors show user-friendly messages
   - Retry buttons allow users to attempt failed operations
   - Graceful degradation for various error scenarios

## 🧪 Testing

The project includes comprehensive unit tests covering:

- **ViewModels**: State management and business logic
- **Services**: Network operations and data parsing
- **Models**: Data structures and transformations
- **Mock Services**: Testable architecture with mock implementations

### Test Structure
```
MusicPlayerTests/
├── SongsViewModelTests.swift
├── AlbumViewModelTests.swift
├── SongPlayerViewModelTests.swift
├── MusicPlayerManagerTests.swift
├── SongsServiceTests.swift
├── AlbumServiceTests.swift
├── MoreOptionsViewModelTests.swift
├── Mocks/
└── Extensions/
```

## 🔧 Technical Details

### Dependencies
- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming for data binding
- **Foundation**: Core iOS frameworks
- **URLSession**: Network operations

### API Integration
- **iTunes Search API**: For song and album data
- **RESTful endpoints**: Standard HTTP operations
- **JSON parsing**: Native Swift Codable protocol
- **Error handling**: Comprehensive error management

### Performance
- **Lazy loading**: Pagination for large song lists
- **Memory management**: Proper cleanup and weak references
- **Async operations**: Non-blocking UI updates

## 📄 License

This project is created as a code challenge and for interview process purposes.

## 👨‍💻 Author

**Cesar Giupponi**
- Created: June 19, 2025
- Architecture: MVVM with SwiftUI
