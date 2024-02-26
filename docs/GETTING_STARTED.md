## Getting Started with Resonate Flutter

This guide will walk you through setting up and running the Resonate Flutter app. 

**Prerequisites:**

* **Flutter:** Make sure you have Flutter installed on your system. You can find installation instructions and resources on the official website: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install).
* **Code editor/IDE:** Choose your preferred code editor or IDE that supports Flutter development. Popular options include Visual Studio Code, Android Studio, and IntelliJ IDEA.


**Installation:**

1. **Clone the repository:** Open your terminal and navigate to the desired directory. Then, clone the repository using the following command:

    ```bash
    git clone https://github.com/AOSSIE-Org/Resonate.git
    ```

2. **Navigate to the project directory:**

    ```bash
    cd Resonate
    ```

3. **Install dependencies:** Run the following command in the terminal to install the project's dependencies:

    ```bash
    flutter pub get
    ```

4. **Configure environment variables:**

    - Duplicate `env/.env.sample` and rename as `.env`
    - Create a Firebase project [here](https://console.firebase.google.com/)
    - Set up firebase app as mentioned [here]()
    - Overwrite `firebase_options.dart`
    - Copy respective values into `.env` file
    - Discard changes made to `firebase_options.dart`
    - Create a AppWrite project [here](https://appwrite.io/)
    - Replace `APPWRITE_PROJECT_ID` in `.env` with respective Appwrite Project ID

**Running the App:**

1. **Connect your device or start an emulator:** 
    * **Android:** Connect your Android device to your computer or launch an Android emulator.
    * **iOS:** Connect your iOS device to your computer with a USB cable, or use an iOS simulator.

2. **Run the app:**

   * To run the app on Android:

     ```bash
     flutter run
     ```

   * To run the app on iOS:

     ```bash
     flutter run -d ios
     ```

**Additional Resources:**

* **Flutter documentation:** [https://docs.flutter.dev/](https://docs.flutter.dev/)
* **Project README:** For specific details and functionalities of this project, refer to the `README.md` file within the repository.



**Feel free to reach out to the project maintainers if you have any questions or encounter any issues.**
