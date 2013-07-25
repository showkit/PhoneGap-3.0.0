# PhoneGap Plugin for ShowKit iOS

Integrate video chat into your phonegap web app in less than 10 minutes!

* ***This plugin/demo has been upgraded from PhoneGap v2.7.0 to PhoneGap v3.0.0 and verfied to work.***
* ***If you just want to see a working demo, feel free to ``git clone git@github.com:showkit/PhoneGap-3.0.0.git``. The ShowKit-PhoneGapPlugin itself is a working demo.***
  * Required ShowKit.framework to make it run (follow the first three bullets of step 1).
  * Required you to insert your api key in your /platforms/ios/www/js/index.js.
  * Required you to change the subscribers prefix in login.html and dashboard.html(This can be found on your susbcribers page, it is the number before each subscribers username)
* ***Before you start step 1, you should have an existing phonegap app. If you don't, please checkout PhoneGap's [iOS Platforms](http://docs.phonegap.com/en/3.0.0/guide_platforms_ios_index.md.html#iOS%20Platform%20Guide) page.***

##Instructions for upgrading project(PhoneGap v2.7.0 to v3.0.0)
###Migrate old project files to new project
  * Create a new phonegap project.   
  * Copy/drag all of the htmls, js, view controllers, xibs, nibs, and storyboards from old project to the new project.
  * Change all the .html to use phonegap.js instead of cordova-2.7.0.js.
  * Now, just follow the ``Instructions for adding ShowKit to a new Project``

##Instructions for adding ShowKit to a new Project
###Step 1. Add ShowKit.framework to your Project

  * Download the latest [ShowKit.framework](http://www.showkit.com/releases).
  * Drag ShowKit.framework into your project
    ![ScreenShot](https://raw.github.com/showkit/PhoneGap-3.0.0/master/www/img/phonegap_step1.png

  * Make sure you check 'Copy items into destination group's folder (if needed)' and 'Add to targets'
    ![ScreenShot](https://raw.github.com/showkit/PhoneGap-3.0.0/master/www/img/phonegap_step2.png)

    
  * Select your project in the Project Navigator => 'Build Phases' => 'Link Binary With Library' => press '+' to add more frameworks and libraries...
    ![ScreenShot](https://raw.github.com/showkit/PhoneGap-3.0.0/master/www/img/phonegap_step3.png)

    * You need all of the following libraries
      * OpenGLES.framework
      * AVFoundation.framework
      * QuartzCore.framework
      * CFNetwork.framework
      * CoreVideo.framework
      * CoreGraphics.framework
      * CoreMedia.framework
      * AudioToolbox.framework
      * SystemConfiguration.framework
      * libresolv.dylib
      * libz.dylib

###Step 2. Add ShowKit-PhoneGapPlugin to your Project
   * ``git clone git@github.com:showkit/PhoneGap-3.0.0.git``
   * Drag the ShowKitPlugin into the 'Plugins' folder and copy the Showkit.js into the '/www/js' folder.
     ![ScreenShot](https://raw.github.com/showkit/PhoneGap-3.0.0/master/www/img/phonegap_step4.png)
   * Add the following line to the config.xml.
     * ``    <feature name="ShowKitPlugin">
        <param name="ios-package" value="ShowKitPlugin" />
    </feature>``
       ![ScreenShot](https://raw.github.com/showkit/PhoneGap-3.0.0/master/www/img/phonegap_step7.png)
   * Initialize the app with your ShowKit api key in index.js
     * ``ShowKit.initializeShowKit(apiKey);``
       ![ScreenShot](https://raw.github.com/showkit/PhoneGap-3.0.0/master/www/img/phonegap_step5.png)
   * Import ShowKit.js on any html where you will use ShowKit.
     * ``<script type="text/javascript" src="js/ShowKit.js"></script>``

###Step 3. Configure the Other Linker Flag
   * Add ``-lc++`` to your Other Linker Flags
     ![ScreenShot](https://raw.github.com/showkit/PhoneGap-3.0.0/master/www/img/phonegap_step6.png)

###Congratulations! Your Project is now ShowKit enabled. You can build and run your project.

