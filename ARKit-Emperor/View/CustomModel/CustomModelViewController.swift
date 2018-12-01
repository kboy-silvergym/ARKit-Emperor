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
        let starPath = UIBezierPath
            .polygon(.starVertexes(
                in: CGRect(origin: .zero, size: CGSize(width: 1, height: 1)),
                roundness: 50,
                numberOfVertexes: 5))
        let shape = SCNShape(path: starPath, extrusionDepth: 0.2)
        let color = #colorLiteral(red: 1, green: 0.9913478494, blue: 0, alpha: 1)
        shape.firstMaterial?.diffuse.contents = color
        shape.chamferRadius = 0.08
        
        let boltNode = SCNNode(geometry: shape)
        boltNode.position.z = -1
        boltNode.eulerAngles.x = .pi
        sceneView.scene.rootNode.addChildNode(boltNode)
    }
}

extension CustomModelViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
}

// MARK: - Array<CGPoint>
private extension Array where Element == CGPoint {
    static func starVertexes(in frame: CGRect, roundness: CGFloat, numberOfVertexes vertexes: Int) -> [CGPoint] {
        return starVertexes(
            radius: Swift.min(frame.width, frame.height)/2,
            center: CGPoint(x: frame.midX, y: frame.midY),
            roundness: Swift.max(Swift.min(roundness, 100), 0)/100,
            numberOfVertexes: Swift.max(vertexes, 2))
    }
    
    private static func starVertexes(radius: CGFloat, center: CGPoint, roundness: CGFloat, numberOfVertexes vertexes: Int) -> [CGPoint] {
        let vertexes = (vertexes * 2)
        return [Int](0...vertexes).map { offset in
            let r = (offset % 2 == 0) ? radius : roundness * radius
            let θ = CGFloat(offset)/CGFloat(vertexes) * (2 * CGFloat.pi) - CGFloat.pi/2
            return CGPoint(x: r * cos(θ) + center.x, y: r * sin(θ) + center.y)
        }
    }
}

// MARK: - UIBezierPath
private extension UIBezierPath {
    static func polygon(_ vertexes: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: vertexes.first!)
        vertexes.forEach { path.addLine(to: $0) }
        path.close()
        return path
    }
}
