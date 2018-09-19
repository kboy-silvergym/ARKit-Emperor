//
//  RemoteViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/09/10.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import UIKit
import ARKit

class RemoteViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()
    
    private var boundingBoxNode: SCNNode?

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.preferredFramesPerSecond = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    private func createReferenceObject(completionHandler creationFinished: @escaping (ARReferenceObject?) -> Void) {
        guard let boundingBox = boundingBoxNode else {
            creationFinished(nil)
            return
        }
        sceneView.session.createReferenceObject(
            transform: boundingBox.simdTransform,
            center: float3(),
            extent: float3(),
            completionHandler: { object, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    creationFinished(nil)
                }else if let object = object {
                    creationFinished(object)
                }
        })
    }
    
    private func setReferenceObject(_ object: ARReferenceObject) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionObjects = [object]
        self.sceneView.session.run(configuration)
    }
    
    private func createOrMoveBoundingBox(screenPos: CGPoint) {
        if let boundingBox = self.boundingBoxNode {
            guard let result = sceneView.hitTest(screenPos, types: .existingPlane).first else {
                return
            }
            let float3 = result.worldTransform.translation
            let position = SCNVector3(float3)
            boundingBox.position = position
            
            if let camera = sceneView.pointOfView {
                boundingBox.eulerAngles.y = camera.eulerAngles.y
            }
        } else {
            createBoundingBox(screenPos: screenPos)
        }
    }
    
    private func createBoundingBox(screenPos: CGPoint) {
        guard let result = sceneView.hitTest(screenPos,
                                             types: .existingPlane).first else {
            return
        }
        let boundingBoxNode = SCNNode()
        let box = SCNBox(width: 0.1, height: 0.05, length: 0.2, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.yellow
        boundingBoxNode.geometry = box
        boundingBoxNode.opacity = 0.25
        
        self.boundingBoxNode = boundingBoxNode
        self.sceneView.scene.rootNode.addChildNode(boundingBoxNode)
        
        let float3 = result.worldTransform.translation
        let position = SCNVector3(float3)
        boundingBoxNode.position = position
    }

    @IBAction func scanButtonTapped(_ sender: Any) {
        createReferenceObject(completionHandler: { object in
            if let object = object {
                self.setReferenceObject(object)
            }
        })
    }
}

extension RemoteViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            let pos = self.sceneView.center
            self.createOrMoveBoundingBox(screenPos: pos)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let objectAnchor = anchor as? ARObjectAnchor {
            print("detected!")
        }
    }
}
