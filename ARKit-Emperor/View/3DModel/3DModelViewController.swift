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

class ThreeDModelViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    private var planeNode: SCNNode?
    private lazy var flamingoNode: SCNNode = {
        let scene = SCNScene(named: "art.scnassets/flamingo.scn")
        let node = scene!.rootNode
        return node
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUsdz()
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
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
        sceneView.scene.rootNode.addChildNode(flamingoNode)
    }
    
    func loadUsdz() {
//        guard let url = Bundle.main.url(forResource: "flamingo", withExtension: "usdz") else { fatalError() }
//        let mdlAsset = MDLAsset(url: url)
//        let scene = SCNScene(mdlAsset: mdlAsset)
    }
    
    private func createOrMoveBox(screenPos: CGPoint) {
        guard let result = sceneView.hitTest(screenPos, types: .existingPlane).first else {
            return
        }
        let float3 = result.worldTransform.translation
        let position = SCNVector3(float3)
        
        if let planeNode = self.planeNode {
            planeNode.position = position
        } else {
            self.planeNode = createPlaneNode()
            self.planeNode!.position = position
            self.sceneView.scene.rootNode.addChildNode(planeNode!)
        }
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

extension ThreeDModelViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            let pos = self.sceneView.center
            self.createOrMoveBox(screenPos: pos)
        }
    }
}
