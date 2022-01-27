# Hacker & Ramble

Lets you browse top stories from Hacker News. You can view news content, navigate to news source or view comments made.

- API: https://github.com/cheeaun/node-hnapi
- Built with `MVVM-C` architecture. 
- Used `UIKit` as UI framework but leveraged SwiftUI view previews to create a visual feedback loop for programmatic UIKit development.
- Dependecy injection achieved with `property wrappers`.
- Updates from viewModel to view conveyed with `Observable` binding.
- Data fetched from API is simply persisted in `UserDefaults`.
