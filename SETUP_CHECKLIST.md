📋 Resonate Setup Checklist
Use this checklist to ensure you've completed all setup steps correctly.

Pre-Setup Requirements
 Git installed (git --version)
 Flutter SDK installed (flutter --version)
 Android Studio or VS Code installed
 Android SDK installed (API 21+)
 Xcode installed (macOS only, for iOS)
 Node.js and npm installed (node --version, npm --version)
 Appwrite CLI installed (appwrite --version)
Part 1: Flutter App Setup
Repository Setup
 Forked the repository on GitHub
 Cloned your fork locally
 Added upstream remote
 Verified remotes with git remote -v
Flutter Configuration
 Ran flutter doctor (all checks pass)
 Ran flutter clean
 Ran flutter pub get (no errors)
 Accepted Android licenses (flutter doctor --android-licenses)
Device Setup
 Android emulator created OR physical device connected
 iOS simulator installed (macOS only)
 Device shows in flutter devices
Environment Configuration
 Created .env file in project root
 Added Appwrite configuration (will update after backend setup)
 Added LiveKit configuration (will update after backend setup)
Part 2: Backend Setup
Appwrite Account
 Created Appwrite Cloud account
 Created new project
 Noted Project ID
 Noted Endpoint URL
Appwrite Platform Configuration
 Added Android platform (package: com.resonate.resonate)
 Added iOS platform (bundle: com.resonate.resonate)
 Generated API Key
 Saved API Key securely
LiveKit Setup
 Created LiveKit Cloud account
 Created new project
 Noted LiveKit URL
 Noted API Key
 Noted API Secret
 Saved credentials securely
Backend Repository
 Cloned Resonate-Backend repository
 Logged into Appwrite CLI (appwrite login)
 Initialized Appwrite project (appwrite init project)
 Configured environment variables for functions
 Ran setup script (./init.sh or .\init.ps1)
 Deployed all cloud functions
Database Collections
 Users collection created
 Rooms collection created
 Stories collection created
 Chapters collection created
 Participants collection created
 Pairs collection created
 Notifications collection created
Updated Flutter Configuration
 Updated .env file with Appwrite credentials
 Updated .env file with LiveKit credentials
 Verified configuration in code files
Part 3: Running the App
First Run
 Started emulator/simulator or connected device
 Verified device in flutter devices
 Ran flutter run successfully
 App launched without errors
 Can navigate through app screens
Feature Testing
 Can create an account
 Authentication works
 Can create a room
 Can join a room
 Audio permissions granted
 LiveKit connection works
 Can send/receive audio
Troubleshooting (If Needed)
If you encounter issues:

 Checked Troubleshooting section in ONBOARDING.md
 Ran flutter clean and flutter pub get
 Restarted IDE/editor
 Restarted emulator/device
 Checked error logs
 Asked for help in Discord
Final Steps
 Read CONTRIBUTING.md
 Read CODE_OF_CONDUCT.md
 Joined Discord server
 Found a "good first issue" to work on
 Created a feature branch for your work
Quick Command Reference
bash
# Flutter Commands
flutter doctor              # Check setup
flutter clean               # Clean build
flutter pub get             # Get dependencies
flutter run                 # Run app
flutter run -v              # Run with verbose logging

# Git Commands
git status                  # Check status
git pull upstream dev       # Sync with upstream
git checkout -b feature/name # Create branch
git add .                   # Stage changes
git commit -m "message"     # Commit
git push origin branch      # Push to fork

# Appwrite Commands
appwrite login              # Login to Appwrite
appwrite deploy function    # Deploy functions
Success Criteria
✅ You're ready to contribute when:

App runs without errors
You can create and join rooms
Audio features work
You understand the project structure
You've read the contribution guidelines
Need Help?
Discord: https://discord.gg/MMZBadkYFm
Email: aossie.oss@gmail.com
Issues: https://github.com/AOSSIE-Org/Resonate/issues
Congratulations on completing the setup! Happy coding! 🎉

