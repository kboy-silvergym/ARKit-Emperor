//
//  ShaderViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/12/22.
//  Copyright © 2018 KBOY. All rights reserved.
//

import UIKit
import ARKit

class ShaderViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    lazy var boxNode: SCNNode = {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        box.firstMaterial?.diffuse.contents = UIColor.darkGray
        let node = SCNNode(geometry: box)
        node.categoryBitMask = 2
        return node
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene.rootNode.addChildNode(boxNode)
        
        if let path = Bundle.main.path(forResource: "NodeTechnique", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String : Any] {
            
            let technique = SCNTechnique(dictionary: dict)
            sceneView.technique = technique
        }
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
