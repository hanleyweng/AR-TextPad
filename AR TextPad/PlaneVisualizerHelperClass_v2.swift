//
//  PlaneVisualizerHelperClass.swift
//  AR Text
//
//  Created by Hanley Weng on 1/7/18.
//  Copyright © 2018 CompanyName. All rights reserved.
//

import Foundation
import ARKit

class PlaneVisualizerHelperClass {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Place content only for anchors found by plane detection.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create a SceneKit plane to visualize the plane anchor using its position and extent.
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        // A. CHECKER MODE
        plane.firstMaterial?.diffuse.contents = UIImage(named: "checker-200")
        plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(planeAnchor.extent.x / 0.2 , planeAnchor.extent.z / 0.2 , 0)
        plane.firstMaterial?.diffuse.wrapS = .repeat
        plane.firstMaterial?.diffuse.wrapT = .repeat
        
        // B. PLANE DISPLAY MODE
//        plane.firstMaterial?.diffuse.contents = UIColor.orange
//        plane.firstMaterial?.isDoubleSided = true
        
        // C. WIREFRAME MODE
//        plane.firstMaterial?.fillMode = .lines // ~ // ~ Temp ; wireframe mode.
        
        // Add Plane
        let planeNode = SCNNode(geometry: plane)
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        // `SCNPlane` is vertically oriented in its local coordinate space, so rotate the plane to match the horizontal orientation of `ARPlaneAnchor`.
        planeNode.eulerAngles.x = -.pi / 2
        
        // Make the plane visualization semitransparent to clearly show real-world placement.
        planeNode.opacity = 0.25
        
        
        /*
         Add the plane visualization to the ARKit-managed node so that it tracks
         changes in the plane anchor as plane estimation continues.
         */
        node.addChildNode(planeNode)
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Update content only for plane anchors and nodes matching the setup created in `renderer(_:didAdd:for:)`.
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // H: Update material (Checker)
        plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(planeAnchor.extent.x / 0.2 , planeAnchor.extent.z / 0.2 , 0) // Every 10 cm
        
        // Plane estimation may shift the center of a plane relative to its anchor's transform.
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        /*
         Plane estimation may extend the size of the plane, or combine previously detected
         planes into a larger one. In the latter case, `ARSCNView` automatically deletes the
         corresponding node for one plane, then calls this method to update the size of
         the remaining plane.
         */
        plane.width = CGFloat(planeAnchor.extent.x)
        plane.height = CGFloat(planeAnchor.extent.z)
    }
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // ~ Double Check - to ensure node is removed //~ //~
        guard let planeNode = node.childNodes.first
            else { return }
        planeNode.removeFromParentNode()
        print("planenode removed from parent node")
    }
}
