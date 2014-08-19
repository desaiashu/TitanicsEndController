iPhone App to Control Titanic's End
-----------------------------------

**Setup**

Set your computer's local IP address on line 20 in MainViewController.m. For example:

    NSString *serverIP = @"10.0.1.125";

**Usage**

Run the [Titanic's End Control System](https://github.com/nottombrown/TitanicsEnd) on your computer before you launch the app.

Closing and reopening the app will reconnect to the Control System.

**About**

Connects to the Titanic's End Control System via OSC. Controls the active pattern + all basic parameters.

**Known Issues**

If you change the pattern through the Java applet, it won't update the app. Changing parameters through MIDI *should* update the app.