//
//  TextEditorHelperClass.swift
//  AR Text
//
//  Created by Hanley Weng on 1/6/18.
//  Copyright © 2018 CompanyName. All rights reserved.
//

// Notes 2017-12-14:
// Note: Wooh - 23.57 - tested - and it works surprisingly great for a 240x240 box.
// Note 2: Tried different themes (light and dark, dark = dark-grey bg) - both worked fine to be honest. White was default - so some defaults like correction-highlighting works better there. Dark-grey, slightly easier on eyes-maybe. But both just as legible. Surprisingly legible tbh. (Then again - this textBox is the size of 2 tweets.
// Note 2017-12-15 : Interesting glitch, where - on autocomplete, there's a white highlight around completed word (so if white font, it just looks like a white box). On closer inspection - it seems apple subtly animates that word up for a pop-up correction. (nice)

// Note 2017-12-17 - for now; in Storyboard; added a Navigation Controller to prop everything down a bit for the headset - not the best solution - but a temporary one that is ok for now.


import Foundation
import UIKit
import SceneKit
import ARKit

class TextEditHelperClass {
    
    var textDoneTimer0:Timer = Timer()
    var textDoneTimer1:Timer = Timer()
    var textDoneTimer2:Timer = Timer()
    var textDoneTimer3:Timer = Timer()
    
    // UI References
    var sceneView: ARSCNView!
    var textView: UITextView!
    var textPlaneNode:SCNNode = SCNNode()
    
    private var textViewDefaultPosition:SCNVector3 = SCNVector3Make(0, -0.1, -0.7)
    
    func setup(sceneViewRef: ARSCNView, textViewRef: UITextView) {
        
        sceneView = sceneViewRef
        textView = textViewRef
        
        // UITextView SETUP
        // textView.becomeFirstResponder()
        
        // CREATE SCENE NODES
        createPlaneNode()
        
        // MODE
        updateFromMode()
        
        // Initial Capture
        captureTextView()
    }
    
    func createPlaneNode() {
        let tw:CGFloat = 0.3, th:CGFloat = 0.3
        textPlaneNode = SCNNode(geometry: SCNPlane(width: tw, height: th))
        textPlaneNode.geometry?.firstMaterial?.isDoubleSided = true
        textPlaneNode.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        textPlaneNode.position = SCNVector3(0, 0, -0.3)   
        sceneView.scene.rootNode.addChildNode(textPlaneNode)
        
        // Create Image to attach to textPlaneNode
        let anchorLabelNode = SCNNode(geometry: SCNPlane(width: 0.05, height: 0.05))
        anchorLabelNode.geometry?.firstMaterial?.isDoubleSided = true
        anchorLabelNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "anchor")
        anchorLabelNode.pivot = SCNMatrix4MakeTranslation(-0.05/2, +0.05/2, 0)
        anchorLabelNode.position = SCNVector3(+tw/2 + 0.01, +th/2, 0)
        anchorLabelNode.opacity = 0.5
        
        textPlaneNode.addChildNode(anchorLabelNode)
    }
    
    func light_reflectTextChange() {
        // Capture image with cursor
        textDoneTimer3.invalidate()
        textDoneTimer3 = Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(editDone), userInfo: textDoneTimer3, repeats: false)
    }
    
    func textViewDidChangeSelection_reflectTextChanges() {
        // (Fires when typing or cursor changes position)
        
        // DELAYS:
        // 0.001 - Give the cursor some time to catch up.
        // White Highlight (x- Finishes Flashing at) will hide itself at: 0.1 > … > 0.15
        // Pop-Down auto-correction word suggestion is: 0.2 > 0.25 > 0.3 > … > 0.5  // generally none are caught at 0.2, most are caught by 0.25/0.3, all should be caught by 0.5 ( i think)
        // Note: Starter-Range Indictor's dot doesn't display for this - it must not be part of textView's layer.
        
        // Reset Timer // ~
        textDoneTimer0.invalidate()
        textDoneTimer0 = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(editDone), userInfo: textDoneTimer0, repeats: false)
        textDoneTimer1.invalidate()
        textDoneTimer1 = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(editDone), userInfo: textDoneTimer1, repeats: false)
        textDoneTimer2.invalidate()
        textDoneTimer2 = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(editDone), userInfo: textDoneTimer2, repeats: false)
        textDoneTimer3.invalidate()
        textDoneTimer3 = Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(editDone), userInfo: textDoneTimer3, repeats: false)
        // Note: By turning on repeat of ~ 0.1, we can show a blinking cursor. (probably blinking every 0.5 seconds
        
        // In general: We should fire once
    }
    
    @objc func editDone(timer:Timer) {
        captureTextView()
        timer.invalidate()
    }
    
    func captureTextView() {
        
        // ~ https://stackoverflow.com/questions/3539717/getting-a-screenshot-of-a-uiscrollview-including-offscreen-parts
        
        // Note: UITextView Style is handled in the storyboard
        
        let boundsSize:CGSize = textView.bounds.size
        
        UIGraphicsBeginImageContextWithOptions(boundsSize, false, 1)
        // Store Origin State
        let savedContentOffset:CGPoint = textView.contentOffset
        let savedFrame:CGRect = textView.frame
        
        textView.alpha = 1.0
        guard let context:CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // Translate Origin for TextView Content Position
        context.translateBy(x: -textView.contentOffset.x, y: -textView.contentOffset.y)
        // Render TextView Layer to Context
        textView.layer.render(in: context)
        // Reflect change in SceneKit Node
        textPlaneNode.geometry?.firstMaterial?.diffuse.contents = UIGraphicsGetImageFromCurrentImageContext()
        
        //
        
        textView.alpha = 0.0
        // Reset to Origin State
        textView.frame = savedFrame
        textView.contentOffset = savedContentOffset
        UIGraphicsEndImageContext()
    }
    
    func updateFrame() {
        if _MODE_FIXED {
            self.textPlaneNode.position = (self.sceneView.pointOfView?.convertPosition(textViewDefaultPosition, to: nil))!
        }
    }
    
    ///////////////////////////////////////////////////////
    // KEYBOARD
    
    var _MODE_FIXED = true
    
    func customKeyPressed_toggleMode(sender: UIKeyCommand) {
        toggleMode()
    }
    
    func toggleMode() {
        _MODE_FIXED = !_MODE_FIXED
        updateFromMode()
    }
    
    private func updateFromMode() {
        if _MODE_FIXED {
            textPlaneNode.constraints = [SCNBillboardConstraint()]
        } else {
            textPlaneNode.constraints = []
            
            self.textPlaneNode.position = (self.sceneView.pointOfView?.convertPosition(textViewDefaultPosition, to: nil))!
        }
    }
}

