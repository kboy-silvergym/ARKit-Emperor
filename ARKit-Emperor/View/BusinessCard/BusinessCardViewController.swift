//
//  BusinessCardViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/09/10.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import UIKit
import ARKit
import SafariServices

class BusinessCardViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    // NOTE: The imageConfiguration is better for tracking images,
    // but it has less features,
    // for example it does not have the plane detection.
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        configuration.detectionImages = images
        configuration.maximumNumberOfTrackedImages = 1
        return configuration
    }()
    
    let imageConfiguration: ARImageTrackingConfiguration = {
        let configuration = ARImageTrackingConfiguration()
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        configuration.trackingImages = images!
        configuration.maximumNumberOfTrackedImages = 1
        return configuration
    }()
    
    private var buttonNode: SCNNode!
    private var card2Node: SCNNode!
    
    private let feedback = UIImpactFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        buttonNode = SCNScene(named: "art.scnassets/social_buttons.scn")!.rootNode.childNode(withName: "card", recursively: false)
        let thumbnailNode = buttonNode.childNode(withName: "thumbnail", recursively: true)
        thumbnailNode?.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "kboy_profile")
        
        feedback.prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(imageConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView),
        let result = sceneView.hitTest(location, options: nil).first else {
            return
        }
        let node = result.node
        
        if node.name == "facebook" {
            let safariVC = SFSafariViewController(url: URL(string: "https://www.facebook.com/kei.fujikawa1")!)
            self.present(safariVC, animated: true, completion: nil)
        } else if node.name == "twitter" {
            let safariVC = SFSafariViewController(url: URL(string: "https://twitter.com/kboy_silvergym")!)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
}

extension BusinessCardViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return nil
        }
        
        switch imageAnchor.referenceImage.name {
        case "a" :
            DispatchQueue.main.async {
                self.feedback.impactOccurred()
            }
            buttonNode.scale = SCNVector3(0.1, 0.1, 0.1)
            let scale1 = SCNAction.scale(to: 1.5, duration: 0.2)
            let scale2 = SCNAction.scale(to: 1, duration: 0.1)
            scale2.timingMode = .easeOut
            let group = SCNAction.sequence([scale1, scale2])
            buttonNode.runAction(group)
            
            return buttonNode
        case "b" :
            return nil
        default:
            return nil
        }
    }
}
