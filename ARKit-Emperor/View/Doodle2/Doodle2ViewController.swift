//
//  Doodle2ViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/12/10.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import UIKit
import ARKit

class Doodle2ViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    private var drawingNode: SCNNode?
    
    private var centerVerticesCount: Int32 = 0
    private var polygonVertices: [SCNVector3] = []
    private var indices: [Int32] = []
    
    private var pointTouching: CGPoint = .zero
    private var isDrawing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.showsStatistics = true
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
        guard let location = touches.first?.location(in: nil) else {
            return
        }
        pointTouching = location
        
        begin()
        isDrawing = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: nil) else {
            return
        }
        pointTouching = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDrawing = false
        reset()
    }
}

// MARK: - Code for create line
extension Doodle2ViewController {
    private func begin(){
        drawingNode = SCNNode()
        sceneView.scene.rootNode.addChildNode(drawingNode!)
    }
    
    private func addPointAndCreateVertices() {
        guard let camera = sceneView.pointOfView else {
            return
        }
        
        // world coordinates
        let pointWorld = sceneView.unprojectPoint(SCNVector3Make(Float(pointTouching.x), Float(pointTouching.y), 0.997))
        let pointCamera = camera.convertPosition(pointWorld, from: nil)
        
        // camera coordinates
        let x: Float = pointCamera.x
        let y: Float = pointCamera.y
        let z: Float = -0.2
        let lengthOfTriangle: Float = 0.01
        
        // triangle vertices
        
        // camera coordinates
        let vertice0InCamera = SCNVector3Make(
            x,
            y - (sqrt(3) * lengthOfTriangle / 3),
            z
        )
        let vertice1InCamera = SCNVector3Make(
            x - lengthOfTriangle / 2,
            y + (sqrt(3) * lengthOfTriangle / 6),
            z
        )
        let vertice2InCamera = SCNVector3Make(
            x + lengthOfTriangle / 2,
            y +  (sqrt(3) * lengthOfTriangle / 6),
            z
        )
        
        // world coordinates
        let vertice0 = camera.convertPosition(vertice0InCamera, to: nil)
        let vertice1 = camera.convertPosition(vertice1InCamera, to: nil)
        let vertice2 = camera.convertPosition(vertice2InCamera, to: nil)
        polygonVertices += [vertice0, vertice1, vertice2]
        centerVerticesCount += 1
        
        guard centerVerticesCount > 1 else {
            return
        }
        let n: Int32 = centerVerticesCount - 2
        let m: Int32 = 3 * n
        let nextIndices: [Int32] = [
            m    , m + 1, m + 2, // first
            m    , m + 1, m + 3,
            m    , m + 2, m + 3,
            m + 1, m + 2, m + 4,
            m + 1, m + 3, m + 4,
            m + 1, m + 2, m + 5,
            m + 2, m + 3, m + 5,
            m + 4, m + 3, m + 5, // last
        ]
        indices += nextIndices
        
        updateGeometry()
    }
    
    private func reset() {
        centerVerticesCount = 0
        polygonVertices.removeAll()
        indices.removeAll()
        drawingNode = nil
    }
    
    private func updateGeometry(){
        let source = SCNGeometrySource(vertices: polygonVertices)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        drawingNode?.geometry = SCNGeometry(sources: [source], elements: [element])
        drawingNode?.geometry?.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        drawingNode?.geometry?.firstMaterial?.isDoubleSided = true
    }
    
}

extension Doodle2ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if isDrawing {
            addPointAndCreateVertices()
        }
    }
    
}


