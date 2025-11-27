# Onboarding Guide

Client side set up is straight forward and standard, i.e clone the repo [Resonate Client Side Repo](https://github.com/AOSSIE-Org/Resonate), do `flutter pub get` in the root of the project etc so this guide would focus on the backend env set up.

Please strictly stick to the guide do not go off installing stuff on your own

> #### **Setting up Firebase for FCM**
> To ensure that new contributors do not have to setup firebase projects, all Firebase functionality (Only used for Notifications via FCM) has been disabled in the application. To enable this functionality (if you want to test notifications), setup a project on firebase, configure Resonate to use your project using this [guide](https://firebase.google.com/docs/flutter/setup) and uncomment the Firebase and FCM specific code in the files: ```main.dart , auth_state_controller.dart, and upcomming_rooms_controller.dart ``` Also, in the [Resonate Backend Repo](https://github.com/AOSSIE-Org/Resonate-Backend), uncomment the FCM and Firebase code in the `Upcoming Rooms Time Checker Function` and add your google-services.json in the folder for that function before setting up the localhost backend. 
<br/>

### Prerequisits (must be installed) for Backend Env Set-Up

- Docker


### Installing Appwrite and Appwrite CLI 

Clone the [Resonate Backend Repo](https://github.com/AOSSIE-Org/Resonate-Backend)
<br/>

> #### **Very Important Info**
> The backend initialisation script installs Appwrite locally with additional custom flags to the install command available in the appwrite documentation so if you already have Installed Appwrite locally please delete the image and the container and start fresh
<br/>


Navigate to the root directory of the project in your terminal (for windows power shell), and run the command

##### Linux and MacOS

```bash
sudo ./init.sh
```

##### Windows

```bash
./init.ps1
```

The script will identify your Operating System, will start installing the appwrite-cli (will even install brew if not there for macOS)

![Screenshot 2024-10-11 at 3 21 21 AM](https://github.com/user-attachments/assets/eb623af8-9087-4e18-9ee1-4b7b088016fb)


After installing the appwrite-cli it will start pulling Appwrite's docker image, this may take some time 

After a few minutes it will ask you for some inputs let everything be the default and just press enter for it to take the default value, once all inputs are taken it will compose the image into a container this might take a few minutes as well

Now appwrite will be successfully installed locally as a container and will be up for action.



### Resonate Project Set Up in Appwrite

#### Login
Next you will be asked for login credentials. Go to [appwrite localhost](http://localhost:80), create your account, you will be asked to create a team please do so. Once done fill in the created account creds to the script

![Screenshot 2024-06-28 at 2 52 28 AM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/802d96c1-0ad5-4922-b49a-56eb56e39904)


#### Project Creation

After logging in you will be asked for a team ID

![Screenshot 2024-10-11 at 3 24 47 AM](https://github.com/user-attachments/assets/a628344a-747d-4121-b1af-907e4b92543f)

For the team Id, while the creation of an appwrite account you must be asked of a team name for your default team. Head over to your [appwrite console](http://localhost:80) i.e. Localhost Port 80, and observe the URl in the end of the url, you will see your teamId

![Screenshot 2024-06-28 at 3 05 06 AM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/9717d9e5-41ad-4fd8-8f71-bac79e73cea7)

Thus my Team Id is `666ce18b003caf6274b6`, enter your team id in the terminal, once this is done the script will create a new project named Resonate in your instace with its id being 'resonate'.


#### Auth Set Up
The auth set up is intentially skipped as google Oauth did not allow private IP as allowed redirect URl's so we had to make the script open tunnels and once tunneling was introduced. It brought more complexities and conditions of working which degraded the scripts robustness 

So we have decided to create a dedicated script for the rare case of testing the Oauth login buttons ('google', 'github') this script is work in progress and will be out soon. But for now email password signIn should work perfectly fine enabling you to explore full capabilities of the project with a robust script


#### Core Project Services Set Up

Now you will be prompted for `Collection` Set Up

![Screenshot 2024-07-06 at 5 14 46 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/5155b124-07e4-4769-a9f1-ac574816f85e)

Press "a" to select all and press enter, same goes for  `Buckets` set up comming after this. The `Functions` will be pushed at then end of the script after the Livekit env vars are pushed as the Function need redeployment after a new env var is pushed in order to read the var.

This completes the Resonate project Set Up (functions will be pushed in the end) in your local Appwrite Instance 🚀🍀
<br/>

### Meilisearch Set Up
Now you will be asked to choose between Meilisearch Cloud and Meilisearch Self Hosted. Please choose whatever option suits you.
![Image for Meilisearch](https://github.com/user-attachments/assets/c349ea95-ce14-47c6-b712-fc93d25747e3)


This would run Meilisearch locally for you as a container (if you went with self hosted). You can proceed to the next section.

If you want to use Meilisearch in Resonate, please enable the isUsingMeilisearch flag in constants.dart either by changing the default value or passing true as an environment variable via the --dart-define argument.


### Livekit Set Up

now you will be asked to choose between Livekit Cloud or Livekit Self hosted if you have a have an old laptop that is most likely not able to take up much processing load then opt for cloud else having it locally i.e self hosted is recommended 

![Screenshot 2024-10-11 at 5 15 53 AM](https://github.com/user-attachments/assets/947c68d0-0555-4c71-9c62-f1592faafe5c)

This would run Livekit locally for you as a container (if you went with self hosted)
Now appwrite function pushing will start and just press 'a' char on keyboard to select all and push all functions 

![Screenshot 2024-10-11 at 5 16 10 AM](https://github.com/user-attachments/assets/bb1b7165-05a9-4adf-aad8-ef2ad34b48c7)


### Connecting Frontend and Backend

Now, on client side, based on how you are running the client side app you need to update the default value of the baseDomain variable in ```constants.dart``` or you can pass it in as an argument with ```flutter run``` using ```--dart-define=APPWRITE_BASE_DOMAIN=<Your baseDomain>```

| Platform          | Base Domain                                                                                           |
| ----------------- | ----------------------------------------------------------------------------------------------------- |
| Android Simulator | `10.0.2.2`                                                                                            |
| iOS Simulator     | `localhost`                                                                                           |
| Physical Device   | Ensure laptop and phone are on the same Wi-Fi, then use the laptop's IP address provided by the Wi-Fi |
