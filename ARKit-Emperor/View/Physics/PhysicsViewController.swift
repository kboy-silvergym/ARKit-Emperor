//
//  PhysicsViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/10/15.
//  Copyright © 2018 KBOY. All rights reserved.
//

import UIKit
import ARKit

class PhysicsViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        super.touchesBegan(touches, with: event)
        
        guard let camera = sceneView.pointOfView else { return }
        let cameraPosition = SCNVector3(0, 0, -2)
        let targetPosition = camera.convertPosition(cameraPosition, to: nil)
        let startPos: SCNVector3 = camera.convertPosition(SCNVector3Make(0, 0, -0.1), to: nil)
        showBubble(by: startPos, to: targetPosition)
    }
    
    private func showBubble(by: SCNVector3, to: SCNVector3){
        let node = getBallNode()
        node.position = by
        
        let move = SCNAction.move(to: to, duration: 5.0)
        move.timingMode = .easeIn
        node.runAction(move, completionHandler: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                node.removeFromParentNode()
            }
        })
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    private func getBallNode() -> BallNode {
        switch self.segment {
        case 0:
            let node = BallNode()
            node.setColor(color: .cyan)
            return node
        case 1:
            let node = BallNode()
            node.setColor(color: .cyan)
            node.childNodes.first?.childNodes.first?.geometry?
                .firstMaterial?.lightingModel = .physicallyBased
            node.childNodes.first?.childNodes.first?.geometry?
                .firstMaterial?.roughness.contents = 1.0
            return node
        case 2:
            let node = BallNode()
            node.setColor(color: .cyan)
            node.childNodes.first?.childNodes.first?.geometry?
                .firstMaterial?.lightingModel = .physicallyBased
            node.childNodes.first?.childNodes.first?.geometry?
                .firstMaterial?.metalness.contents = 1.0
            node.childNodes.first?.childNodes.first?.geometry?
                .firstMaterial?.reflective.contents = 1.0
            node.childNodes.first?.childNodes.first?.geometry?
                .firstMaterial?.selfIllumination.contents = UIColor.white
            return node
        case 3:
            let node = BallNode()
            node.childNodes.first?.childNodes.first?.geometry?
                .firstMaterial?.diffuse.contents = UIColor.cyan.withAlphaComponent(0.5)
            return node
        case 4:
            let node = BallNode()
            node.childNodes.first?.childNodes.first?.geometry?
                .firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "blue_paint.jpg")
            return node
        default:
            let node = BallNode()
            node.childNodes.first?.childNodes.first?.geometry?
                .firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "nuno.jpg")
            return node
        }
    }
    
    private var segment: Int = 0
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        self.segment = sender.selectedSegmentIndex
    }
    
}
