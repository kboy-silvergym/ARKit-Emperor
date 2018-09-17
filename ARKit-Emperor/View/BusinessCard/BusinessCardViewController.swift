//
//  BusinessCardViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/09/10.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import UIKit
import ARKit

class BusinessCardViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        configuration.detectionImages = images
        configuration.maximumNumberOfTrackedImages = 1
        return configuration
    }()
    
    private var buttonNode: SCNNode!
    private var card2Node: SCNNode!
    
    private let feedback = UIImpactFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        buttonNode = SCNScene(named: "art.scnassets/social_buttons.scn")!.rootNode.childNode(withName: "buttons", recursively: false)
        
        feedback.prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
}

extension BusinessCardViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return nil
        }
        
        switch imageAnchor.referenceImage.name {
        case "card1" :
            DispatchQueue.main.async {
                self.feedback.impactOccurred()
            }
            return buttonNode
        case "card2" :
            DispatchQueue.main.async {
                self.feedback.impactOccurred()
            }
            return buttonNode
        default:
            return nil
        }
    }
}

