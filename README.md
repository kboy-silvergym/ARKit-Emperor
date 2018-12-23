<img width="900" alt="thum" src="https://user-images.githubusercontent.com/17683316/45263530-90de8980-b465-11e8-846f-9e04a5e80874.png">

![arkit](https://img.shields.io/badge/ARKit-2.0-brightgreen.svg) ![platform](https://img.shields.io/badge/platform-ios-blue.svg) ![ios](https://img.shields.io/badge/ios-11.0%2B-blue.svg) ![swift](https://img.shields.io/badge/swift-4.2-orange.svg) ![license](https://img.shields.io/badge/license-MIT-lightgrey.svg)
 <a href="https://twitter.com/kboy_silvergym">![tw](https://img.shields.io/badge/twitter-%40kboy__silvergym-blue.svg)</a>
 
A long time ago in a galaxy, far, far away...

It is a period when iPhone SE and iPhone X were destroyed from the apple store, the AR market was under pressure by the Pokemon GO. 

During the Battle, Rebel spies managed to steal the data of the secret plans of ARKit 2.0...

# What's this?

This is the dark side of [ARKit-Sampler](https://github.com/shu223/ARKit-Sampler).

The Emperor give you the most practical ARKit samples ever.

**Unlimited power for ARKit!**

# Samples

## Practice

|Place infront of camera|Place same Y with Camera|Place in front of tapped|Place to plane|
|:--:|:--:|:--:|:--:|
|<img src="images/0.gif" width=140>|<img src="images/1.gif" width=140>|<img src="images/2.gif" width=140>|<img src="images/3-0.gif" width=140>|

|Look at me|Look as same with me|Shoot|Hold|
|:--:|:--:|:--:|:--:|
|<img src="images/4.gif" width=140>|<img src="images/5.gif" width=140>|<img src="images/6.gif" width=140>|<img src="images/7.gif" width=140>|

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Practice)

## Gesture

|Scale|Rotation|
|:--:|:--:|
|<img src="images/scale.gif" width=140>|<img src="images/rotate.gif" width=140>|

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Gesture)

## Doodle

<img src="images/drawing.gif" width=140>

You can draw to the real space! This sample code is very simple but perfomance is not perfect because it adds a new node every time your finger moves. 

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Doodle)

## Doodle2

<img src="images/drawing2.gif" width=140>

This sample is better than `Doodle1`  because the geometry is created once each line. If you customize the vertices and indices logic, you can create any line you want. But the logic is so complicated.

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Doodle2)

## Custom 3D Model from Bezier Path

<img src="images/star.gif" width=140>

You can create 3D model by code using bezier path

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/CustomModel)

## Material

|Lightning Model|Material Property|Intesity|
|:--:|:--:|:--:|
|<img src="images/lightning_model.gif" width=140>|<img src="images/material_property.gif" width=140>|<img src="images/intensity.gif" width=140>|

Let's debug how to change the appearance of node.

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Material)

## Placing pictures

<img src="images/picture.gif" width=140>

Place your photo into the picture frame. You can make picture frames on SceneKit.

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Picture)

## SCNAction

<img src="images/action.gif" width=140>

Use SCNAction to  your object appeares more naturally.

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Action)

## Bubble mixed with your image

<img src="images/bubble.gif" width=140>

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Bubble)

## Physics

<img src="images/physics.gif" width=140>

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Physics)


## Color Grading

|<img src="images/lut0.jpg">|<img src="images/lut1.png">|<img src="images/lut2.png">|<img src="images/lut3.png">|
|:-:|:-:|:-:|:-:|
|<img src="images/colorGrading.gif" width=140>|<img src="images/lut1demo.gif" width=140>|<img src="images/lut2demo.gif" width=140>|<img src="images/lut3demo.gif" width=140>|

You can make camera fileter using a LUT image.

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/ColorGrading)

## Particle

|bokeh|confetti|fire|rain|reactor|smoke|star|
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|<img src="images/bokeh.gif" width=140>|<img src="images/confetti.gif" width=140>|<img src="images/fire.gif" width=140>|<img src="images/rain.gif" width=140>|<img src="images/reactor.gif" width=140>|<img src="images/smoke.gif" width=140>|<img src="images/star_particle.gif" width=140>|

Show default particle system.

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Particle)

## Shader

Inspired by https://github.com/laanlabs/SCNTechniqueGlow

Apple's official docs is https://developer.apple.com/documentation/scenekit/scntechnique

<img src="images/shader.gif" width=140>

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Shader)

## ARPointCloud

In default, you can show feature points easily by coding below.

```swift
sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
```

In this table, `default` is the default one.

|default|custom1|custom2|
|:-:|:-:|:-:|
|<img src="images/point1.gif" width=140>|<img src="images/point2.gif" width=140>|<img src="images/point3.gif" width=140>|

If you show feature points like custom1 or custom2, chek [the code](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/ARPointCloud).

## Plane Detection (ARKit 1.5~)

|horizontal|vertical|
|:--:|:--:|
|<img src="images/plane.gif" width=140>|<img src="images/plane2.gif" width=140>|

The plane detection can be available by ARKit 1.0, but this richer (available for not only rectangle) detection is available by 1.5.

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/PlaneDetection)

And you can implement simple occlusion like below.

<img src="images/occlusion.gif" width=140>

## Face

<img src="images/tongue.gif" width=140>

By ARKit2.0, you can detect also gaze and tongue. This demo is using tongue detection.

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Face)

## Persistent Memo (ARKit 2.0~)

<img src="images/memo.gif" width=140>

Using ARKit 2.0, you can save ARWorldMap and load it.

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Memo)

## Mirror (ARKit 2.0~)

<img src="images/mirror.gif" width=140>

Using ARKit 2.0, It's not perfect but the object reflect around the environment.

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/Mirror)

## Business Card (ARKit 2.0~)

|Show|Tap|
|:-:|:-:|
|<img src="images/business_card1.gif" width=140>|<img src="images/business_card2.gif" width=140>|

Augmented business card. If you register the image of your card, ARKit2.0 detects it and the 3D component made in SceneKit can be shown.

If you get the error (`Make sure that all reference images are greater than 100 pixels and have a positive physical size in meters.`), check [the stack overflow](https://stackoverflow.com/questions/49006651/invalid-reference-image-arkit-1-5).

The code is [here](https://github.com/kboy-silvergym/ARKit-Emperor/tree/master/ARKit-Emperor/View/BusinessCard)

## Detecting your Remote (ARKit 2.0~)

<img src="images/remote.gif" width=140>

Using ARKit 2.0,  now you can scan 3D object.

The code is **WIP**. Wait a days to be completed..

Note that the Apple doesn't recommend you to use ARObjectScanningConfiguration for production use.

>ARObjectScanningConfiguration is for use only in development scenarios. High-fidelity spatial mapping has a high performance and energy cost, and disables ARKit features not necessary for reference object scanning. To produce AR experiences for end users, use ARWorldTrackingConfiguration. https://developer.apple.com/documentation/arkit/arobjectscanningconfiguration

# Author

<img src ="images/kboy1.jpg" width=140>

**KBOY (Kei Fujikawa)**

iOS Developer in Tokyo Japan, working on AR startup named [Graffity Inc.](https://www.graffity.jp/)

- [Twitter](https://twitter.com/kboy_silvergym) / [Facebook](https://www.facebook.com/kei.fujikawa1)
- [LinkedIn](https://www.linkedin.com/in/kei-fujikawa) / [Wantedly](https://www.wantedly.com/users/17820205)

# Special Thanks

The thumbnail is designed by [@shujihirai](https://twitter.com/shujihirai)
