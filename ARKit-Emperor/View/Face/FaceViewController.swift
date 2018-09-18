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
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARFaceTrackingConfiguration = {
        let configuration = ARFaceTrackingConfiguration()
        return configuration
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

extension FaceViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return
        }
        print(faceAnchor.rightEyeTransform)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return
        }
        print(faceAnchor.rightEyeTransform)
    }
}

