## PROJECT FE README FILE

Welcome to the Project Fe readme file. This file serves to instruct you on how to install the project on your Macbook and run it successfully.

---

## Install Xcode 

If you have not yet installed Xcode for Swift development, please open your AppStore and search for "Xcode", download, and install it.

---

## Install CocoaPods 

After installing Xcode, you will require CocoaPods. The steps to install Cocoa pods can be found below.

Open your Terminal and type the following commands to install CocoaPods or type this command to update:
1. sudo gem install cocoapods

---

## Clone This Repository

1. You’ll see the clone button under the **Source** heading. Click that button.
2. Now click **Check out in SourceTree**. You may need to create a SourceTree account or log in.
3. When you see the **Clone New** dialog in SourceTree, update the destination path and name if you’d like to and then click **Clone**.
4. Open the directory you just created to see your repository’s files.

---

## Install Project CocoaPod Dependencies

Open your Terminal and navigate you where you have saved the project.
Once you see the project folder, navigate to: /fe/Fe/
Inside this folder ou should see Fe, Fe-Mini, Fe-Mini Extension etc. Run the command below:
1. pod install

This command may take some time to install all the dependencies.

---

## Open the Project

After running the pod install command, double-click the Fe.xcworkspace file and it should open the project in Xcode for you.
Once opened, you may need to change the Team Signing to your own for it to work.

Click the "Fe" base file > Signing & Capabilities.

**NOTE If you have to change the bundle identifiers, Notifications will not work because they are tied to our project bundle identifier.

Change the team (and potentially the bundle identifier) for each of the targets found in the left-side bar.
You may also need to change the bundle identifier in the folder structure on the left: Fe-Mini > Info.plist at the bottom.
You may also need to change the bundle identifier in the folder structure on the left: Fe-Mini Extension > Info.plist at the bottom.

After this, you should be able to build the project and run it.

## Demo Screenshots


![login](https://github.com/user-attachments/assets/2803b329-07ea-41fb-a6f8-bf776afe783b)
![home page](https://github.com/user-attachments/assets/a7f2464d-e6ed-4012-bc3b-928099a2bdcd)


