---
title: Setting Intellij IDE Project SDK
summary: Instruction on how to set the Intellij SDK to the correct Java JDK.
authors:
  - Duguma Yeshitla
date: 2024-12-13
---

# Setting Intellij IDE Project SDK

The Gradle project for the MiniReal ABM codebase relies on the avalability of Java JDK 17 (see [Installing JDK](./install_jdk.md) ). And when using Intellij IDE, this SDK (Software Development Kit) for Java has to be set accordingly in the OS or IDE. In this documentaion, we will see how to set it up in Intellij IDE.

1. Select the `Project Structure` option from the `Files` tab dropdown list.
  ![Navigating to Project Setting](../imgs/troubleshooting/setting_intellij_sdk/open_intellij_file_options.png){ align=center }
  <p style="text-align: center; font-size: 0.75em;">
      Figure: Navigating to a project settings window from the Files dropdown
  </p>

2. After clicking on the `Project Structure` option, the following popup window will be displayed. This window will show the relevant SDK (JDK) information for the opened project.
  ![Project Setting window](../imgs/troubleshooting/setting_intellij_sdk/open_intellij_sdk_settings_ui(cropped).png){ align=center }
  <p style="text-align: center; font-size: 0.75em;">
      Figure: Project Settings window
  </p>

3. From the `Project Structure` window, select the dropdown component next to the `SDK` label & choose the `Download JDK` option.
  ![Selecting download JDK option](../imgs/troubleshooting/setting_intellij_sdk/invoke_download_jdk_ui(cropped).png){ align=center }
  <p style="text-align: center; font-size: 0.75em;">
      Figure: Selecting download JDK option
  </p>

4. Another small window will pop-up to prompt for the JDK version & vendor. On this
window please select `JDK 17` version provided by the `Eclipse Termurin` vendor, whose
JDK is named `Adopt Open JDK`. And then click on the `Download` button & wait for the process to finish.
  ![Downloading Adopt Open JDK 17](../imgs/troubleshooting/setting_intellij_sdk/select_temurin_jdk17_for_download(cropped).png){ align=center }
  <p style="text-align: center; font-size: 0.75em;">
      Figure: Downloading Adopt Open JDK 17
  </p>

5. Once the download is completed you can select the recently added JDK from the drop-down option next to the SDK field on the `Project Setting` window. Take note to also select the correct `Language Level` version (which is also 17). Then click on `Apply` & `Ok`.
  ![Selecting correct JDK versions](../imgs/troubleshooting/setting_intellij_sdk/select_correct_jdk_after_download(cropped).png){ align=center }
  <p style="text-align: center; font-size: 0.75em;">
      Figure: Selecting correct JDK versions
  </p>

6. Finally you can test the correct setup of the JDK version by opening the Gradle side window located on the right-hand side of the IDE. First select the `clean` & then `build` options from the Tasks choice. These steps will build the ABM Gradle project as fresh.
    * `Tasks` -> `build` -> `clean`
    * `Tasks` -> `build` -> `build`

    ![Testing correct setup of JDK](../imgs/troubleshooting/setting_intellij_sdk/test_jdk_setup_wz_gradle_tasks.png){ align=center }
    <p style="text-align: center; font-size: 0.75em;">
        Figure: Build Gradle ABM project and test correct setup of JDK
    </p>
  

Congratulations on successfully setting up the Java SDK (JDK) for WSim4ABM (MiniReal) Gradle project workflow. You can now perform modeling locally and generate your model
`jar` files conveniently.
