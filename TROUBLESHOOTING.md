# Troubleshooting Guide for Resonate

This guide helps you resolve common issues when setting up and running Resonate.

## 📋 Quick Diagnostic Checklist

Before diving into specific issues, run these checks:

```bash
# 1. Verify Flutter
flutter doctor -v

# 2. Verify Docker (if setting up backend)
docker ps

# 3. Verify Git
git --version

# 4. Check connected devices
flutter devices
```

---

## 🐳 Docker Issues

### "Docker daemon is not running"

**Symptoms:** `Cannot connect to the Docker daemon`

**Solutions:**
```bash
# Check if Docker is running
docker ps

# Start Docker Desktop
# Windows/Mac: Open Docker Desktop from Start Menu/Applications
# Linux: sudo systemctl start docker
```

### "Port 80 is already in use"

**Symptoms:** `Error starting userland proxy: listen tcp 0.0.0.0:80: bind: address already in use`

**Solutions:**
1. Find what's using port 80:
   ```bash
   # Windows
   netstat -ano | findstr :80
   
   # Mac/Linux
   lsof -i :80
   ```
2. Stop the conflicting service (common culprits: Apache, IIS, Skype)
3. Or configure Appwrite to use a different port

### "Cannot connect to Docker daemon"

**Symptoms:** `error during connect: ... Is the docker daemon running?`

**Solutions:**
1. Ensure Docker Desktop is running (check system tray/menu bar for Docker icon)
2. Wait for Docker to fully initialize (icon should be green/stable)
3. Restart Docker Desktop if needed
4. On Linux, ensure your user is in the docker group:
   ```bash
   sudo usermod -aG docker $USER
   # Then log out and log back in
   ```

---

## 🔌 Backend Connection Issues

### "Failed to connect to Appwrite"

**Symptoms:** App shows "Connection Error" or "Failed to connect to backend"

**Diagnostic Steps:**
```bash
# 1. Check if Appwrite container is running
docker ps | grep appwrite

# 2. Check Appwrite logs
docker logs appwrite

# 3. Verify you can access Appwrite console
# Open http://localhost:80 in browser
```

**Solutions:**
1. Restart Appwrite container:
   ```bash
   docker restart appwrite
   ```
2. Verify `baseDomain` in `lib/utils/constants.dart` matches your setup:
   - Android Emulator: `10.0.2.2`
   - iOS Simulator: `localhost`
   - Physical Device: Your computer's IP address
3. Check firewall isn't blocking port 80

### "Connection refused from Android Emulator"

**Symptoms:** App can't connect even with `baseDomain` set to `10.0.2.2`

**Solutions:**
1. Use ADB reverse to forward ports:
   ```bash
   adb reverse tcp:80 tcp:80
   adb reverse tcp:7880 tcp:7880
   ```
2. Try using your computer's actual IP address instead of `10.0.2.2`
3. Some AVD emulators have networking issues - try creating a new emulator

### "Cannot connect from physical device"

**Symptoms:** Works on emulator but not on real phone

**Solutions:**
1. **Ensure same WiFi network:**
   - Phone and computer must be on the same WiFi
   - Corporate/university networks may block device-to-device communication
   
2. **Find your computer's IP:**
   ```bash
   # Windows
   ipconfig
   # Look for "IPv4 Address" under WiFi adapter
   
   # Mac/Linux
   ifconfig
   # OR
   ip addr
   # Look for inet address (usually 192.168.x.x)
   ```

3. **Update baseDomain:**
   ```bash
   flutter run --dart-define=APPWRITE_BASE_DOMAIN=192.168.1.100
   # Replace with your actual IP
   ```

4. **Check firewall:**
   - **Windows:** Windows Defender Firewall → Allow app → Allow ports 80, 7880
   - **macOS:** System Preferences → Security & Privacy → Firewall Options
   - **Linux:** `sudo ufw allow 80 && sudo ufw allow 7880`

5. **Test connectivity:**
   ```bash
   # From your phone's browser, visit:
   http://YOUR_COMPUTER_IP:80
   # You should see Appwrite login page
   ```

---

## 📱 Device & Build Issues

### "No devices detected"

**Symptoms:** `flutter devices` shows no devices

**Solutions:**

**Android:**
1. Enable Developer Options:
   - Settings → About Phone → Tap "Build Number" 7 times
2. Enable USB Debugging:
   - Settings → Developer Options → USB Debugging
3. Try different USB cable (some cables are charge-only)
4. Accept authorization prompt on phone
5. Verify device is detected:
   ```bash
   adb devices
   ```

**iOS:**
1. Trust the computer on your iPhone/iPad
2. Ensure Xcode is installed (macOS only)
3. Open Xcode and add your Apple ID

### "Android build fails"

**Symptoms:** Gradle build errors, dependency conflicts

**Solutions:**
```bash
# 1. Clear Gradle cache
cd android
./gradlew clean
cd ..

# 2. Clean Flutter build
flutter clean
flutter pub get

# 3. If still failing, try:
cd android
./gradlew --stop  # Stop Gradle daemon
rm -rf .gradle    # Remove Gradle cache
cd ..

# 4. Rebuild
flutter run
```

