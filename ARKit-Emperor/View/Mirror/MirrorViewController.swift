//
//  MirrorViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/09/10.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import ARKit
import UIKit

class MirrorViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    private var mirrorNode: SCNNode = {
        let node = SCNScene(named: "art.scnassets/mirror.scn")!
            .rootNode.childNode(withName: "mirror", recursively: false)
        return node!
    }()
    
    private var virtualObject: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        sceneView.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    @objc func tapGesture(_ recognizer: UITapGestureRecognizer) {
        // カメラ座標系で2m前
        let infrontOfCamera = SCNVector3(x: 0, y: 0, z: -2)
        
        // カメラ座標系 -> ワールド座標系
        guard let cameraNode = sceneView.pointOfView else { return }
        let pointInWorld = cameraNode.convertPosition(infrontOfCamera, to: nil)
        
        // ワールド座標系 -> スクリーン座標系
        // スクリーン座標系でx, yだけ指の位置に変更
        var screenPos = sceneView.projectPoint(pointInWorld)
        let finger = recognizer.location(in: nil)
        screenPos.x = Float(finger.x)
        screenPos.y = Float(finger.y)
        
        // ワールド座標に戻す
        let position = sceneView.unprojectPoint(screenPos)
        
        // nodeを置く
        mirrorNode.position = position
        sceneView.scene.rootNode.addChildNode(mirrorNode)
    }
}

extension MirrorViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
       
    }
    
}

extension float4x4 {
    
    var translation: float3 {
        let translation = columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

