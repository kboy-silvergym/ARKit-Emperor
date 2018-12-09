//
//  DoodleViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/09/10.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import UIKit
import ARKit

class DoodleViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    var drawingNode: SCNNode?
    
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: sceneView) else {
            return
        }
        let point3D = sceneView.unprojectPoint(SCNVector3(point.x, point.y, 0.997))
        
        let node: SCNNode
        
        if let drawingNode = drawingNode {
            node = drawingNode.clone()
        } else {
            node = createBallLine()
            drawingNode = node
        }
        node.position = point3D
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func createBallLine() -> SCNNode {
        let ball = SCNSphere(radius: 0.005)
        ball.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        let node = SCNNode(geometry: ball)
        return node
    }
    
    func createPathLine() -> SCNNode {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0.005))
        path.addLine(to: CGPoint(x: 0.005, y: 0))
        path.addLine(to: CGPoint(x: 0, y: -0.005))
        path.addLine(to: CGPoint(x: -0.005, y: 0))
        path.close()
        
        let shape = SCNShape(path: path, extrusionDepth: 0.01)
        shape.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        shape.chamferRadius = 0.005
        
        let node = SCNNode(geometry: shape)
        return node
    }
}

extension DoodleViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
}
