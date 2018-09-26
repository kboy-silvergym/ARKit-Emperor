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
    @IBOutlet weak var scanButton: UIButton!
    
    let defaultConfiguration: ARObjectScanningConfiguration = {
        let configuration = ARObjectScanningConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()
    
    lazy var objectSaveURL: URL = {
        do {
            return try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent("remote.arobject")
        } catch {
            fatalError("Can't get file save URL: \(error.localizedDescription)")
        }
    }()
    
    private lazy var feedbackGenerator = UINotificationFeedbackGenerator()
    private var boundingBoxNode: SCNNode?
    private var fixedNode: SCNNode?
    private let boxExtent: float3 = float3(0.1, 0.05, 0.2)
    private var isScanning: Bool = false {
        didSet {
            scanButton.isEnabled = isScanning
            scanButton.alpha = isScanning ? 1.0 : 0.3
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.preferredFramesPerSecond = 30
        
        scanButton.isEnabled = false
        scanButton.alpha = 0.5
        
        feedbackGenerator.prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            let object = try ARReferenceObject(archiveURL: objectSaveURL)
            let configuration = ARWorldTrackingConfiguration()
            configuration.detectionObjects = [object]
            self.sceneView.session.run(configuration)
        } catch {
            sceneView.session.run(defaultConfiguration)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isScanning {
            self.fixedNode?.removeFromParentNode()
        } else {
            
            if let fixedBoxNode = boundingBoxNode?.clone() {
                fixedBoxNode.opacity = 0.6
                fixedBoxNode.name = "detectedRemote"
                self.fixedNode = fixedBoxNode
                self.sceneView.scene.rootNode.addChildNode(fixedBoxNode)
                self.feedbackGenerator.notificationOccurred(.success)
            }
        }
        isScanning = !isScanning
    }
    
    private func showOKDialog(title: String, message: String? = nil, ok: String = "OK", completion: (() -> Void)? = nil){
        DispatchQueue.main.async {
            let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: ok, style: .default, handler: { _ in
                completion?()
            })
            alert.addAction(defaultAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func createOrMoveBox(screenPos: CGPoint) {
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
            
            if let node = createNewBox(screenPos: screenPos) {
                self.boundingBoxNode = node
            }
        }
        
        if let boundingBox = boundingBoxNode,
            boundingBoxNode?.parent == nil {
            self.sceneView.scene.rootNode.addChildNode(boundingBox)
        }
    }
    
    private func createNewBox(screenPos: CGPoint) -> SCNNode? {
        guard let result = sceneView.hitTest(screenPos,
                                             types: .existingPlane).first else {
            return nil
        }
        let boundingBoxNode = SCNNode()
        let box = SCNBox(width: CGFloat(boxExtent.x),
                         height: CGFloat(boxExtent.y),
                         length: CGFloat(boxExtent.z),
                         chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.yellow
        boundingBoxNode.geometry = box
        boundingBoxNode.opacity = 0.25
        
        let float3 = result.worldTransform.translation
        let position = SCNVector3(float3)
        boundingBoxNode.position = position
        
        if let camera = sceneView.pointOfView {
            boundingBoxNode.eulerAngles.y = camera.eulerAngles.y
        }
        return boundingBoxNode
    }

    @IBAction func scanButtonTapped(_ sender: Any) {
        if let node = fixedNode {
            sceneView.session.createReferenceObject(
                transform: node.simdTransform,
                center: float3(node.position),
                extent: boxExtent,
                completionHandler: { object, error in
                    
                    if let error = error {
                        DispatchQueue.main.async {
                            self.showOKDialog(title: error.localizedDescription)
                        }
                    }else if let object = object {
                        do {
                            try object.export(to: self.objectSaveURL, previewImage: nil)
                        } catch {
                            print(error.localizedDescription)
                            self.showOKDialog(title: error.localizedDescription)
                        }
                        
                    }
            })
        }
    }
}

extension RemoteViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !isScanning else {
            self.boundingBoxNode?.removeFromParentNode()
            return
        }
        DispatchQueue.main.async {
            let pos = self.sceneView.center
            self.createOrMoveBox(screenPos: pos)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let objectAnchor = anchor as? ARObjectAnchor {
            print("detected!: \(anchor.name)")
            
        }
    }
}
