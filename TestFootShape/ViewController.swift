//
//  ViewController.swift
//  TestFootShape
//
//  Created by 吴迪玮 on 2017/10/16.
//  Copyright © 2017年 吴迪玮. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var scene:SCNScene! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.automaticallyUpdatesLighting = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        // Create a new scene
        scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @IBAction func actionTap(_ sender: UITapGestureRecognizer) {
        // 获取屏幕空间坐标并传递给 ARSCNView 实例的 hitTest 方法
        let tapPoint = sender.location(in: sceneView)
        let result = sceneView.hitTest(tapPoint, types: [.featurePoint])
        
        // 如果射线与某个平面几何体相交，就会返回该平面，以离摄像头的距离升序排序
        // 如果命中多次，用距离最近的平面
        if let _ = result.first {
            let node = (SCNScene(named: "shape.scnassets/footShape.scn")?.rootNode.childNode(withName: "plane", recursively: true))!
            node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
//            node.physicsBody?.mass = 1
//            node.physicsBody?.categoryBitMask = 2
            
            node.position = SCNVector3Make(sceneView.pointOfView!.position.x, sceneView.pointOfView!.position.y-1.4, sceneView.pointOfView!.position.z)
            if let rotation = sceneView.pointOfView?.rotation {
                node.rotation = rotation
            }
            
//            let footShape = FootShape(isLeft: true, withNode: sceneView.pointOfView!)
            scene.rootNode.addChildNode(node)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else {
            return
        }
        
//        let footShape = FootShape(isLeft: true, withAnchor: anchor)
//        scene.rootNode.addChildNode(footShape)
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
