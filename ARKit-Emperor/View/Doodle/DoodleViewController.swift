//
//  DoodleViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/09/10.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import UIKit
import ARKit

class DoodleViewController: UIViewController {
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
        begin()
        isDrawing = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDrawing = false
        reset()
    }
}

extension DoodleViewController {
    private func drawBallLine(_ point: CGPoint){
        let point3D = sceneView.unprojectPoint(SCNVector3(point.x, point.y, 0.997))
        
        let node: SCNNode
        
        if let drawingNode = drawingNode {
            node = drawingNode.clone()
        } else {
            node = createBallLine()
            drawingNode = node
        }
        node.position = point3D
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    private func createBallLine() -> SCNNode {
        let ball = SCNSphere(radius: 0.005)
        ball.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        let node = SCNNode(geometry: ball)
        return node
    }
    
    private func createPathLine() -> SCNNode {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0.005))
        path.addLine(to: CGPoint(x: 0.005, y: 0))
        path.addLine(to: CGPoint(x: 0, y: -0.005))
        path.addLine(to: CGPoint(x: -0.005, y: 0))
        path.close()
        
        let shape = SCNShape(path: path, extrusionDepth: 0.01)
        shape.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        shape.chamferRadius = 0.005
        
        let node = SCNNode(geometry: shape)
        return node
    }
}

extension DoodleViewController {
    private func begin(){
        drawingNode = SCNNode()
        sceneView.scene.rootNode.addChildNode(drawingNode!)
    }
    
    private func addPointAndCreateVertices() {
        guard let camera = sceneView.pointOfView else {
            return
        }
        
        // camera coordinates
        let x: Float = 0
        let y: Float = 0
        let lengthOfTriangle: Float = 0.01
        let cameraZ: Float = -0.2
        
        // triangle vertices
        
        // camera coordinates
        let vertice0InCamera = SCNVector3Make(x, (1 - lengthOfTriangle / sqrt(3)) * y, cameraZ)
        let vertice1InCamera = SCNVector3Make(x - lengthOfTriangle / 2, y + (sqrt(3) * lengthOfTriangle / 2), cameraZ)
        let vertice2InCamera = SCNVector3Make(x + lengthOfTriangle / 2, y +  (sqrt(3) * lengthOfTriangle / 2), cameraZ)
        
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

extension DoodleViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if isDrawing {
            addPointAndCreateVertices()
        }
    }
    
}