**Common Gradle Errors:**
- **"Android license not accepted"**
  ```bash
  flutter doctor --android-licenses
  # Type 'y' to accept all
  ```

- **"SDK location not found"**
  - Create `android/local.properties`:
    ```properties
    sdk.dir=C:\\Users\\YOUR_USERNAME\\AppData\\Local\\Android\\Sdk
    ```
  - On Mac/Linux:
    ```properties
    sdk.dir=/Users/YOUR_USERNAME/Library/Android/sdk
    ```

### "iOS build fails"

**Symptoms:** CocoaPods errors, signing errors

**Solutions:**
```bash
# 1. Update CocoaPods
sudo gem install cocoapods

# 2. Clean pod cache
cd ios
rm -rf Pods
rm Podfile.lock
pod repo update
pod install
cd ..

# 3. Clean Flutter
flutter clean
flutter pub get

# 4. Try again
flutter run
```

**Common iOS Errors:**
- **"CocoaPods not installed"**
  ```bash
  sudo gem install cocoapods
  ```

- **"Signing requires a development team"**
  - Open `ios/Runner.xcworkspace` in Xcode
  - Select Runner → Signing & Capabilities
  - Select your Team (or add Apple ID)

### "Build gets stuck or hangs"

**Symptoms:** Build process hangs at specific percentage

**Solutions:**
```bash
# 1. Kill Gradle daemon (Android)
cd android
./gradlew --stop
cd ..

# 2. Kill Flutter processes
# Windows
taskkill /F /IM dart.exe
taskkill /F /IM flutter.exe

# Mac/Linux
pkill -9 dart
pkill -9 flutter

# 3. Clean everything
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get

# 4. Rebuild with verbose output
flutter run -v
```

---

## ⚙️ Appwrite Setup Issues

### "Cannot access localhost:80"

**Symptoms:** Browser can't load Appwrite console

**Diagnostic:**
```bash
# Check if Appwrite container is running
docker ps

# Check Appwrite logs for errors
docker logs appwrite

# Check if port 80 is being used
# Windows
netstat -ano | findstr :80

# Mac/Linux
lsof -i :80
```

**Solutions:**
1. Start Appwrite:
   ```bash
   docker start appwrite
   ```
2. Restart Appwrite:
   ```bash
   docker restart appwrite
   ```
3. If still not working, re-run the setup script
4. Try accessing with `http://127.0.0.1:80` instead of `localhost`

### "Team ID not found"

**Symptoms:** Setup script asks for Team ID but you can't find it

