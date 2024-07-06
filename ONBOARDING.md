## Onboarding Guide

### Backend Env 

Git Clone the [Resonate Backend Repo](https://github.com/Aarush-Acharya/Resonate-Backend)
<br/>

> #### **Very Important Info**
> The backend initialisation script installs Appwrite locally with additional custom flags to the install command available in the appwrite documentation so if you already have Installed Appwrite locally please delete the image and the container and start fresh
<br/>

Navigate to the root directory of the project in your terminal, and run the command
```bash
./init.sh
```
This will start the backend initialisation script thus start pulling Appwrite's docker image, this may take some time but after a few minutes it will ask you for some inputs let everything be the default and just press enter for it to take the default value, once all inputs are taken your it will compose the image into a container this might take a few minutes as well but after that appwrite will be successfully installed, started and up for action.

<br/>

Once your appwrite is set up, you will be prompted with login credentials to login to appwrite but first you must go to [appwrite localhost](http://localhost:80) and create your account, then provide the created accounts credentials to prompted messages

![Screenshot 2024-06-28 at 2 52 28 AM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/802d96c1-0ad5-4922-b49a-56eb56e39904)

After entering your email, password you will be asked for Endpoint of Appwrite Server let it be the default (hence press enter to move forward)
<br/>

If you are signed in successfully you will be asked for a team ID

![Screenshot 2024-06-28 at 2 58 50 AM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/3c401e60-3a64-4a6e-9c94-42863dccddd0)

For the team Id, while the creation of an appwrite account you must be asked of a team name for your default team. Head over to your [appwrite console](http://localhost:80) i.e. Localhost Port 80, and observe the URl in the end of the url, you will see your teamId

![Screenshot 2024-06-28 at 3 05 06 AM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/9717d9e5-41ad-4fd8-8f71-bac79e73cea7)

Thus my Team Id is `666ce18b003caf6274b6`, enter your team id in the terminal, once this is done the script will set up some stuff for you and then it will ask for Oauth provider credentials 

![Screenshot 2024-07-06 at 5 24 10 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/76c37da6-b69f-4335-9528-368fab979166)

#### Google Oauth Creds 

To create your Google Oauth credentials visit [Google Oauth Credential Guide](https://www.balbooa.com/help/gridbox-documentation/integrations/other/google-client-id) before that please read the few lines below 

While creating the Oauth credentials for Google add the following urls as 
you will be able to see a ngrok tunnel url that is required in these steps

Authorized JavaScript origins: `http://{your ngrok tunnel domain name}`     
so for me it is http://de17-2405-201-4015-c117-887-2249-1a1-8581.ngrok-free.app   

> #### **Very Important Info**
> The url should start with `http://` not `https://` please make sure that you striclty follow the instructions listed in this guide assuming every step to be case sensitive
<br/>

Authorized redirect URIs: `http://{your ngrok tunnel domain name}/v1/account/sessions/oauth2/callback/google/resonate`    
so for me it is http://de17-2405-201-4015-c117-887-2249-1a1-8581.ngrok-free.app/v1/account/sessions/oauth2/callback/google/resonate
 
After successful creation of Oauth credentials provide the App/Client  Id and Secret in the Terminal

#### Github Oauth Creds 

Get yourself your Github Oauth credentials via following [Github Oauth Credential Guide](https://support.heateor.com/get-github-client-id-client-secret/)

While creating the Oauth credentials for Github add the following urls as 

Homepage URL: `http://{your ngrok tunnel domain name}`  
so for me it is http://de17-2405-201-4015-c117-887-2249-1a1-8581.ngrok-free.app

Authorization callback URL: `http://{your ngrok tunnel domain name}/v1/account/sessions/oauth2/callback/github/resonate`  
so for me it is http://de17-2405-201-4015-c117-887-2249-1a1-8581.ngrok-free.app/v1/account/sessions/oauth2/callback/github/resonate

After Oauth you will be prompted for collections set up 

![Screenshot 2024-07-06 at 5 14 46 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/5155b124-07e4-4769-a9f1-ac574816f85e)

Press "a" to select all and press enter, same goes for functions and buckets set up comming after this

This completes the Appwrite Set Up, now you will be asked to choose between Livekit Cloud or Livekit Self hosted if you have a have an old laptop that is most likely not able to take up much processing load then opt for cloud else having it locally i.e self hosted is recommended 

![Screenshot 2024-07-06 at 5 20 00 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/348dc245-165e-490c-ba50-f699cd05bbee)

After livekit set up the script will start the caddy web server, and this would complete the script execution, printing out your ngrok tunnel Domain for you in the end. This tunnel domain needs to be entered in the constants.dart in the client side flutter project, copy the tunnel domain and save it with your self as well 

![Screenshot 2024-07-06 at 5 29 09 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/c18d726f-2a59-415c-8f03-483fe8e31097)

![Screenshot 2024-07-06 at 6 13 59 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/105a7b36-b151-4ca3-a470-842ec8e5183a)

The logs for the ngrok service could be viewed at http://localhost:4040/inspect/http, apart from ngrok all the other services logs i.e
livekit, caddy can be seen in the .log files generated during the execution of the script.

![Screenshot 2024-07-06 at 5 37 30 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/4aa9a6b7-5035-4bfa-81c7-fb9f814d018e)

why two caddy log files?

caddy.log: captures the server's operational logs, including startup and error messages.   
caddy_access.log: captures the access logs, detailing each HTTP request handled by the server.

All the three services
- caddy
- livekit
- ngrok

are running in the background, to stop 

##### Cady

```
cady stop
```

##### Livekit

```bash
 ps aux | grep livekit-server
```

now copy its Process Id and kill it using the kill command

```bash
kill <Pid>
```
![Screenshot 2024-07-06 at 5 49 17 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/602af879-3038-4d72-b91f-6fb33a535399)


##### ngrok

killing process similar to that of livekit

![Screenshot 2024-07-06 at 5 53 23 PM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/73bf1c1b-3fb8-4e0a-823a-b1d34bed8ac2)



