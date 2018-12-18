//
//  PhyisicsViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/12/18.
//  Copyright © 2018 KBOY. All rights reserved.
//

import UIKit
import ARKit

class PhyisicsViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var hitLabel: UILabel! {
        didSet {
            hitLabel.isHidden = true
        }
    }
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    lazy var boxNode: SCNNode = {
        let cylinder = SCNCylinder(radius: 0.1, height: 0.05)
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        box.firstMaterial?.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: box)
        node.name = "box"
        node.position = SCNVector3Make(0, 0, -1.5)
        
        // add PhysicsShape
        let shape = SCNPhysicsShape(geometry: box, options: nil)
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        node.physicsBody?.isAffectedByGravity = false
        
        return node
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene.physicsWorld.contactDelegate = self
        
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
        let ball = SCNSphere(radius: 0.1)
        ball.firstMaterial?.diffuse.contents = UIColor.blue
        
        let node = SCNNode(geometry: ball)
        node.name = "ball"
        node.position = SCNVector3Make(0, 0.1, 0)
        
        // add PhysicsShape
        let shape = SCNPhysicsShape(geometry: ball, options: nil)
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        node.physicsBody?.contactTestBitMask = 1
        node.physicsBody?.isAffectedByGravity = false
        
        if let camera = sceneView.pointOfView {
            node.position = camera.position
            
            let toPositionCamera = SCNVector3Make(0, 0, -3)
            let toPosition = camera.convertPosition(toPositionCamera, to: nil)
            
            let move = SCNAction.move(to: toPosition, duration: 0.5)
            move.timingMode = .easeOut
            node.runAction(move) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    node.removeFromParentNode()
                }
            }
        }
        sceneView.scene.rootNode.addChildNode(node)
    }
    
}

extension PhyisicsViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        if (nodeA.name == "box" && nodeB.name == "ball")
            || (nodeB.name == "box" && nodeA.name == "ball") {
            
            DispatchQueue.main.async {
                self.hitLabel.text = "HIT!!"
                self.hitLabel.sizeToFit()
                self.hitLabel.isHidden = false
                
                // Vibration
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                     self.hitLabel.isHidden = true
                }
            }
        }
    }
}