**Solution:**
1. Go to [http://localhost:80](http://localhost:80)
2. Login with your account
3. Look at the browser URL bar
4. The Team ID is the long string at the end:
   ```
   http://localhost:80/console/team/666ce18b003caf6274b6
                                    ^^^^^^^^^^^^^^^^^^^^^^^^
                                         This is your Team ID
   ```
5. If URL doesn't show team ID, click on your team name/settings

### "Collections/Buckets not created"

**Symptoms:** Appwrite console shows empty project

**Solutions:**
1. Check if setup script completed successfully
2. Re-run the setup script (it handles partial completions)
3. Manually verify in Appwrite console:
   - Databases → Check for collections
   - Storage → Check for buckets
   - Functions → Check for deployed functions

### "Script fails during setup"

**Symptoms:** Setup script exits with error

**Solutions:**
1. Read the error message carefully
2. Check [Resonate-Backend Issues](https://github.com/AOSSIE-Org/Resonate-Backend/issues)
3. Common fixes:
   ```bash
   # Ensure Docker is running
   docker ps
   
   # Make script executable (Linux/Mac)
   chmod +x init.sh
   sudo ./init.sh
   
   # Run as Administrator (Windows)
   # Right-click PowerShell → Run as Administrator
   ./init.ps1
   ```
4. Try running the script again (it's designed to be re-runnable)

---

## 🎤 LiveKit Issues

### "LiveKit connection failed"

**Symptoms:** Can't join or create audio rooms

**Diagnostic:**
```bash
# For self-hosted LiveKit:
docker ps | grep livekit

# Check LiveKit logs
docker logs livekit
```

**Solutions:**
1. Verify LiveKit is running:
   ```bash
   docker restart livekit
   ```
2. Check LiveKit endpoint configuration in Appwrite Functions
3. Verify WebRTC ports aren't blocked by firewall
4. For cloud LiveKit: Verify API key and secret are correct

### "Audio rooms show but can't connect"

**Symptoms:** Rooms visible but joining fails

**Solutions:**
1. Check LiveKit URL in constants.dart
2. Verify LiveKit container is healthy:
   ```bash
   docker logs livekit --tail 50
   ```
3. Ensure firewall allows UDP ports (LiveKit uses WebRTC)
4. Check browser/app permissions for microphone

---

## 🔍 Meilisearch Issues

### "Search not working"

**Symptoms:** Search returns no results or errors

**Diagnostic:**
```bash
# Check if Meilisearch is enabled
# In lib/utils/constants.dart
const bool isUsingMeilisearch = ...

# Check Meilisearch container
docker ps | grep meilisearch
```

**Solutions:**
1. Enable Meilisearch in app:
   ```dart
   // In lib/utils/constants.dart
   const bool isUsingMeilisearch = true;
   ```
   Or:
   ```bash
   flutter run --dart-define=USE_MEILISEARCH=true
   ```
2. Verify Meilisearch is running:
   ```bash
   docker restart meilisearch
   ```
3. Check Meilisearch logs:
   ```bash
   docker logs meilisearch
   ```
4. Verify API key and endpoint in constants.dart

---

## 🔧 Flutter Issues

### "Package version conflicts"

**Symptoms:** `pub get failed` or dependency resolution errors

**Solutions:**
```bash
# 1. Clean pub cache
flutter pub cache repair

# 2. Clean project
flutter clean

# 3. Get dependencies
flutter pub get

# 4. If still failing, check Flutter version
flutter --version
# Ensure you have Flutter 3.24.0 or higher

# 5. Upgrade Flutter if needed
flutter upgrade
```

### "Hot reload not working"

**Symptoms:** Changes don't appear when saving files

**Solutions:**
1. Try hot restart instead: Press `R` in terminal (or click hot restart in IDE)
2. Some changes require full restart:
   ```bash
   # Stop the app (Ctrl+C)
   flutter run
   ```
3. Check IDE Flutter plugin is up to date
4. Try running with `--hot` flag explicitly:
   ```bash
   flutter run --hot
   ```

### "White screen / Black screen on launch"

**Symptoms:** App shows blank screen after splash

**Solutions:**
1. Check console for errors:
   ```bash
   flutter run -v
   ```
2. Common causes:
   - Backend not connected properly
   - Initialization error in main.dart
   - Missing assets or permissions
3. Try debug mode:
   ```bash
   flutter run --debug
   ```

---

## 🔄 General Tips & Best Practices

### After Pulling New Code

Always run:
```bash
flutter clean
flutter pub get
```

For iOS:
```bash
cd ios
pod install
cd ..
```

### Before Asking for Help

1. **Check error messages** - They usually tell you what's wrong
2. **Search existing issues** - Your problem might already be solved
3. **Provide details:**
   - Operating system and version
   - Flutter version (`flutter --version`)
   - Complete error message
   - Steps to reproduce

### Performance Issues

**App running slowly:**
1. Use release mode for better performance:
   ```bash
   flutter run --release
   ```
2. Close other Docker containers if low on RAM
3. Use lighter IDE (VS Code instead of Android Studio)
4. Allocate more RAM to emulator

**Build taking too long:**
1. Enable Gradle daemon (Android):
   ```properties
   # In android/gradle.properties
   org.gradle.daemon=true
   org.gradle.parallel=true
   org.gradle.jvmargs=-Xmx4096m
   ```
2. Use `flutter run` without clean unless necessary
3. Close unnecessary applications

---

## 🆘 Getting Help

If you're still stuck after trying these solutions:

### Community Support

- 💬 **Discord:** [Join our server](https://discord.gg/MMZBadkYFm)
  - Get real-time help from maintainers and contributors
  - Search previous conversations for similar issues
  
- 🐛 **GitHub Issues:** [Create an issue](https://github.com/AOSSIE-Org/Resonate/issues)
  - Use issue templates
  - Include all relevant information
  - Be specific about your problem

### Before Posting

Include this information:
```
**Environment:**
- OS: [Windows 11 / macOS 14 / Ubuntu 22.04]
- Flutter version: [run `flutter --version`]
- Docker version: [run `docker --version`]
- Device: [Android Emulator / iOS Simulator / Physical Device]

**What I'm trying to do:**
[Describe your goal]

**What's happening:**
[Describe the problem]

**Error messages:**
```
[Paste complete error output]
```

**What I've tried:**
[List solutions you've already attempted]
```

### Official Channels

- 📧 **Email:** aossie.oss@gmail.com
- 📖 **Documentation:** Check [README.md](README.md) and [ONBOARDING.md](ONBOARDING.md)
- 📚 **Contributing:** See [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📚 Additional Resources

### Official Documentation
- [Flutter Docs](https://docs.flutter.dev/)
- [Appwrite Docs](https://appwrite.io/docs)
- [LiveKit Docs](https://docs.livekit.io/)
- [Docker Docs](https://docs.docker.com/)
- [Meilisearch Docs](https://docs.meilisearch.com/)

### Useful Commands Reference

```bash
# Flutter
flutter doctor -v           # Check Flutter installation
flutter clean              # Clean build cache
flutter pub get            # Get dependencies
flutter devices            # List available devices
flutter run -v             # Run with verbose output

# Docker
docker ps                  # List running containers
docker ps -a               # List all containers
docker logs CONTAINER      # View container logs
docker restart CONTAINER   # Restart container
docker stop CONTAINER      # Stop container
docker rm CONTAINER        # Remove container

# Git
git status                 # Check repo status
git pull origin dev        # Pull latest changes
git checkout -b BRANCH     # Create new branch
```

---

**Remember:** Most issues are common and solvable! Don't hesitate to ask for help in our friendly community. 🤝
