//
//  PlaneDetectionViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/09/19.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import UIKit
import ARKit

class PlaneDetectionViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    private let device = MTLCreateSystemDefaultDevice()!
    private var fadingNode: SCNNode?
    
    lazy var boxNode: SCNNode = {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        box.firstMaterial?.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: box)
        return node
    }()

    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        return configuration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
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
        guard let camera = sceneView.pointOfView else {
            return
        }
        let cameraPos = SCNVector3Make(0, 0, -0.5)
        let position = camera.convertPosition(cameraPos, to: nil)
        boxNode.position = position
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
}

extension PlaneDetectionViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        // アニメーション用のPlaneNode
        if #available(iOS 11.3, *) {
            let planeGeometry = ARSCNPlaneGeometry(device: device)!
            planeGeometry.update(from: planeAnchor.geometry)
            planeGeometry.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "camera_surface_2")
            planeGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(2, 2, 0)
            planeGeometry.firstMaterial?.diffuse.wrapS = .repeat
            planeGeometry.firstMaterial?.diffuse.wrapT = .repeat
            let planeNode = SCNNode(geometry: planeGeometry)
            planeNode.castsShadow = false
            planeNode.position.y = planeNode.position.y + 0.001 // ちょっと浮かす
            planeNode.opacity = 0.0
            planeNode.renderingOrder = -2
            node.addChildNode(planeNode)
        }
        let extent = planeAnchor.extent
        let plane = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2
        planeNode.renderingOrder = -1
        
        switch planeAnchor.alignment {
        case .horizontal:
            planeNode.name = "horizontalPlane"
        case .vertical:
            planeNode.name = "veriticalPlane"
        }
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        let extent = planeAnchor.extent
        
        // アニメーション用のPlaneNode
        if #available(iOS 11.3, *), let planeNode = findShapedPlaneNode(on: node),
            let geometry = planeNode.geometry as? ARSCNPlaneGeometry {
            geometry.update(from: planeAnchor.geometry)
            fadeNode(node: planeNode)
        }
        
        if let planeNode = node.childNode(withName: "horizontalPlane", recursively: false) {
            let plane = SCNPlane(width: CGFloat(extent.x),
                                 height: CGFloat(extent.z))
            plane.firstMaterial?.colorBufferWriteMask = []
            planeNode.geometry = plane
            planeNode.castsShadow = false
            
            let center = planeAnchor.center
            planeNode.position = SCNVector3Make(center.x, 0, center.z)
        }
        
        if let vrticalPlaneNode = node.childNode(withName: "veriticalPlane", recursively: false) {
            let plane = SCNPlane(width: CGFloat(extent.x),
                                 height: CGFloat(extent.z))
            plane.firstMaterial?.colorBufferWriteMask = []
            vrticalPlaneNode.geometry = plane
            vrticalPlaneNode.castsShadow = false
            
            let center = planeAnchor.center
            vrticalPlaneNode.position = SCNVector3Make(center.x, center.y, center.z)
        }
    }
    
    @available(iOS 11.3, *)
    private func findShapedPlaneNode(on node: SCNNode) -> SCNNode? {
        for childNode in node.childNodes {
            if childNode.geometry as? ARSCNPlaneGeometry != nil {
                return childNode
            }
        }
        return nil
    }
    
    private func fadeNode(node: SCNNode){
        if node == fadingNode {
            return
        }
        let fadeIn = SCNAction.fadeOpacity(to: 0.3, duration: 1)
        let fadeOut = SCNAction.fadeOut(duration: 4)
        let group = SCNAction.sequence([fadeIn, fadeOut])
        node.runAction(group, completionHandler: {
            node.removeFromParentNode()
            self.fadingNode = nil
        })
        fadingNode = node
    }
}
