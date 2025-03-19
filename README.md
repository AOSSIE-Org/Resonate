<div align="center">
 <span>
 <img src="https://github.com/ShivamMenda/Resonate/assets/74780977/ca9e88d2-f4ca-4d8c-8a8a-289286b91e54" alt="Resonate logo" width="150" height="auto" />
<img src="assets/images/aossie_logo.png" alt="Resonate logo" width="150" height="auto" />
 </span>

# :microphone: Resonate - An Open Source Social Voice Platform
</div>
<div align="center" style="text-align:center;"> 
<span>
 <a href="https://appwrite.io" target="_blank">
  <picture>
   <source media="(prefers-color-scheme: dark)" align="center" srcset="https://github.com/appwrite/website/blob/main/static/images/logos/appwrite.svg"      
    alt="Appwrite Logo" width="200">
   <img alt="Appwrite Logo" align="center" src="https://github.com/appwrite/website/blob/main/static/images/logos/appwrite-light.svg" alt="Appwrite Logo" 
    width="200">
  </picture>
 </a>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 <a href="https://livekit.io" target="_blank">
  <picture>
   <source media="(prefers-color-scheme: dark)" align="center" srcset="https://github.com/AKASHANGADII/Resonate/assets/81625153/87bb173f-d5b0-4386-b9ca-6e69cd53578f" alt="Livekit Logo" width="140" height="30">
   <img alt="Livekit Logo" align="center" src="https://github.com/AKASHANGADII/Resonate/assets/81625153/1466de84-d00e-4db7-9b51-a99f3c1997ff"  width="140" 
    height="30">
  </picture>
 </a>
</span>
</div>
<br>
<br>


<div align="center">
  
