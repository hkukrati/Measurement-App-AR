import SwiftUI
import RealityKit
import ARKit
import UIKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        //Configuration for the arView
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)
        
        context.coordinator.arView = arView
        
        // Configure the Coordinator to handle gestures/tap events
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        
        // Add AR coaching to guide the user in detecting a horizontal plane. Coordinator acts as the delegate
        let coachingView = ARCoachingOverlayView()
        coachingView.goal = .horizontalPlane
        coachingView.session = arView.session
        coachingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingView.delegate = context.coordinator as? any ARCoachingOverlayViewDelegate
        arView.addSubview(coachingView)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    //Make Coordinator function to communicate changes between ViewController and SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
