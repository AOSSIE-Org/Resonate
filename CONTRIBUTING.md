# 🎤 Resonate - Onboarding Guide for Contributors

Welcome to Resonate! This comprehensive guide will walk you through setting up the development environment for Resonate, an open-source social voice platform. Follow these steps carefully to get your local environment ready for contribution.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [System Requirements](#system-requirements)
- [Part 1: Flutter App Setup](#part-1-flutter-app-setup)
- [Part 2: Backend Setup (Appwrite + LiveKit)](#part-2-backend-setup-appwrite--livekit)
- [Running the Application](#running-the-application)
- [Troubleshooting](#troubleshooting)
- [Getting Help](#getting-help)

---

## Prerequisites

Before you begin, ensure you have the following installed on your system:

### Required Software

1. **Git** - Version control system
   - Download: https://git-scm.com/downloads
   - Verify installation: `git --version`

2. **Flutter SDK** (Latest stable version recommended)
   - Download: https://docs.flutter.dev/get-started/install
   - Recommended: Flutter 3.19 or higher
   - Verify installation: `flutter --version`

3. **Android Studio** or **VS Code**
   - Android Studio: https://developer.android.com/studio
   - VS Code: https://code.visualstudio.com/

4. **Android SDK** (for Android development)
   - Install via Android Studio
   - Minimum SDK: API 21 (Android 5.0)
   - Target SDK: API 34 or higher

5. **Xcode** (for iOS development - macOS only)
   - Install from Mac App Store
   - Minimum version: Xcode 14 or higher

6. **Node.js and npm** (for backend setup)
   - Download: https://nodejs.org/
   - Recommended: Node.js 18 LTS or higher
   - Verify: `node --version` and `npm --version`

7. **Appwrite CLI** (for backend deployment)
   - Install: `npm install -g appwrite-cli`
   - Verify: `appwrite --version`

### Optional but Recommended

- **Docker Desktop** (for local Appwrite instance)
  - Download: https://www.docker.com/products/docker-desktop
  
- **Postman** or **Thunder Client** (for API testing)

---

## System Requirements

### Minimum Hardware Requirements
- **RAM**: 8 GB (16 GB recommended)
- **Storage**: 10 GB free space
- **Processor**: Intel i5 or equivalent

### Operating Systems Supported
- Windows 10/11
- macOS 10.15 or higher
- Linux (Ubuntu 20.04 or higher)

---

## Part 1: Flutter App Setup

### Step 1: Fork and Clone the Repository

1. **Fork the repository**
   - Go to https://github.com/AOSSIE-Org/Resonate
   - Click the "Fork" button in the top right corner
   - This creates a copy in your GitHub account

2. **Clone your forked repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/Resonate.git
   cd Resonate
   ```

3. **Add upstream remote** (to sync with main repo)
   ```bash
   git remote add upstream https://github.com/AOSSIE-Org/Resonate.git
   git remote -v  # Verify remotes
   ```

### Step 2: Install Flutter Dependencies

1. **Check Flutter installation**
   ```bash
   flutter doctor -v
   ```
   - This command checks your Flutter environment and displays issues
   - Fix any issues reported before proceeding

2. **Clean and get dependencies**
   ```bash
   # Clean previous builds (if any)
   flutter clean
   
   # Get all packages
   flutter pub get
   ```

3. **Verify dependencies installation**
   ```bash
   flutter pub outdated  # Check for outdated packages
   ```

### Step 3: Configure Android Setup

1. **Accept Android licenses**
   ```bash
   flutter doctor --android-licenses
   ```
   Accept all licenses by typing 'y'

2. **Configure Android SDK** (if needed)
   - Open Android Studio
   - Go to: Settings > Appearance & Behavior > System Settings > Android SDK
   - Ensure the following are installed:
     - Android SDK Platform 34 (or latest)
     - Android SDK Build-Tools
     - Android SDK Command-line Tools
     - Android SDK Platform-Tools
     - Android Emulator

3. **Create Android Virtual Device (AVD)**
   - Open Android Studio > Device Manager
   - Click "Create Device"
   - Select a device (e.g., Pixel 5)
   - Select system image (API 34 recommended)
   - Finish setup

### Step 4: Configure iOS Setup (macOS only)

1. **Install Xcode Command Line Tools**
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

2. **Install CocoaPods**
   ```bash
   sudo gem install cocoapods
   ```

3. **Setup iOS dependencies**
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. **Open iOS Simulator**
   ```bash
   open -a Simulator
   ```

### Step 5: Project Configuration

1. **Create environment configuration file**
   
   Create a file named `.env` in the project root (if not exists):
   ```bash
   touch .env
   ```

2. **Configure the `.env` file** (you'll add values after backend setup):
   ```env
   # Appwrite Configuration
   APPWRITE_ENDPOINT=your_appwrite_endpoint
   APPWRITE_PROJECT_ID=your_project_id
   
   # LiveKit Configuration
   LIVEKIT_URL=your_livekit_url
   ```

---

## Part 2: Backend Setup (Appwrite + LiveKit)

### Option A: Using Appwrite Cloud (Recommended for Beginners)

#### Step 1: Create Appwrite Account

1. Go to https://cloud.appwrite.io/
2. Sign up for a free account
3. Create a new project
4. Note down your:
   - **Project ID**
   - **Endpoint** (usually `https://cloud.appwrite.io/v1`)
   - **API Endpoint**

#### Step 2: Configure Appwrite Project

1. **Create Platform**
   - In your Appwrite project, go to "Settings" > "Platforms"
   - Click "Add Platform"
   - Select your platform:
     - For **Android**: 
       - Name: `Resonate Android`
       - Package Name: `com.resonate.resonate`
     - For **iOS**:
       - Name: `Resonate iOS`
       - Bundle ID: `com.resonate.resonate`
     - For **Web** (optional):
       - Name: `Resonate Web`
       - Hostname: `localhost`

2. **Generate API Key**
   - Go to "Settings" > "API Keys"
   - Click "Create API Key"
   - Give it a name (e.g., "Backend Functions")
   - Select scopes (All scopes for development)
   - Copy and save the API Key securely

#### Step 3: Setup LiveKit

1. **Create LiveKit Cloud Account**
   - Go to https://livekit.io/cloud
   - Sign up for a free account
   - Create a new project

2. **Get LiveKit Credentials**
   - Go to your project settings
   - Copy the following:
     - **LiveKit URL/Host** (e.g., `wss://your-project.livekit.cloud`)
     - **API Key**
     - **API Secret**
   - Keep these credentials secure

3. **Configure LiveKit Webhook** (Optional but recommended)
   - In LiveKit dashboard, go to Settings > Webhooks
   - Add webhook URL: `https://[your-appwrite-endpoint]/v1/functions/[livekit-webhook-function-id]/executions`

#### Step 4: Deploy Backend Functions

1. **Clone Backend Repository**
   ```bash
   cd ..  # Go back to parent directory
   git clone https://github.com/AOSSIE-Org/Resonate-Backend.git
   cd Resonate-Backend
   ```

2. **Install Appwrite CLI** (if not already installed)
   ```bash
   npm install -g appwrite-cli
   ```

3. **Login to Appwrite CLI**
   ```bash
   appwrite login
   ```
   Follow the prompts to authenticate with your Appwrite account

4. **Initialize Appwrite Project**
   ```bash
   appwrite init project
   ```
   - Select your project from the list
   - Configure endpoint if needed

5. **Configure Environment Variables for Functions**
   
   Edit the function configuration files to add your LiveKit credentials:
   
   For each function that requires LiveKit (check `appwrite.json`), you'll need to set:
   - `LIVEKIT_HOST`: Your LiveKit URL
   - `LIVEKIT_API_KEY`: Your LiveKit API Key
   - `LIVEKIT_API_SECRET`: Your LiveKit API Secret

6. **Deploy Functions**
   
   **Option 1: Deploy all functions at once**
   ```bash
   appwrite deploy function
   ```

   **Option 2: Deploy individual functions**
   ```bash
   # Deploy room creation function
   appwrite deploy function --functionId create-room
   
   # Deploy other functions similarly
   appwrite deploy function --functionId join-room
   appwrite deploy function --functionId delete-room
   appwrite deploy function --functionId livekit-webhook
   appwrite deploy function --functionId match-maker
   appwrite deploy function --functionId send-otp
   appwrite deploy function --functionId verify-otp
   appwrite deploy function --functionId verify-email
   appwrite deploy function --functionId discussion-isTime-checker
   appwrite deploy function --functionId database-cleaner
   ```

7. **Run the automated setup script** (Recommended)
   
   **For Linux/macOS:**
   ```bash
   chmod +x init.sh
   ./init.sh
   ```

   **For Windows (PowerShell):**
   ```powershell
   .\init.ps1
   ```

   This script will automatically:
   - Set up Appwrite collections
   - Configure database schemas
   - Deploy cloud functions
   - Set up authentication

#### Step 5: Configure Database Collections

The Appwrite backend requires several collections. The `init.sh` script creates them, but here's what they are:

1. **Users Collection**: User profiles and data
2. **Rooms Collection**: Room/discussion data
3. **Stories Collection**: Story content
4. **Chapters Collection**: Chapter data for stories
5. **Participants Collection**: Active room participants
6. **Pairs Collection**: Pair chat data
7. **Notifications Collection**: User notifications

### Option B: Self-Hosted Appwrite (Advanced Users)

If you prefer to run Appwrite locally:

1. **Install Docker Desktop**
   - Download from https://www.docker.com/products/docker-desktop

2. **Run Appwrite using Docker**
   ```bash
   docker run -it --rm \
       --volume /var/run/docker.sock:/var/run/docker.sock \
       --volume "$(pwd)"/appwrite:/usr/src/code/appwrite:rw \
       --entrypoint="install" \
       appwrite/appwrite:latest
   ```

3. **Access Appwrite Console**
   - Open http://localhost
   - Complete the setup wizard
   - Create your first project

4. **Follow the same steps as Option A** for project configuration and function deployment

#### Step 6: Update Flutter App Configuration

1. **Go back to the Flutter app directory**
   ```bash
   cd ../Resonate
   ```

2. **Update the `.env` file** with your credentials:
   ```env
   APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
   APPWRITE_PROJECT_ID=your_project_id_here
   LIVEKIT_URL=wss://your-project.livekit.cloud
   ```

3. **Create/Update configuration files**
   
   Check if your app has a configuration file (usually in `lib/utils/constants.dart` or similar):
   ```dart
   class AppwriteConstants {
     static const String endpoint = 'YOUR_APPWRITE_ENDPOINT';
     static const String projectId = 'YOUR_PROJECT_ID';
   }
   
   class LivekitConstants {
     static const String url = 'YOUR_LIVEKIT_URL';
   }
   ```

---

## Running the Application

### Step 1: Start the Development Environment

1. **Start an emulator or connect a physical device**
   
   **For Android:**
   ```bash
   # List available emulators
   flutter emulators
   
   # Start a specific emulator
   flutter emulators --launch <emulator_id>
   
   # Or start from Android Studio: Tools > Device Manager > Run
   ```

   **For iOS (macOS only):**
   ```bash
   open -a Simulator
   ```

   **For Physical Device:**
   - Enable Developer Options and USB Debugging (Android)
   - Trust the computer (iOS)
   - Connect via USB
   - Verify: `flutter devices`

### Step 2: Run the Application

1. **Check connected devices**
   ```bash
   flutter devices
   ```

2. **Run the app**
   ```bash
   # Run in debug mode
   flutter run
   
   # Run in release mode
   flutter run --release
   
   # Run on a specific device
   flutter run -d <device_id>
   ```

3. **Hot reload during development**
   - Press `r` in the terminal for hot reload
   - Press `R` for hot restart
   - Press `q` to quit

### Step 3: Verify Everything Works

1. **Test basic functionality:**
   - App launches successfully
   - You can create an account
   - Authentication works
   - You can navigate through the app

2. **Test voice features:**
   - Create a room
   - Join a room
   - Test audio permissions
   - Verify LiveKit connection

---

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: Flutter Doctor Shows Errors

**Problem:** `flutter doctor` shows red X marks

**Solution:**
```bash
# For Android toolchain issues
flutter doctor --android-licenses

# For missing dependencies
flutter doctor -v  # Shows detailed info

# Update Flutter
flutter upgrade
```

#### Issue 2: Gradle Build Failures (Android)

**Problem:** Build fails with Gradle errors

**Solution:**
```bash
# Clean the project
flutter clean

# Navigate to android folder
cd android

# Clean Gradle
./gradlew clean

# Go back and rebuild
cd ..
flutter pub get
flutter run
```

#### Issue 3: Pod Install Failures (iOS)

**Problem:** CocoaPods installation fails

**Solution:**
```bash
cd ios

# Update pod repo
pod repo update

# Clean pods
rm -rf Pods Podfile.lock

# Reinstall
pod install

cd ..
```

#### Issue 4: Appwrite Connection Issues

**Problem:** Cannot connect to Appwrite

**Solution:**
1. Verify your endpoint URL is correct
2. Check if project ID matches
3. Ensure platform is properly configured in Appwrite console
4. Check firewall settings
5. For self-hosted: Verify Docker containers are running (`docker ps`)

#### Issue 5: LiveKit Connection Failures

**Problem:** Unable to join voice rooms

**Solution:**
1. Verify LiveKit credentials are correct
2. Check if WebSocket connection is allowed
3. Test with LiveKit's example app first
4. Verify microphone permissions are granted
5. Check network firewall settings

#### Issue 6: Build Number Conflicts

**Problem:** App won't install due to version conflict

**Solution:**
```bash
# Uninstall previous version
flutter clean

# On Android device/emulator
adb uninstall com.resonate.resonate

# Reinstall
flutter run
```

#### Issue 7: Missing Dependencies

**Problem:** Package dependencies not resolving

**Solution:**
```bash
# Remove lock file
rm pubspec.lock

# Clear pub cache
flutter pub cache repair

# Get dependencies again
flutter pub get
```

### Getting Detailed Error Logs

```bash
# Run with verbose logging
flutter run -v

# For specific device logs
# Android:
adb logcat

# iOS:
xcrun simctl spawn booted log stream --predicate 'eventMessage contains "flutter"'
```

---

## Development Workflow

### Before Making Changes

1. **Sync with upstream**
   ```bash
   git fetch upstream
   git checkout dev
   git merge upstream/dev
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

### Making Changes

1. Make your code changes
2. Test thoroughly on both Android and iOS (if possible)
3. Follow the project's coding standards
4. Write meaningful commit messages

### Code Quality Checks

```bash
# Check for formatting issues
flutter format .

# Run static analysis
flutter analyze

# Run tests
flutter test
```

### Submitting Changes

1. **Push to your fork**
   ```bash
   git add .
   git commit -m "feat: your feature description"
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request**
   - Go to your fork on GitHub
   - Click "New Pull Request"
   - Set base repository: `AOSSIE-Org/Resonate`
   - Set base branch: `dev`
   - Fill in the PR template
   - Submit for review

---

## Getting Help

### Communication Channels

- **Discord**: https://discord.gg/MMZBadkYFm
- **Email**: aossie.oss@gmail.com
- **GitHub Issues**: https://github.com/AOSSIE-Org/Resonate/issues
- **GitHub Discussions**: https://github.com/AOSSIE-Org/Resonate/discussions

### Resources

- **Contribution Guidelines**: [CONTRIBUTING.md](CONTRIBUTING.md)
- **Code of Conduct**: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
- **Flutter Documentation**: https://docs.flutter.dev/
- **Appwrite Documentation**: https://appwrite.io/docs
- **LiveKit Documentation**: https://docs.livekit.io/

### Tips for New Contributors

1. **Start Small**: Look for issues labeled `good first issue`
2. **Ask Questions**: Don't hesitate to ask in Discord
3. **Read Existing Code**: Understand the project structure
4. **Test Your Changes**: Always test on multiple devices
5. **Be Patient**: Code review takes time

---

## Next Steps

Now that your environment is set up:

1. ✅ Explore the codebase structure
2. ✅ Check [open issues](https://github.com/AOSSIE-Org/Resonate/issues)
3. ✅ Join our [Discord community](https://discord.gg/MMZBadkYFm)
4. ✅ Read the [Contributing Guidelines](CONTRIBUTING.md)
5. ✅ Make your first contribution!

---

## Additional Notes

### Project Structure
```
Resonate/
├── android/          # Android native code
├── ios/              # iOS native code
├── lib/              # Main Dart code
│   ├── models/       # Data models
│   ├── views/        # UI screens
│   ├── controllers/  # Business logic
│   ├── utils/        # Utility functions
│   └── main.dart     # Entry point
├── test/             # Test files
├── assets/           # Images, fonts, etc.
└── pubspec.yaml      # Dependencies
```

### Useful Commands Reference

```bash
# Flutter Commands
flutter doctor          # Check installation
flutter devices         # List devices
flutter run             # Run app
flutter build apk       # Build Android APK
flutter build ipa       # Build iOS IPA
flutter clean           # Clean build files
flutter pub get         # Get dependencies
flutter pub upgrade     # Upgrade dependencies
flutter analyze         # Static analysis
flutter test            # Run tests

# Git Commands
git status              # Check changes
git log --oneline       # View commit history
git branch              # List branches
git checkout -b branch  # Create new branch
git pull upstream dev   # Pull from upstream
git push origin branch  # Push to your fork

# Appwrite Commands
appwrite login          # Login to Appwrite
appwrite deploy         # Deploy functions
appwrite init           # Initialize project
```

---

**Happy Contributing! 🎉**

Thank you for contributing to Resonate. Together, we're building an amazing open-source voice platform!