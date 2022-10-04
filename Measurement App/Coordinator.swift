import Foundation
import RealityKit
import SwiftUI
import ARKit

// Coordinator class conforms to ARCoachingOverlayViewDelegate protocol
class Coordinator: NSObject, ARCoachingOverlayViewDelegate {
    
    var arView: ARView?
    
    var anchorPoint1:AnchorEntity?
    var anchorPoint2:AnchorEntity?
    var measurementButton:UIButton = UIButton(configuration: .filled())
    var resetButton:UIButton = UIButton(configuration: .gray())
    
    // Intended functionality is for user to tap on two points within the detected plane and have a sphere mark each point. Distance between
    // both points should be relayed back to user via text
    @objc func handleTap (_ recognizer: UITapGestureRecognizer){
        // guard to ensure that arView exists before we proceed
        guard let arView = arView else { return }
        
        if (anchorPoint2 == nil)
        {
            // The user tapping on the screen initiates a Raycast, and the hit results are stored in results as an array of type [ARRaycastResult]
            let tappedLocation = recognizer.location(in: arView)
            let results = arView.raycast(from: tappedLocation, allowing: .estimatedPlane, alignment: .horizontal)
            
            //Exit the function if the Raycast is unsuccessful i.e. user did not tap on a point on the detected plane
            if results.isEmpty {
                return
            }
            
            //Red sphere models for both points
            let sphere = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.01), materials: [SimpleMaterial(color: UIColor.red, isMetallic: false)])
            
            if (anchorPoint1 == nil)
            {
                //An anchor is created at the point where the user tapped
                //Sphere model is attached to the anchor and the anchor is added to the scene
                anchorPoint1 = (AnchorEntity(raycastResult: results[0]))
                anchorPoint1?.addChild(sphere)
                arView.scene.addAnchor(anchorPoint1!)
            }
            else
            {
                //Second anchor point is added here
                anchorPoint2 = (AnchorEntity(raycastResult: results[0]))
                anchorPoint2?.addChild(sphere)
                arView.scene.addAnchor(anchorPoint2!)
                
                // Since the user has selected two points, we can calculate the distance between bpth anchor positions and relay it back to the user
                let distance = simd_distance(anchorPoint1!.position(relativeTo: nil), anchorPoint2!.position(relativeTo: nil))
                let measurement = String(format: "%.2f m",distance)
                
                measurementButton.setTitle(measurement, for: .normal)
                measurementButton.setTitleColor(UIColor.blue, for: .normal)
            }
        }
    }
    
    func setupUI() {
        //function guards to check ARView
        guard let arView = arView else { return }
        
        // Use a stackview to hold both the measurement button and reset button
        let stackView = UIStackView(arrangedSubviews: [measurementButton, resetButton])
        
        stackView.axis = .horizontal
        stackView.spacing = 80
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        measurementButton.setTitle("0 m", for: .normal)
        measurementButton.translatesAutoresizingMaskIntoConstraints = false
        measurementButton.isUserInteractionEnabled = false
        measurementButton.configuration?.baseBackgroundColor = UIColor.lightGray
        measurementButton.frame.size = CGSizeMake(150, 70)
        measurementButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        resetButton.widthAnchor.constraint(equalToConstant: 100).isActive = true

        arView.addSubview(stackView)
        
        //Set constraints for the stack view
        stackView.centerXAnchor.constraint(equalTo: arView.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    // UIButton action for reset button. Clears all anchors from the scene and resets the measurement
    @objc func buttonAction(_ sender:UIButton!) {
        anchorPoint1 = nil
        anchorPoint2 = nil
        
        arView?.scene.anchors.removeAll()
        measurementButton.setTitle("0 m", for: .normal)
        measurementButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        // Delegate function from ARCoachingOverlayViewDelegate protocol.
        // Activates only after AR coaching is completed i.e. we only show the UI after plane is detected
        setupUI()
    }
}



