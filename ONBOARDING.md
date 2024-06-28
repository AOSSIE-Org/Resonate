## Onboarding Guide

### Backend Env 

Git Clone the [Resonate Backend Repo](https://github.com/Aarush-Acharya/Resonate-Backend)
<br/>

> #### **Very Important Info**
> The backend initialisation script installs Appwrite locally with additional custom flags to the install command available in the appwrite documentation so if you already have Installed Appwrite locally please delete the image and the container and start fresh
<br/>

Navigate to the root directory of the project in your terminal, and run the command
```
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

![Screenshot 2024-06-28 at 3 06 57 AM](https://github.com/Aarush-Acharya/Resonate/assets/92685647/9d645a06-a823-4cd7-b5ed-6866dd2be1c8)


To create your Google Oauth credentials visit [Google Oauth Credential Guide](https://www.balbooa.com/help/gridbox-documentation/integrations/other/google-client-id) before that please read the few lines below 

While creating the Oauth credentials for Google add the following urls as 

Authorized JavaScript origins: https://localhost
Authorized redirect URIs: http://localhost/v1/account/sessions/oauth2/callback/google/resonate
  
Get yourself your Github Oauth credentials via following [Github Oauth Credential Guide](https://support.heateor.com/get-github-client-id-client-secret/)

While creating the Oauth credentials for Github add the following urls as 

Homepage URL: https://{your laptop Ip}  
so for me it is http://192.168.29.57

Authorization callback URL: http://{your laptop Ip}/v1/account/sessions/oauth2/callback/github/resonate 
so for me it is http://192.168.29.57/v1/account/sessions/oauth2/callback/github/resonate





