//
//  FaceViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/09/10.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import UIKit
import ARKit

class FaceViewController: UIViewController {
    @IBOutlet weak var arSceneView: ARSCNView!
    @IBOutlet weak var previewSceneView: SCNView!
    
    let defaultConfiguration: ARFaceTrackingConfiguration = {
        let configuration = ARFaceTrackingConfiguration()
        return configuration
    }()
    
    private lazy var airPlaneNode: SCNNode = previewSceneView.scene!.rootNode.childNode(withName: "ship", recursively: true)!
    
    var isAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arSceneView.delegate = self
        arSceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        previewSceneView.scene = SCNScene(named: "art.scnassets/ship.scn")
        previewSceneView.alpha = 0.8
        previewSceneView.layer.cornerRadius = 5
        previewSceneView.clipsToBounds = true
        previewSceneView.isPlaying = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arSceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arSceneView.session.pause()
    }
    
}

extension FaceViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return
        }
        
        if let tongueOut = faceAnchor.blendShapes[.tongueOut] as? Float {
            
            if tongueOut > 0.5, !isAnimating {
                isAnimating = true
                
                let action = SCNAction.rotateBy(x: 0, y: 0, z: .pi, duration: 0.3)
                
                airPlaneNode.runAction(action, completionHandler: {
                    self.isAnimating = false
                })
            }
        }
    }
}

