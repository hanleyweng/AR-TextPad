//
//  ViewController.swift
//  AR TextPad
//
//  Created by Hanley Weng on 9/22/18.
//  Copyright © 2018 Emerging Interactions. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // UI - Default AR Scene View
    @IBOutlet var sceneView: ARSCNView!
    
    // UI - Stereoscopic AR
    @IBOutlet weak var imageViewLeft: UIImageView!
    @IBOutlet weak var imageViewRight: UIImageView!
    @IBOutlet weak var sceneViewLeft: ARSCNView!
    @IBOutlet weak var sceneViewRight: ARSCNView!
    
    // PARAMETRES
    let viewBackgroundColor : UIColor = UIColor.black // UIColor.white
    
    // CLASSES
    var arScnStereoViewClass = ARSCNStereoViewClass()
    var planeVisualizerHelperClass = PlaneVisualizerHelperClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Scene/View setup
        self.view.backgroundColor = viewBackgroundColor
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Setup Stereo SceneView (including showing statistics, creating a new scene)
        arScnStereoViewClass.viewDidLoad_setup(iSceneView: sceneView, iSceneViewLeft: sceneViewLeft, iSceneViewRight: sceneViewRight, iImageViewLeft: imageViewLeft, iImageViewRight: imageViewRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            // UPDATE AR SCENE
            // ...
            
            // UPDATE STEREO VIEWS
            self.arScnStereoViewClass.updateFrame()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        planeVisualizerHelperClass.renderer(renderer, didAdd: node, for: anchor)
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        planeVisualizerHelperClass.renderer(renderer, didUpdate: node, for: anchor)
    }
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
//        planeVisualizerHelperClass.renderer(renderer, didRemove: node, for: anchor)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
