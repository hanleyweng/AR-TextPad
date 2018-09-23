# AR-TextPad
Typing in Augmented Reality demo.

![](post-media/3b-typing.gif)

A prototype showing how to display a textView in head-worn ARKit, and type to it with a keyboard.

_(Found this old demo laying around, and thought it might be helpful for others to riff off.)_

Written in XCode 10.0 for iOS 11.3 and above.
Running: Scenekit. 
NOTE: A Bluetooth Wireless Keyboard is required.
NOTE: An AR see-through headset like the Merge VR is required.

![](outside-view.jpg)

# Instructions
Connect a Bluetooth Keyboard to your iPhone.
Type CMD+R to begin.
Type CMD+1 to toggle between having the text-view fixed to your screen or the world. 

![](instructions.jpg)

# Building Process (see commit history)

1. Added ARSCNStereoViewClass for Stereo Vision (see other Github repo https://github.com/hanleyweng/iOS-ARKit-Headset-View )

2. Add in Text View and clone it into AR Scenes.

3. Add Keyboard Commands to toggle the Text View between Screen and World Spaces.

---

Have fun! 😁