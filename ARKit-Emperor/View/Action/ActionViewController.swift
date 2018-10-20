//
//  ThreeDModelViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/10/20.
//  Copyright © 2018 KBOY. All rights reserved.
//

import UIKit
import ARKit
import SceneKit.ModelIO

class ActionViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    private lazy var planeNode: SCNNode = createPlaneNode()
    private lazy var flamingoNode: SCNNode = {
        let scene = SCNScene(named: "art.scnassets/flamingo.scn")
        let node = scene!.rootNode
        return node
    }()
    
    lazy var feedback = UINotificationFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        feedback.prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pos = self.sceneView.center
        guard let result = sceneView.hitTest(pos, types: .existingPlane).first else {
            return
        }
        let float3 = result.worldTransform.translation
        let position = SCNVector3(float3)
        flamingoNode.position = position
        flamingoNode.scale = SCNVector3(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(flamingoNode)
        feedback.notificationOccurred(.success)
        
        let scaleAction = SCNAction.scale(by: 100, duration: 0.4)
        let rotateAction = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: .pi/2)
        rotateAction.duration = 0.4
        let action = SCNAction.group([scaleAction, rotateAction])
        flamingoNode.runAction(action)
    }
    
    private func createOrMoveBox(screenPos: CGPoint) {
        guard let result = sceneView.hitTest(screenPos, types: .existingPlane).first else {
            return
        }
        let float3 = result.worldTransform.translation
        let position = SCNVector3(float3)
        planeNode.position = position
        sceneView.scene.rootNode.addChildNode(planeNode)
    }
    
    private func createPlaneNode() -> SCNNode {
        let node = SCNNode()
        let plane = SCNPlane(width: 0.05, height: 0.05)
        plane.firstMaterial?.diffuse.contents = UIColor.purple
        node.geometry = plane
        node.opacity = 0.25
        node.eulerAngles.x = -.pi/2
        return node
    }
    
}

extension ActionViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            let pos = self.sceneView.center
            self.createOrMoveBox(screenPos: pos)
        }
    }
}
