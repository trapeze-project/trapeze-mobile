# TRAPEZE Mobile Application
Contributors: K. Pelz, P.Pathak, I.Lehrer, N.Shawarba, T.Eichinger, P.Raschke

![Screenshots](https://github.com/trapeze-project/trapeze-mobile.git/blob/main/screenshots/put-all-screenshots-together.png?raw=true)

This is the code repository for the TRAPEZE Mobile Application for Android phones. 
The TRAPEZE Mobile Application is built on the basis of the [Flutter UI Framework](https://flutter.dev) developed by Google.
It provides a user interface for a mobile application that performs malware detection scans and, in case a malware was detected, provides further information on (1) how to resolve the security issue and (2) how to avoid the security issue it in the future. 

By default, the TRAPEZE Mobile Application makes use of the [Kaspersky Mobile Security SDK](https://www.kaspersky.com/mobile-security-sdk) by the Kaspersky Cyber-Security Company that implements malware detection scans.

This ```trapeze-mobile``` repository DOES NOT contain any malware detection business logic. 
The business logic for malware detection for use with the TRAPEZE Mobile Application is available in a separate repository called ```kaspersky_sdk``` available [here](https://github.com/trapeze-project/kaspersky_sdk). The ```kaspersky_sdk``` repository implements a [Flutter Plugin Package](https://docs.flutter.dev/packages-and-plugins/developing-packages#types).
Using malware detection scans provided by the Kaspersky Mobile Security SDK requires adding .aar files that contain their business logic to the ```kaspersky_sdk``` and also a *license key* from Kaspersky.

A release version of the TRAPEZE Mobile Application can be downloaded [here](tbd).

## 1. Clone the Code

Clone the code respository for the TRAPEZE Mobile Application and the code repository for the Flutter package that holds the business logic for the malware detection scans. 

```sh
git clone https://github.com/trapeze-project/trapeze-mobile.git
git clone https://github.com/trapeze-project/kaspersky_sdk.git
```

The TRAPEZE Mobile Application assumes that both repositories are located in the same directory.

```sh
./
 |-- /kaspersky_sdk    --> code repository of the KMS-SDK Flutter Plugin Package
 |-- /trapeze-mobile   --> main code repository 
```

If you wish to use another folder structure, you need to specify the path to the ```kaspersky_sdk``` repository in the ```pubspec.yaml``` file in the ```trapeze-mobile``` repository. 


## 2. Install Dependencies

### 2.1 Install Flutter and Dart command-line programs

Download the latest stable release version of Flutter command-line program by following the official [installation steps](https://docs.flutter.dev/get-started/install). We verified the code to work for the following Flutter version:

```sh
>> flutter --version
Flutter 3.0.0 • channel stable • https://github.com/flutter/flutter.git
Framework • revision ee4e09cce0 (7 days ago) • 2022-05-09 16:45:18 -0700
Engine • revision d1b9a6938a
Tools • Dart 2.17.0 • DevTools 2.12.2
```

> Note that the installation of the Flutter command-line program includes the installation of the Dart command-line program.

### 2.2 Install an IDE

<details><summary>IDE Installation Details</summary>

We present installations of two popular IDEs for the development of the TRAPEZE-mobile application.

#### 2.2.1 Android Studio

Download the Android Studio IDE following these [installation instructions](https://developer.android.com/studio?hl=de&gclid=CjwKCAjwj42UBhAAEiwACIhADk7rYnzdjIAXFR_vOgtWB1K62yQZFkn2xq1wzcm5KfY0p2PltBpJKhoCwn0QAvD_BwE&gclsrc=aw.ds). We have verified that the project builds correctly under the following release of Android Studio, Flutter, Dart, and Kotlin plugins:

```
Android Studio Chipmunk | 2021.2.1
Build #AI-212.5712.43.2112.8512546, built on April 28, 2022
Runtime version: 11.0.12+0-b1504.28-7817840 x86_64
VM: OpenJDK 64-Bit Server VM by JetBrains s.r.o.
Non-Bundled Plugins: Dart (212.5744), org.jetbrains.kotlin (212-1.6.21-release-334-AS5457.46), io.flutter (67.1.2)
```

> Install Flutter, Dart, and Kotlin plugins by double tapping \[Shift\] and typing 'Plugin' into the search bar to navigate to the Plugin-manager.

You may also need to configure the integrated Android SDK. You can install for instance the **Android SDK command-line Tools** and **Android SDK Build-Tools** via the SDK Manager.

> Install Android SDK command-line tools and Build-tools by double tapping \[Shift\] and typing 'SDK Manager' into the search bar to navigate to the SDK Manager.


#### 2.2.2 Visual Studio Code

Download the Visual Studio Code IDE following these [installation instructions](https://code.visualstudio.com/). We have verified that the project builds correctly under the following release of Android Studio, Flutter, Dart, and Kotlin plugins:

```
Visual Studio Code | Version: 1.67.1
Commit: da15b6fd3ef856477bf6f4fb29ba1b7af717770d
Date: 2022-05-06T12:37:16.526Z
```

> Install Kotlin, Dart, and Flutter extensions by clicking on the Extensions icon in the left menu, or clicking on the Settings icon (gear) in the bottom left and then select 'Extensions'.

</details>


## 3. Run the App and Build an APK

### 3.1 Run and build the TRAPEZE-mobile application

> CAVEAT Running the TRAPEZE Mobile Application will only run if it is run on an *Android device* (currently no support for iOS and Web).

> CAVEAT Malware detection scans will only work if the** *.aar files* from the Kaspersky Mobile Security SDK and a license key are added to the ```kaspersky_sdk``` repository as described in the README in the ```kaspersky_sdk``` repository. 

Run the TRAPEZE-mobile application by running the following commands

1. [OPTIONAL] Clear dependencies
```
flutter clean
```

2. Run the application
```
flutter run --<debug|release>
```
where you can choose between 'debug' and 'release' modes.

> Note that `flutter run` includes the execution of `flutter pub get` (install dependencies).

### 3.2 Build an APK of the TRAPEZE-mobile application

> CAVEAT Building .apk files of the TRAPEZE Mobile Application requires adding the Kaspersky Mobile Security SDK's .aar files and a license key to the ```kaspersky_sdk``` repository as described in the README in the ```kaspersky_sdk``` repository.* 

Build an APK (.apk) by running the following commands in the command-line at the root of the ```trapeze-mobile``` repository.

1. [OPTIONAL] Clear dependencies
```
flutter clean
```

2. Build APK
```
flutter build apk --<debug|release>
```
where you can choose between 'debug' and 'release' modes.

The compiled .apk files can be found here: `./build/app/outputs/flutter-apk/app-<debug|release>.apk`.


## Contact

Please do not hesitate to direct your questions to tobias.eichinger (AT) tu-berlin.de and philip.raschke (AT) tu-berlin.de.
