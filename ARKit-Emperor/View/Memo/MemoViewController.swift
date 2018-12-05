//
//  MemoViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/09/06.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MemoViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    lazy var memoSaveURL: URL = {
        do {
            return try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent("map.arexperience")
        } catch {
            fatalError("Can't get file save URL: \(error.localizedDescription)")
        }
    }()
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        sceneView.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    @objc func tapGesture(_ recognizer: UITapGestureRecognizer) {
        guard let hitTestResult = sceneView
            .hitTest(recognizer.location(in: sceneView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first else {
                return
        }
        // anchorを設置
        let memoAnchor = ARAnchor(name: "Memo", transform: hitTestResult.worldTransform)
        sceneView.session.add(anchor: memoAnchor)
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
    
    @IBAction func saveMemo(_ sender: Any) {
        sceneView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap else {
                return
            }
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try data.write(to: self.memoSaveURL, options: [.atomic])
                self.showOKDialog(title: "Saved")
            } catch {
                self.showOKDialog(title: error.localizedDescription)
            }
        }
    }
    
    @IBAction func loadMemo(_ sender: Any) {
        guard let data = try? Data(contentsOf: memoSaveURL),
            let worldMap: ARWorldMap? = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) else {
                return
        }
        let configuration = self.defaultConfiguration
        configuration.initialWorldMap = worldMap
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        self.showOKDialog(title: "Loaded")
    }
}

// MARK: - <#ARSCNViewDelegate#>
extension MemoViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor.name == "Memo" {
            let textNode = TextNode(text: "WEDNESDAY")
            node.addChildNode(textNode)
            print("anchor is added")
        }
    }
}
