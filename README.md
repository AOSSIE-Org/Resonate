# 🎤 Resonate - An Open Source Social Voice Platform

<div align="center">

![Resonate Logo](assets/images/aossie_logo.png)

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL-yellow.svg)](https://opensource.org/license/gpl-3-0/)
[![GitHub Stars](https://img.shields.io/github/stars/AOSSIE-Org/Resonate?style=social)](https://github.com/AOSSIE-Org/Resonate/stargazers)
[![Get it on Google Play](https://img.shields.io/badge/Get_it_on-Google_Play-00C851?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=com.resonate.resonate)

**Powered by:**

[![Appwrite](https://img.shields.io/badge/Appwrite-F02E65?style=for-the-badge&logo=appwrite&logoColor=white)](https://appwrite.io)
[![LiveKit](https://img.shields.io/badge/LiveKit-00ADD8?style=for-the-badge)](https://livekit.io)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)

</div>

---

## 📖 About Resonate

With social voice platforms like Spotify, Clubhouse, and Twitter Spaces experiencing rapid growth, **Resonate** harnesses the power of open-source for voice-based social media. Whether it's sharing immersive stories, engaging in dynamic live discussions, or connecting through pair chats and voice calls, Resonate is designed to put voice at the center of your social experience.

By fostering innovation and growth, this project aims to reach new heights, continually expanding its features and community, all while staying true to the open-source spirit of collaboration and transparency.

---

## ✨ Features

### Current Features

🎙️ **Real-time Audio Rooms**
- Join voice rooms and talk to people in real-time
- Create your own rooms with custom settings
- Moderate speakers and manage room events

📅 **Scheduled Rooms**
- Create scheduled discussions
- Notify subscribers with reminders
- Never miss important conversations

📚 **Audio Stories** *(Work in Progress)*
- Listen to stories as chapters with synced lyrics
- Browse through entire catalog of stories
- Follow your favorite creators
- Wait for latest chapter/story releases
- Post your own stories with chapters

👥 **Pair Chat**
- Find random partners to talk to
- One-on-one voice conversations
- Meet new people in the community

🎨 **Customizable Themes**
- Multiple theme options: Forest, Amber, Classic, Cream, Time, Vintage
- Personalize your app experience

🌍 **Multi-language Support**
- Available in multiple languages
- Easy translation contribution

### Coming Soon

✅ Friend profiles and connections
✅ Direct voice calls and messaging
✅ Enhanced story marketplace
✅ Advanced search and discovery

---

## 🏗️ Architecture

Resonate is built using modern, scalable technologies:

- **Frontend**: Flutter (Dart) - Cross-platform mobile application
- **Backend**: Appwrite - Authentication, Database, Storage, Cloud Functions
- **Real-time Communication**: LiveKit - WebRTC for voice/video
- **State Management**: GetX / Provider
- **Database**: Appwrite Database Collections

---

## 🚀 Quick Start for New Contributors

### Prerequisites

Before you begin, make sure you have:

- ✅ **Flutter SDK** (3.19 or higher) - [Install Guide](https://docs.flutter.dev/get-started/install)
- ✅ **Git** - [Download](https://git-scm.com/downloads)
- ✅ **Android Studio** or **VS Code** with Flutter extensions
- ✅ **Node.js & npm** (for backend) - [Download](https://nodejs.org/)
- ✅ **Appwrite CLI** - Install: `npm install -g appwrite-cli`

### Quick Setup (5 Minutes)

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/Resonate.git
cd Resonate

# 2. Install dependencies
flutter pub get

# 3. Check your Flutter setup
flutter doctor

# 4. Run the app
flutter run
```

### Full Setup Guide

For detailed setup instructions including backend configuration, please refer to our comprehensive **[Onboarding Guide](ONBOARDING.md)**.

The onboarding guide covers:
- 📦 Complete environment setup
- 🔧 Backend configuration (Appwrite + LiveKit)
- 🐛 Troubleshooting common issues
- 💻 Development workflow
- 🤝 Contribution guidelines

---

## 📂 Project Structure

```
Resonate/
├── android/                 # Android native code
├── ios/                     # iOS native code
├── lib/
│   ├── main.dart           # Application entry point
│   ├── models/             # Data models
│   ├── views/              # UI screens and widgets
│   │   ├── screens/        # Main app screens
│   │   └── widgets/        # Reusable widgets
│   ├── controllers/        # Business logic (GetX/Provider)
│   ├── services/           # API and service classes
│   ├── utils/              # Utility functions and constants
│   ├── routes/             # App routing
│   └── themes/             # Theme configurations
├── assets/
│   ├── images/             # Image assets
│   ├── icons/              # App icons
│   └── translations/       # Localization files
├── test/                   # Unit and widget tests
├── docs/                   # Documentation
├── pubspec.yaml            # Dependencies
└── README.md               # This file
```

---

## 🔗 Repository Links

This project consists of two main repositories:

1. **[Resonate Flutter App](https://github.com/AOSSIE-Org/Resonate)** - Mobile application (This repo)
2. **[Resonate Backend](https://github.com/AOSSIE-Org/Resonate-Backend)** - Appwrite Cloud Functions

---

## 🤝 Contributing

We ❤️ contributions! Resonate is open-source and we welcome contributors of all skill levels.

### How to Contribute

1. **🍴 Fork the Repository**
   - Click the "Fork" button at the top right of this page

2. **📥 Clone Your Fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/Resonate.git
   cd Resonate
   ```

3. **🌿 Create a Branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

4. **✨ Make Your Changes**
   - Write clean, well-documented code
   - Follow the existing code style
   - Test your changes thoroughly

5. **✅ Commit Your Changes**
   ```bash
   git commit -m "feat: add amazing feature"
   ```

6. **📤 Push to Your Fork**
   ```bash
   git push origin feature/amazing-feature
   ```

7. **🎉 Open a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Select your branch
   - Fill in the PR template
   - Submit for review!

### Contribution Guidelines

Please read our detailed [Contribution Guidelines](CONTRIBUTING.md) before submitting a PR.

**Important Notes:**
- 🎯 All contributions should target the `dev` branch, not `master`
- 📝 Follow the commit message format: `type: description`
- 🧪 Include tests for new features
- 📖 Update documentation as needed
- ✅ Ensure all checks pass before requesting review

### Good First Issues

New to open source? Look for issues labeled with:
- `good first issue` - Perfect for beginners
- `documentation` - Help improve our docs
- `bug` - Fix existing issues
- `enhancement` - Add new features

---

## 🎨 App Screenshots

<div align="center">

| Login Screen | Home Screen | Create Room |
|:---:|:---:|:---:|
| <img src="docs/screenshots/login.png" width="200"/> | <img src="docs/screenshots/home.png" width="200"/> | <img src="docs/screenshots/create_room.png" width="200"/> |

| Room Screen | Profile | Explore Stories |
|:---:|:---:|:---:|
| <img src="docs/screenshots/room.png" width="200"/> | <img src="docs/screenshots/profile.png" width="200"/> | <img src="docs/screenshots/explore.png" width="200"/> |

</div>

---

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter 3.19+
- **Language**: Dart
- **State Management**: GetX / Provider
- **UI Components**: Material Design

### Backend
- **BaaS**: Appwrite
- **Authentication**: Appwrite Auth (Email, Phone, OAuth)
- **Database**: Appwrite Database
- **Storage**: Appwrite Storage
- **Functions**: Appwrite Cloud Functions (Node.js)

### Real-time Communication
- **WebRTC**: LiveKit
- **Audio**: LiveKit SDK
- **Rooms**: LiveKit Room Management

### Tools & Services
- **Version Control**: Git & GitHub
- **CI/CD**: GitHub Actions
- **Package Manager**: Pub
- **Build Tools**: Gradle (Android), Xcode (iOS)

---

## 📱 Installation

### For Users

Download Resonate from Google Play Store:

<a href="https://play.google.com/store/apps/details?id=com.resonate.resonate">
  <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" alt="Get it on Google Play" height="80"/>
</a>

### For Developers

Follow our [Onboarding Guide](ONBOARDING.md) for complete setup instructions.

---

## 🐛 Troubleshooting

### Common Issues

**Issue: "Cannot connect to Appwrite"**
- Check your internet connection
- Verify Appwrite endpoint URL
- Ensure project ID is correct

**Issue: "LiveKit connection failed"**
- Check microphone permissions
- Verify LiveKit credentials
- Test network connectivity

**Issue: "Build failed"**
- Run `flutter clean`
- Delete `pubspec.lock`
- Run `flutter pub get`
- Try building again

For more troubleshooting tips, see our [Onboarding Guide - Troubleshooting Section](ONBOARDING.md#troubleshooting).

---

## 📚 Documentation

- **[Onboarding Guide](ONBOARDING.md)** - Complete setup for contributors
- **[Contributing Guidelines](CONTRIBUTING.md)** - How to contribute
- **[Code of Conduct](CODE_OF_CONDUCT.md)** - Community guidelines
- **[Security Policy](SECURITY.md)** - Report security issues
- **[Translation Guide](TRANSLATIONS.md)** - Help translate the app

---

## 🌟 Community & Support

### Get Help

- 💬 **Discord**: [Join our server](https://discord.gg/MMZBadkYFm)
- 📧 **Email**: aossie.oss@gmail.com
- 🐛 **Issues**: [Report bugs](https://github.com/AOSSIE-Org/Resonate/issues)
- 💡 **Discussions**: [Ask questions](https://github.com/AOSSIE-Org/Resonate/discussions)

### Stay Updated

- ⭐ Star this repository to show support
- 👀 Watch for updates and releases
- 🐦 Follow us on social media (coming soon!)

---

## 👥 Maintainers

- **[Jaideep Prasad](https://github.com/jddeep)** - Project Lead
- **[Chandan S Gowda](https://github.com/chandansgowda)** - Core Maintainer

---

## 🙏 Contributors

Thanks to all our amazing contributors! 🎉

[![Contributors](https://contrib.rocks/image?repo=AOSSIE-Org/Resonate)](https://github.com/AOSSIE-Org/Resonate/graphs/contributors)

Want to see your name here? [Start contributing!](#contributing)

---

## 📜 License

This project is licensed under the **GNU General Public License v3.0** - see the [LICENSE](LICENSE) file for details.

```
Resonate - An Open Source Social Voice Platform
Copyright (C) 2023-2025 AOSSIE

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
```

---

## 🏆 Achievements

- 🎓 **Google Summer of Code 2023 & 2024** - Selected Project
- 🌟 **290+ GitHub Stars**
- 🍴 **270+ Forks**
- 👥 **45+ Contributors**
- 📥 **Available on Google Play Store**

---

## 🎯 Roadmap

### Q1 2025
- [ ] Enhanced story marketplace
- [ ] Advanced search functionality
- [ ] Profile customization
- [ ] Friend system implementation

### Q2 2025
- [ ] Direct messaging
- [ ] Voice notes feature
- [ ] Notification improvements
- [ ] Performance optimizations

### Q3 2025
- [ ] Web platform support
- [ ] Desktop application
- [ ] Advanced analytics
- [ ] Premium features

*Want to suggest a feature? [Open a discussion](https://github.com/AOSSIE-Org/Resonate/discussions)!*

---

## 🤗 Acknowledgments

- **AOSSIE** - Australian Open Source Software Innovation and Education
- **Appwrite** - For providing an amazing backend platform
- **LiveKit** - For real-time communication infrastructure
- **Flutter** - For the cross-platform framework
- **All Contributors** - For making this project possible

---

## 📞 Contact

- **Organization**: AOSSIE (Australian Open Source Software Innovation and Education)
- **Email**: aossie.oss@gmail.com
- **Discord**: https://discord.gg/MMZBadkYFm
- **GitHub**: https://github.com/AOSSIE-Org

---

<div align="center">

### ⭐ Don't forget to star this repository if you find it useful! ⭐

**Made with ❤️ by the AOSSIE Community**

</div>

---

## 💝 Support the Project

If you like Resonate, consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs
- 💡 Suggesting features
- 🤝 Contributing code
- 📢 Spreading the word

Every contribution, no matter how small, makes a difference!

---

**Happy Contributing! 🎉**