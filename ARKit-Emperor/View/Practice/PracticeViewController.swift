//
//  PracticeViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/12/07.
//  Copyright © 2018 KBOY. All rights reserved.
//

import UIKit
import ARKit

class PracticeViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        return configuration
    }()
    
    lazy var boxNode: SCNNode = {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        box.firstMaterial?.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: box)
        return node
    }()
    
    private var selectedSegmentIndex: Int = 0
    private var holding: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        
        titleLabel.text = "place infront of camera"
        
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
        guard let point = touches.first?.location(in: sceneView) else {
                    return
        }
        switch selectedSegmentIndex {
        case 0: // カメラの前に置く
            placeInFrontOfCamera()
        case 1:
            placeSameYWithCamera()
        case 2: // スクリーンのタップしたところに置く
            placeInFrontOfScreen(point)
        case 3: // タップして平面, 垂直面に置く
            placeToPlane(point)
        case 4:
            lookAtMe()
        case 5:
            lookAsSameWithMe()
        case 6 :
            shoot()
        case 7:
            holding = !holding
        default:
            break
        }
    }
    
    private func placeInFrontOfCamera(){
        guard let camera = sceneView.pointOfView else {
            return
        }
        let cameraPos = SCNVector3Make(0, 0, -0.5)
        let position = camera.convertPosition(cameraPos, to: nil)
        boxNode.position = position
    }
    
    private func placeSameYWithCamera(){
        guard let camera = sceneView.pointOfView else {
            return
        }
        let cameraPos = SCNVector3Make(0, 0, -0.5)
        var position = camera.convertPosition(cameraPos, to: nil)
        position.y = camera.position.y
        boxNode.position = position
    }
    
    private func placeInFrontOfScreen(_ point: CGPoint){
        let infrontOfCamera = SCNVector3(x: 0, y: 0, z: -0.5)
        
        guard let cameraNode = sceneView.pointOfView else { return }
        let pointInWorld = cameraNode.convertPosition(infrontOfCamera, to: nil)
        
        var screenPos = sceneView.projectPoint(pointInWorld)
        
        screenPos.x = Float(point.x)
        screenPos.y = Float(point.y)
        
        let finalPosition = sceneView.unprojectPoint(screenPos)
        boxNode.position = finalPosition
    }
    
    private func placeToPlane(_ point: CGPoint){
        guard let horizontalHit = sceneView.hitTest(
            point,
            types: .existingPlaneUsingGeometry
            ).first else {
                return
        }
        let column3: simd_float4 = horizontalHit.worldTransform.columns.3
        let position = SCNVector3(column3.x, column3.y, column3.z)
        boxNode.position = position
    }
    
    private func lookAtMe(){
        guard let camera = sceneView.pointOfView else {
            return
        }
        boxNode.look(at: camera.position)
    }
    
    private func lookAsSameWithMe(){
        guard let camera = sceneView.pointOfView else {
            return
        }
        boxNode.eulerAngles = camera.eulerAngles
    }
    
    private func shoot(){
        guard let camera = sceneView.pointOfView else {
            return
        }
        boxNode.position = camera.position
        
        let targetPosCamera = SCNVector3Make(0, 0, -2)
        let target = camera.convertPosition(targetPosCamera, to: nil)
        let action = SCNAction.move(to: target, duration: 1)
        boxNode.runAction(action)
    }
    
    @IBAction func segmentChaged(_ sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        holding = false
        
        switch selectedSegmentIndex {
        case 0: // カメラの前に置く
            titleLabel.text = "place infront of camera"
        case 1:
            titleLabel.text = "place same Y with Camera"
        case 2: // スクリーンのタップしたところに置く
            titleLabel.text = "place in front of screen"
        case 3: // タップして平面, 垂直面に置く
            titleLabel.text = "place to plane"
        case 4:
            titleLabel.text = "look at me"
        case 5:
            titleLabel.text = "look as same with me"
        case 6 :
            titleLabel.text = "shoot"
        case 7:
            titleLabel.text = "hold"
            holding = true
        default:
            break
        }
    }
}

extension PracticeViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if holding {
            placeInFrontOfCamera()
        }
    }
}