[![License:GPL-3.0](https://img.shields.io/badge/License-GPL-yellow.svg)](https://opensource.org/license/gpl-3-0/)
![GitHub Org's stars](https://img.shields.io/github/stars/AOSSIE-Org/Resonate?style=social)

</div>


With social voice platforms like Spotify, Clubhouse, and Twitter Spaces experiencing rapid growth, Resonate is here to harness the power of open-source for voice-based social media. Whether it's sharing immersive stories, engaging in dynamic live discussions, or connecting through pair chats and voice calls, Resonate is designed to put voice at the center of your social experience. By fostering innovation and growth, this project aims to reach new heights, continually expanding its features and community, all while staying true to the open-source spirit of collaboration and transparency.

## :rocket: Features
1. Real-time Audio Communication by joining rooms and talking to people.
2. Ability to create rooms and moderate speakers and events.
3. Create Scheduled Rooms and notify subscribers as reminders to join
4. Listen to and Stories as chapters with synced lyrics, browse through entire catalog of stories following your favourate creators and waiting for their latest chapter/story releases. Post your own stories having chapters. (work in progess)
5. Pair chatting to enable users to find random partners to talk to in the app.
6. Friend People/Profiles enabling your self to talk on voice calls/realtime messaging with them (coming soon)

## :computer: Technologies Used

1.  **Flutter** - Mobile application
2.  **Appwrite** - Authentication, Database, Storage and Cloud functions.
3.  **LiveKit** - Web Real-Time Communication 

## :link: Repository Links
1. [Resonate Flutter App](https://github.com/AOSSIE-Org/Resonate)
2. [Resonate Backend](https://github.com/AOSSIE-Org/Resonate-Backend)


## :four_leaf_clover: Getting Started
Resonate is a wide project taking use of other software solutions like Appwrite and Livekit, starting up can be a little challenging

We offer a guide for walking you through setting up the entire project, including a script that automates the set up of the backend environment for you. 
Please go through and strictly follow the [Onboarding Guide](https://github.com/Aarush-Acharya/Resonate/blob/master/ONBOARDING.md) for setting up the project for development and further contribution

## 🛠️ Quick Setup Guide

### Prerequisites
- Flutter SDK
- Docker
- Git

### Basic Setup Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/AOSSIE-Org/Resonate.git
   cd Resonate
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Set up the backend environment:
   - Follow the detailed [Onboarding Guide](https://github.com/Aarush-Acharya/Resonate/blob/master/ONBOARDING.md) for Appwrite and LiveKit setup
   - The guide includes automated scripts for backend initialization

4. Configure the frontend:
   - Update the `baseDomain` in `lib/constants.dart` based on your platform:
     - Android Simulator: `10.0.2.2`
     - iOS Simulator: `127.0.0.1`
     - Physical Device: Your laptop's IP address (ensure device is on same network)

5. Run the app:
   ```bash
   flutter run
   ```

> **Note**: For a complete setup with all features, including authentication and real-time communication, please refer to the detailed [Onboarding Guide](https://github.com/Aarush-Acharya/Resonate/blob/master/ONBOARDING.md).

## :movie_camera: App Screenshots
<div align="center">
 
| Login Screen (Forest) | Home Screen (Time) | Create Room Screen (Time) |
| :---         |     :---      |          :--- |
| <img src= "https://github.com/user-attachments/assets/e76147b1-0e51-4852-8198-06bbc975b25c" width="260" height="auto" />  | <img src="https://github.com/user-attachments/assets/ad62eecb-b621-4c31-a01c-001ff5462b28" width="250" height="auto" />    | <img src="https://github.com/user-attachments/assets/31ce6e73-8dca-4e2d-8f48-c22480fa1332" width="250" height="auto" />    |

| Room Screen (Cream) | Profile Screen (Amber) | Explore Story (Forest) |
| :---         |     :---      |          :--- |
|  <img src="https://github.com/user-attachments/assets/f1d6e62f-5f25-47c1-9f59-e165d7018c0c" width="250" height="auto" /> | <img src="https://github.com/user-attachments/assets/b9dfe363-79b1-4eee-8d00-28f5c14f93ee" width="250" height="auto" />   |  <img src="https://github.com/user-attachments/assets/c7657be8-bce2-4c3a-aee3-dd3cc33379a2" width="250" height="auto"/>    |

| Explore Story (Amber) | Theme Screen (Vintage) | Upcoming Room Screen (Cream) |
| :---         |     :---      |          :--- |
|  <img src="https://github.com/user-attachments/assets/ba7da784-48a6-4512-a4c8-9f12b8ad13c1" width="250" height="auto" /> | <img src="https://github.com/user-attachments/assets/ba9273f2-ceef-441d-8f94-4e0bc53b3e99" width="250" height="auto" />   |  <img src="https://github.com/user-attachments/assets/a46c7da4-2df4-4c62-9e4c-9c92102339e9" width="250" height="auto"/>    |
</div>



## :raised_hands: Contributing
:star: Don't forget to star this repository if you find it useful! :star:

Thank you for considering contributing to this project! Contributions are highly appreciated and welcomed (P.S. to the `dev` branch). To ensure a smooth collaboration, Refer to the [Contribution Guidelines](https://github.com/AOSSIE-Org/Resonate/blob/master/CONTRIBUTING.md).

We appreciate your contributions and look forward to working with you to make this project even better!

By following these guidelines, we can maintain a productive and collaborative open-source environment. Thank you for your support!

## :v: Maintainers

-   [Jaideep Prasad](https://github.com/jddeep)
-   [Chandan S Gowda](https://github.com/chandansgowda)

## :mailbox: Communication Channels

If you have any questions, need clarifications, or want to discuss ideas, feel free to reach out through the following channels:

-   [Discord Server](https://discord.com/invite/6mFZ2S846n)
-   [Email](mailto:aossie.oss@gmail.com)

<!-- License -->
## :round_pushpin: License

Distributed under the [GNU General Public License](https://opensource.org/license/gpl-3-0/). See [LICENSE](https://github.com/AOSSIE-Org/Resonate/blob/master/LICENSE) for more information.

## 💪 Thanks To All Contributors

Thanks a lot for spending your time helping Resonate grow. Keep rocking 🥂

<a href="https://github.com/AOSSIE-Org/Resonate/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=AOSSIE-Org/Resonate" alt="Contributors"/>
</a>
<br>
 

