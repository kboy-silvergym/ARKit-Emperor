//
//  ARPointCloudViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/12/23.
//  Copyright © 2018 KBOY. All rights reserved.
//

import UIKit
import ARKit

class ARPointCloudViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    private var featurePoints: [SCNNode] = []
    private lazy var sphereNode: SCNNode = {
        let node = SCNNode()
        let geometry = SCNSphere(radius: 0.001)
        geometry.firstMaterial?.diffuse.contents = UIColor.red
        node.geometry = geometry
        return node
    }()
    
    private lazy var coneNode: SCNNode = {
        let node = SCNNode()
        let geometry = SCNCone(topRadius: 0.001, bottomRadius: 0.01, height: 0.03)
        geometry.firstMaterial?.diffuse.contents = UIColor.red
        node.geometry = geometry
        return node
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}

extension ARPointCloudViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let frame = sceneView.session.currentFrame,
            let pointPositions = frame.rawFeaturePoints?.points else {
            return
        }
        // Remove past points
        self.featurePoints.forEach { $0.removeFromParentNode() }
        
        // Create point nodes
        let featurePointNodes: [SCNNode] = pointPositions.map { position in
            let node = sphereNode.clone()
            node.position = SCNVector3(position.x, position.y, position.z)
            return node
        }
        
        // Add new points
        featurePointNodes.forEach { sceneView.scene.rootNode.addChildNode($0) }
        
        // Save nodes
        self.featurePoints = featurePointNodes
    }
}
