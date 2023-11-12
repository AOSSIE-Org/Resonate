<div align="center">
 <span>
 <img src="https://github.com/ShivamMenda/Resonate/assets/74780977/ca9e88d2-f4ca-4d8c-8a8a-289286b91e54" alt="Resonate logo" width="150" height="auto" />
<img src="assets/images/aossie_logo.png" alt="Resonate logo" width="150" height="auto" />
 </span>

# :microphone: Resonate - An Open Source Social Voice Platform
</div>
<div align="center"> 
<span>
 <a href="https://appwrite.io" target="_blank"><img src="https://github.com/appwrite/website/blob/main/static/images/logos/appwrite.svg" alt="Appwrite Logo" width="200"></a> 
 <img src="https://github.com/ShivamMenda/Resonate/assets/74780977/38823d33-edfb-4d90-9c4b-823cbe33c0a5" alt="Livekit Logo" width="200"></a>
</span>
</div>
<br>
<br>


<div align="center">
  
[![License:GPL-3.0](https://img.shields.io/badge/License-GPL-yellow.svg)](https://opensource.org/license/gpl-3-0/)
![GitHub Org's stars](https://img.shields.io/github/stars/AOSSIE-Org/Resonate?style=social)

</div>


With the rising popularity of social voice platforms such as Clubhouse and Twitter Spaces, it is high time for an Open Source alternative. A platform like this would not only enhance credibility within the open-source community but also attract more users and foster growth. An engagement platform that is Open Source has the potential to drive significant traction and help establish a strong presence.

## :rocket: Features
1. Real-time Audio Communication by joining rooms and talking to people.
2. Ability to create rooms and moderate speakers and events.
3. Pair chatting to enable users to find random partners to talk to in the app.
4. Real-time messaging(Coming Soon) 

## :computer: Technologies Used

1.  **Flutter** - Mobile application
2.  **Appwrite** - Authentication, Database, Storage and Cloud functions.
3.  **LiveKit** - Web Real-Time Communication 

## :link: Repository Links
1. [Resonate Flutter App](https://github.com/AOSSIE-Org/Resonate)
2. [Resonate Backend](https://github.com/AOSSIE-Org/Resonate-Backend)

## :movie_camera: App Screenshots
<div align="center">
 
| Login Screen | Home Screen | Create Room Screen |
| :---         |     :---      |          :--- |
| <img src="https://github.com/ShivamMenda/Resonate/assets/74780977/7c996c0a-1201-44e4-86bb-832ded1aae15" width="260" height="auto" />  | <img src="https://user-images.githubusercontent.com/41890434/246064681-16cfa072-af71-4e1f-97b8-2c429a875483.png" width="250" height="auto" />    | <img src="https://user-images.githubusercontent.com/41890434/246064943-82e83ead-dcf3-45fa-b3ba-c0a60455946a.png" width="250" height="auto" />    |

| Room Screen | Profile Screen | Pairchat Screen |
| :---         |     :---      |          :--- |
|  <img src="https://user-images.githubusercontent.com/41890434/246065343-352bdfb5-3cb4-44ad-9050-6460c3be18ad.png" width="250" height="auto" /> | <img src="https://user-images.githubusercontent.com/41890434/246064895-1b8cd5a8-b427-4514-91b8-d783ff4a0604.png" width="250" height="auto" />   |  <img src="https://github.com/ShivamMenda/Resonate/assets/74780977/8d7c5da5-0b2f-4d8f-8f12-d1059b0e4a01" width="250" height="auto"/>    |
</div>

##Appwrite Setup
This project utilizes Appwrite as a backend service. Appwrite is an open-source platform that helps you build applications faster with real-time APIs for authentication, databases, file storage, and more.

### Prerequisites

Before you begin, make sure you have the following installed on your machine:

- Docker: [Install Docker](https://docs.docker.com/get-docker/)
- Docker Compose: [Install Docker Compose](https://docs.docker.com/compose/install/)

### Step 1: Clone the Repository

Clone the Resonate repository to your local machine:

```bash
git clone https://github.com/AOSSIE-Org/Resonate.git
cd resonate

### Step 2: Configure Appwrite
In the project directory, create a new file named .env:
bash
touch .env

Open .env in a text editor and add the following configuration:
env
# Appwrite Configuration
APPWRITE_ENDPOINT=http://appwrite-api:80
APPWRITE_PROJECT_ID=your_project_id
APPWRITE_API_KEY=your_api_key

# Other Configuration
# Add any other environment variables or configurations specific to Resonate here

### Step 3: Start Appwrite
Run the following commands to start Appwrite services using Docker Compose:

bash
docker-compose up -d appwrite
This will start the Appwrite services in the background

### Step 4: Access Appwrite Console
Open your browser and navigate to http://localhost:8000/console to access the Appwrite console. Log in with the default credentials:

Email: admin@example.com
Password: password
### Step 5: Configure Appwrite in Resonate
Integrate Appwrite SDK into Resonate by following the Appwrite documentation: Appwrite SDKs.

### Step 6: Run Your Project
Now that Appwrite is set up and configured in your project, you can run Resonate 

bash
# Run your project command (e.g., npm start, yarn start, etc.)
 Resonate should now be running and connected to the Appwrite backend.


## :raised_hands: Contributing
:star: Don't forget to star this repository if you find it useful! :star:

Thank you for considering contributing to this project! Contributions are highly appreciated and welcomed. To ensure a smooth collaboration, Refer to the [Contribution Guidelines](https://github.com/AOSSIE-Org/Resonate/blob/master/CONTRIBUTING.md).

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
 

