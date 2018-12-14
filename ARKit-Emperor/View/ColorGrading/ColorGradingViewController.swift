//
//  ColorGradingViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/12/14.
//  Copyright © 2018 KBOY. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ColorGradingViewController: UIViewController {
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
    
    private var isFilterd: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene.rootNode.addChildNode(boxNode)
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
        isFilterd = !isFilterd
        
        if isFilterd {
            sceneView.pointOfView?.camera?.colorGrading.contents = #imageLiteral(resourceName: "sepia")
        } else {
            sceneView.pointOfView?.camera?.colorGrading.contents = nil
        }
    }
    
}

extension ColorGradingViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
}
