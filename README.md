# Resonate - A Social Voice Platform

With the rising popularity of social voice platforms such as Clubhouse and Twitter Spaces, it is high time for an Open Source alternative. A platform like this would not only enhance credibility within the open-source community, but also attract more users and foster growth. An engagement platform that is Open Source has the potential to drive significant traction and help establish a strong presence.

## Goals
1.  Design and Develop a Flutter Mobile Application.
2.  Develop a backend for the app using NodeJS, Firebase and LiveKit.

## High Level Architecture

1.  **LiveKit** - It is an open source WebRTC stack that gives everything needed to build scalable and real-time video, audio, and data experiences in our application. This will be responsible for audio streaming. It will be easier to implement and deploy it since they have a great documentation too. To get started, we can use their free cloud service and then we can host the open-source version on our own server.
2.  **Firebase** - We can use it for storing user data, managing rooms/spaces (Firestore Database).
3.  **Auth0** - Will be used for authentication of users.
4.  **NodeJS** - Will be used to develop a web server which will interact with the mobile app, firebase as well as LiveKit. The flutter app will interact with the server using REST API endpoints.
5. **Flutter** - Will be used to develop the application for various platforms. We can design the app using MVC (Model View Controller) architecture and use GetX for state management. GetX offers several features, including reactive programming, dependency injection, and routing, which can help us build scalable and maintainable application. Listeners, moderators and speakers are devices having the flutter application.


![Architecture](https://user-images.githubusercontent.com/41890434/226345657-b5bef606-9fee-4b48-a328-14f54774ff99.jpg)

## Firebase Firestore Structure (To be finalized)

Please join the discussion in [this issue](https://github.com/AOSSIE-Org/Resonate/issues/19)

![Firebase Firestore Structure](https://user-images.githubusercontent.com/41890434/226342469-28b8c27b-7013-41f1-9c7e-a5903b8bba56.png)


## App Level Design Pattern

Flutter will be used to develop the application for various platforms. We will be designing the app using MVC (Model View Controller) architecture and we will be using GetX for state management. GetX offers several features, including reactive programming, dependency injection, and routing, which can help us build scalable and maintainable application. 

## Repository Links

1. [Resonate Flutter App](https://github.com/AOSSIE-Org/Resonate)
2. [Resonate Backend](https://github.com/AOSSIE-Org/Resonate-Backend)
