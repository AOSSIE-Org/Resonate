## Onboarding Guide

Client side set up is straight forward and standard, i.e clone the repo [Resonte Client Side Repo](https://github.com/AOSSIE-Org/Resonate), do `flutter pub get` in the root of th project etc so this guide would focus on the backend env set up.

### Prerequisits (must be installed) for Backend Env Set-Up

- Docker
- [Livekit](https://github.com/livekit/livekit#windows) (needed only for Windows)

### Starting Off (Clone Repo, Run Script, Script Install Appwrite locally)

Git Clone the [Resonate Backend Repo](https://github.com/Aarush-Acharya/Resonate-Backend)
<br/>

> #### **Very Important Info**
> The backend initialisation script installs Appwrite locally with additional custom flags to the install command available in the appwrite documentation so if you already have Installed Appwrite locally please delete the image and the container and start fresh
<br/>

Navigate to the root directory of the project in your terminal (for windows power shell), and run the command

##### Linux / Mac OS

```bash
./init.sh
```

##### Windows

```bash
./init.ps1
```

The script will identify your Operating System, will start installing the dependencies for the script to execute
- Appwrite CLI
- Livekit Server CLI
- Livekit CLI

This will ask for sudo access, give it

![Screenshot 2024-07-09 at 3 38 32 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/bd3235a5-2ab9-47b5-94a9-e2f9d61deb14)


After installing the dependancies it will start the backend initialisation script thus start pulling Appwrite's docker image, this may take some time but after a few minutes it will ask you for some inputs let everything be the default and just press enter for it to take the default value, once all inputs are taken your it will compose the image into a container this might take a few minutes as well but after that appwrite will be successfully installed, started and up for action.

<br/>

Once your appwrite is intalled and running, you will be prompted with login credentials to login to appwrite but first you must go to [appwrite localhost](http://localhost:80) and create your account, then provide the created accounts credentials to prompted messages

![Screenshot 2024-06-28 at 2 52 28 AM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/802d96c1-0ad5-4922-b49a-56eb56e39904)

After entering your email, password you will be asked for Endpoint of Appwrite Server let it be the default (hence press enter to move forward)
<br/>



### Ngrok Set Up

You will be prompted for a ngrok auth token, sign up to [ngrok](https://ngrok.com/), to get your self an auth token and give it in the terminal

![Screenshot 2024-07-09 at 3 41 23 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/8b5dc583-c6f7-4a3c-a74a-9d50cb6a398e)

After successful Ngrok set up you will be given an ngrok domain as a result please copy it and save it with you, though for ease of use whenever it is required it will be given to you again during the initialization process via the script

### Resonate Project Set Up in Appwrite

#### Project Creation

After Ngrok set Up you will be asked for a team ID

![Screenshot 2024-07-09 at 4 16 17 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/29ad09a2-d8e8-4c95-bcb3-98e583c46f3e)

For the team Id, while the creation of an appwrite account you must be asked of a team name for your default team. Head over to your [appwrite console](http://localhost:80) i.e. Localhost Port 80, and observe the URl in the end of the url, you will see your teamId

![Screenshot 2024-06-28 at 3 05 06 AM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/9717d9e5-41ad-4fd8-8f71-bac79e73cea7)

Thus my Team Id is `666ce18b003caf6274b6`, enter your team id in the terminal, once this is done the script will set up some stuff for you and then it will ask for auth credentials 


![Screenshot 2024-07-09 at 4 17 02 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/6de9cd8d-508b-4b06-8c23-632015dab97e)


#### Oauth Set Up

- #### *Google Oauth Creds* 

To create your Google Oauth credentials visit [Google Oauth Credential Guide](https://www.balbooa.com/help/gridbox-documentation/integrations/other/google-client-id) before that please read the few lines below 

While creating the Oauth credentials for Google add the following urls as 
you will be able to see a ngrok tunnel url that is required in these steps

Authorized JavaScript origins: `http://{your ngrok tunnel domain name}`     
so for me it is http://bb58-49-36-144-88.ngrok-free.app   

> ##### **Very Important Info**
> The url should start with `http://` not `https://` please make sure that you striclty follow the instructions listed in this guide assuming every step to be case sensitive
<br/>

Authorized redirect URIs: `http://{your ngrok tunnel domain name}/v1/account/sessions/oauth2/callback/google/resonate`    
so for me it is http://bb58-49-36-144-88.ngrok-free.app/v1/account/sessions/oauth2/callback/google/resonate
 
After successful creation of Oauth credentials provide the App/Client  Id and Secret in the Terminal 

 
- #### *Github Oauth Creds* 

Get yourself your Github Oauth credentials via following [Github Oauth Credential Guide](https://support.heateor.com/get-github-client-id-client-secret/)

While creating the Oauth credentials for Github add the following urls as 

Homepage URL: `http://{your ngrok tunnel domain name}`  
so for me it is http://bb58-49-36-144-88.ngrok-free.app

Authorization callback URL: `http://{your ngrok tunnel domain name}/v1/account/sessions/oauth2/callback/github/resonate`  
so for me it is http://bb58-49-36-144-88.ngrok-free.app/v1/account/sessions/oauth2/callback/github/resonate


Oauth set up is complete 🚀

#### Core Project Services Set Up

Now you will be prompted for `Collection` Set Up

![Screenshot 2024-07-06 at 5 14 46 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/5155b124-07e4-4769-a9f1-ac574816f85e)

Press "a" to select all and press enter, same goes for `Functions` and `Buckets` set up comming after this

This completes the Appwrite Set Up 🚀🍀

### Livekit Set Up

now you will be asked to choose between Livekit Cloud or Livekit Self hosted if you have a have an old laptop that is most likely not able to take up much processing load then opt for cloud else having it locally i.e self hosted is recommended 

![Screenshot 2024-07-06 at 5 20 00 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/348dc245-165e-490c-ba50-f699cd05bbee)


### Caddy Web Server Set Up

After livekit set up the script will start the caddy web server, and this would complete the script execution, printing out your ngrok tunnel Domain for you in the end. This tunnel domain needs to be entered in the constants.dart in the client side flutter project, copy the tunnel domain and save it with your self as well 


![Screenshot 2024-07-09 at 4 22 36 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/92e6b877-a650-4aa3-b0e1-9b7534e3145a)


![Screenshot 2024-07-07 at 8 49 29 AM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/42fa4370-50b9-43b9-a356-444380ce5141)

Make sure on the client side you keep everything as it is just swap the baseDomain with you ngrok tunnel domain, even if accidently you make the appwrite end point from "https://$baseDomain/v1" to "http://$baseDomain/v1" appwrite will throw an error 

`[log] AppwriteException: general_unauthorized_scope, User (role: guests) missing scope (account) (401)`

Hence make sure to keep things as it is and just swap the baseDomain.


### Debugging

The logs for the ngrok service could be viewed at http://localhost:4040/inspect/http, apart from ngrok all the other service's logs i.e
livekit, caddy can be seen in the .log files generated during the execution of the script.

![Screenshot 2024-07-06 at 5 37 30 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/4aa9a6b7-5035-4bfa-81c7-fb9f814d018e)

why two caddy log files?

caddy.log: captures the server's operational logs, including startup and error messages.   
caddy_access.log: captures the access logs, detailing each HTTP request handled by the server.

### How to Stop the Backend Env Services

Services that backend Env uses

- Appwrite
- caddy
- livekit
- ngrok

are running in the background, to stop 

#### Appwrite

Just stop the appwrite's docker container


#### Cady

Just stop the Caddy container

#### Livekit

```bash
 ps aux | grep livekit-server
```

now copy its Process Id and kill it using the kill command

```bash
kill <Pid>
```

![Screenshot 2024-07-06 at 5 49 17 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/602af879-3038-4d72-b91f-6fb33a535399)


#### Ngrok

Just stop the ngrok's docker container



