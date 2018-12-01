//
//  CustomModelViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/12/01.
//  Copyright © 2018 KBOY. All rights reserved.
//

import UIKit
import ARKit

class CustomModelViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        createStar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    private func createStar(){
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.1, y: 0.5))       //A
        path.addLine(to: CGPoint(x: 0.1, y: 0.1))    //B
        path.addLine(to: CGPoint(x: 0.3, y: 0.1))       //C
        path.addLine(to: CGPoint(x: -0.1, y: -0.5))  //D
        path.addLine(to: CGPoint(x: -0.1, y: -0.1))  //E
        path.addLine(to: CGPoint(x: -0.3, y: -0.1))  //F
        path.close()
        
        let shape = SCNShape(path: path, extrusionDepth: 0.2)
        let color = #colorLiteral(red: 1, green: 0.9913478494, blue: 0, alpha: 1)
        shape.firstMaterial?.diffuse.contents = color
        shape.chamferRadius = 0.1
        
        let boltNode = SCNNode(geometry: shape)
        boltNode.position.z = -1
        sceneView.scene.rootNode.addChildNode(boltNode)
    }
}

extension CustomModelViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
}
