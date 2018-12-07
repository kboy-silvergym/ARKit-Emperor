//
//  PracticeViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/12/07.
//  Copyright © 2018 KBOY. All rights reserved.
//

import UIKit
import ARKit

class PracticeViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    lazy var boxNode: SCNNode = {
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.01)
        box.firstMaterial?.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: box)
        return node
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
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
        guard let location = touches.first?.location(in: sceneView),
            let horizontalHit = sceneView.hitTest(location,
                                                  types: .existingPlaneUsingExtent).first else {
                                                    return
        }
        let float3 = horizontalHit.worldTransform.translation
        let position = SCNVector3(float3)
        boxNode.position = position
        
        // カメラの方を向かせる
        if let camera = sceneView.pointOfView {
            boxNode.eulerAngles.y = camera.eulerAngles.y
        }
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
}

extension PracticeViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
}
