//
//  BallNode.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/10/15.
//  Copyright © 2018 KBOY. All rights reserved.
//

import SceneKit

let ballNodeName: String = "ballNode"

class BallNode: SCNNode {
    
    override init() {
        super.init()
        
        let scene = SCNScene(named: "art.scnassets/bubble.scn")
        guard let ballNode = scene?.rootNode.childNode(withName: "bubbleNode", recursively: false) else {
            fatalError("no ball node")
        }
        
        if let geometry = ballNode.childNodes.first?.geometry {
            let shape = SCNPhysicsShape(geometry: geometry, options: nil)
            self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
            self.physicsBody?.contactTestBitMask = 1
        }
        
        self.addChildNode(ballNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(color: UIColor){
        self.childNodes.first?.childNodes.first?.geometry?
            .firstMaterial?.diffuse.contents = color
    }
}

