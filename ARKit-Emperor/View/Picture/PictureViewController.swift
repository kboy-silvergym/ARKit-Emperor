//
//  PictureViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/09/10.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import UIKit
import ARKit

class PictureViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    lazy var pictureTableNode: SCNNode = {
        let scene = SCNScene(named: "art.scnassets/pictureTable.scn")!
        let node = scene.rootNode.childNode(withName: "tableNode", recursively: false)!
        node.name = "tablePictureNode"
        
        // 写真のnode
        let picture = SCNBox(width: 0.5, height: 0.5, length: 0.01, chamferRadius: 0)
        picture.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "kboy_profile")
        let pictureNode = SCNNode(geometry: picture)
        
        // frameに貼る
        let frameNode = node.childNode(withName: "frame", recursively: true)
        frameNode?.addChildNode(pictureNode)
        
        node.scale = SCNVector3(x: 0.3, y: 0.3, z: 0.3)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView),
            let horizontalHit = sceneView.hitTest(location,
                                                  types: .existingPlaneUsingExtent).first else {
                                                    return
        }
        let float3 = horizontalHit.worldTransform.translation
        let position = SCNVector3(float3)
        pictureTableNode.position = position
        
        // カメラの方を向かせる
        if let camera = sceneView.pointOfView {
            pictureTableNode.eulerAngles.y = camera.eulerAngles.y
        }
        sceneView.scene.rootNode.addChildNode(pictureTableNode)
    }
    
}

extension PictureViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
}

