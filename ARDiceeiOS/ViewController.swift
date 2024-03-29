//
//  ViewController.swift
//  ARDiceeiOS
//
//  Created by Fischer, Thomas Alfons on 5/10/19.
//  Copyright © 2019 aft3000. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        
        //        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.01, chamferRadius: 0.01)
        //
        //
        //
        //        let material = SCNMaterial()
        //        material.diffuse.contents = UIColor.red
        //        cube.materials = [material]
        
        // https://www.solarsystemscope.com
        
        //        let moon = SCNSphere(radius: 0.2)
        //        let materialSphere = SCNMaterial()
        //        materialSphere.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")
        //        moon.materials = [materialSphere]
        //        let node = SCNNode()
        //        node.position = SCNVector3(x:0, y: 0.1, z: -0.5)
        //        node.geometry = moon
        //
        //        sceneView.scene.rootNode.addChildNode(node)
        
        
        
        sceneView.autoenablesDefaultLighting = true
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true){
            diceNode.position = SCNVector3(0,  0, -0.1)
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        print("Session is supported: \(ARWorldTrackingConfiguration.isSupported)")
        print("ARWorldTrackingSession is supported: \(ARWorldTrackingConfiguration.isSupported)")
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor{
            print("plane detected")
            let planeAncher = anchor as! ARPlaneAnchor
            
        // 1 getting a plane from the anchor
            let plane = SCNPlane(width: CGFloat(planeAncher.extent.x), height: CGFloat(planeAncher.extent.z))
        // 2 getting a SCNNode from anchor and rotate 90
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(planeAncher.center.x, 0.0, planeAncher.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        // 3 create material
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            
            // 4 add to final node
            node.addChildNode(planeNode)
            
        }else{
            print("not ARPlaneAnchor detected")
        }
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
