# Onboarding Guide

Client side set up is straight forward and standard, i.e clone the repo [Resonte Client Side Repo](https://github.com/AOSSIE-Org/Resonate), do `flutter pub get` in the root of the project etc so this guide would focus on the backend env set up.

Please strictly stick to the guide do not go off installing stuff on your own

### Prerequisits (must be installed) for Backend Env Set-Up

- Docker

### Installing Appwrite and Appwrite CLI 

Clone the [Resonate Backend Repo](https://github.com/Aarush-Acharya/Resonate-Backend)
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

This will ask for sudo access, give it

![Screenshot 2024-07-09 at 3 38 32 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/bd3235a5-2ab9-47b5-94a9-e2f9d61deb14)


After installing the appwrite-cli it will start pulling Appwrite's docker image, this may take some time 

After a few minutes it will ask you for some inputs let everything be the default and just press enter for it to take the default value, once all inputs are taken it will compose the image into a container this might take a few minutes as well

Now appwrite will be successfully installed locally as a container and will be up for action.

<br/>




### Resonate Project Set Up in Appwrite

#### Login
Next you will be asked for login credentials. Go to [appwrite localhost](http://localhost:80), create your account, you will be asked to create a team please do so. Once done fill in the created account creds to the script

![Screenshot 2024-06-28 at 2 52 28 AM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/802d96c1-0ad5-4922-b49a-56eb56e39904)

<br/>


#### Project Creation

After logging in you will be asked for a team ID

![Screenshot 2024-07-09 at 4 16 17 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/29ad09a2-d8e8-4c95-bcb3-98e583c46f3e)

For the team Id, while the creation of an appwrite account you must be asked of a team name for your default team. Head over to your [appwrite console](http://localhost:80) i.e. Localhost Port 80, and observe the URl in the end of the url, you will see your teamId

![Screenshot 2024-06-28 at 3 05 06 AM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/9717d9e5-41ad-4fd8-8f71-bac79e73cea7)

Thus my Team Id is `666ce18b003caf6274b6`, enter your team id in the terminal, once this is done the script will create a new project named Resonate in your instace with its id being 'resonate'.

#### Auth Set Up
The auth set up is intentially skipped as google Oauth did not allow private IP as allowed redirect URl's so we had to make the script open tunnels and once tunneling was introduced. It brought more complexities and conditions of working which degraded the scripts robustness 

So we have decided to create a dedicated script for the rare case of testing the Oauth login buttons ('google', 'github') this script is work in progress and will be out soon. But for now email password signIn should work perfectly fine enabling you to explore full capabilities of the project with a robust script


#### Core Project Services Set Up

Now you will be prompted for `Collection` Set Up

![Screenshot 2024-07-06 at 5 14 46 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/5155b124-07e4-4769-a9f1-ac574816f85e)

Press "a" to select all and press enter, same goes for `Functions` and `Buckets` set up comming after this

This completes the Appwrite Set Up 🚀🍀

### Livekit Set Up

now you will be asked to choose between Livekit Cloud or Livekit Self hosted if you have a have an old laptop that is most likely not able to take up much processing load then opt for cloud else having it locally i.e self hosted is recommended 

![Screenshot 2024-07-06 at 5 20 00 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/348dc245-165e-490c-ba50-f699cd05bbee)

This would run Livekit locally for you as a container (if you went with self hosted)

### Connecting Frontend and Backend

You just need to update the baseDomain variable value in the constants.dart on client side based on how you are running the client side app

Running on           baseDomain
android simulator    10.0.2.2
ios simulator        127.0.0.1
physical device      bring laptop and phone on same wifi and use the phone's IP given by the wifi





