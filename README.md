# Measurement-App-AR
Measurement App built with SwiftUI, RealityKit and ARKit

User taps on two points on a detected plane. The distance between both points is computed and relayed back to the user.

The taps are configured as Raycasts, and upon a successful hit event (i.e. intersection between ray and the detected plane), the (x,y,z) position of the tap location is added as an anchor to the scene. 

Project Demo: https://www.youtube.com/shorts/DafUQZaQFrQ

<img width="471" alt="Screen Shot 2022-10-04 at 7 22 12 AM" src="https://user-images.githubusercontent.com/7616530/193844867-37d8ba47-7752-43d8-a9be-9994841a1f20.png">
