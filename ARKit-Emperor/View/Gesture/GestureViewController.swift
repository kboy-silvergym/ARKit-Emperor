//
//  GestureViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/12/17.
//  Copyright © 2018 KBOY. All rights reserved.
//

import UIKit
import ARKit

class GestureViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    lazy var boxNode: SCNNode = {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        box.firstMaterial?.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: box)
        return node
    }()
    
    private var lastGestureScale: Float = 1
    private var lastGestureRotation: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene.rootNode.addChildNode(boxNode)
        
        // scale gesture
        let pinch = UIPinchGestureRecognizer(
            target: self,
            action: #selector(type(of: self).scenePinchGesture(_:))
        )
        pinch.delegate = self
        sceneView.addGestureRecognizer(pinch)
        
        // rotate gesture
        let rotaion = UIRotationGestureRecognizer(
            target: self,
            action: #selector(type(of: self).sceneRotateGesture(_:))
        )
        rotaion.delegate = self
        sceneView.addGestureRecognizer(rotaion)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    @objc func scenePinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began {
            lastGestureScale = 1
        }
        
        let newGestureScale: Float = Float(recognizer.scale)
        let diff = newGestureScale - lastGestureScale
        
        let currentScale = boxNode.scale
        boxNode.scale = SCNVector3Make(
            currentScale.x * (1 + diff),
            currentScale.y * (1 + diff),
            currentScale.z * (1 + diff)
        )
        lastGestureScale = newGestureScale
    }
    
    @objc func sceneRotateGesture(_ recognizer: UIRotationGestureRecognizer) {
        let newGestureRotation = Float(recognizer.rotation)
        
        if recognizer.state == .began {
            lastGestureRotation = 0
        }
        let diff = newGestureRotation - lastGestureRotation
        
        let eulerY = boxNode.eulerAngles.y
        boxNode.eulerAngles.y = eulerY - diff
        
        lastGestureRotation = newGestureRotation
    }
    
}

extension GestureViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
}
