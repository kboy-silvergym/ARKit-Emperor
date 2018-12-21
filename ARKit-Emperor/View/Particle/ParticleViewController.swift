//
//  PerticleViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/12/20.
//  Copyright © 2018 KBOY. All rights reserved.
//

import UIKit

import UIKit
import ARKit

enum Particles: String {
    case bokeh
    case confetti
    case fire
    case rain
    case reactor
    case smoke
    case stars
    
    static var order: [Particles] = [
        .bokeh,
        .confetti,
        .fire,
        .rain,
        .reactor,
        .smoke,
        .stars
    ]
}

class ParticleViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    private var selectedParticle: Particles = .bokeh
    private var currentParticleNode: SCNNode?
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        addParticle(selectedParticle)
    }
    
    private func addParticle(_ particle: Particles){
        currentParticleNode?.removeFromParentNode()
        
        let particle = SCNParticleSystem(named: particle.rawValue + ".scnp", inDirectory: "art.scnassets")
        let particleNode = SCNNode()
        particleNode.addParticleSystem(particle!)
        particleNode.scale = SCNVector3Make(0.5, 0.5, 0.5)
        
        if let camera = sceneView.pointOfView {
            let pos = SCNVector3Make(0, -0.5, -3)
            let position = camera.convertPosition(pos, to: nil)
            particleNode.position = position
        }
        sceneView.scene.rootNode.addChildNode(particleNode)
        
        currentParticleNode = particleNode
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
       selectedParticle = Particles.order[sender.selectedSegmentIndex]
    }
}

extension ParticleViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
}
