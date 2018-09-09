//
//  TextNode.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/09/09.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import SceneKit

class TextNode: SCNNode {
    init(text: String) {
        super.init()
        
        let scnText = SCNText()
        scnText.extrusionDepth = 10
        scnText.chamferRadius = 0.1
        scnText.font = UIFont(name: "StarJedi", size: 36)
        self.geometry = scnText
        
        self.eulerAngles.x = -.pi/8
        self.eulerAngles.y = -.pi/6
        
        self.scale = SCNVector3Make(0.005, 0.005, 0.005)
        
        makeColor(borderColor: .red, backgroundColor: .white)
        setText(text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String){
        let scnText = self.geometry as! SCNText
        scnText.string = text
        
        makePivotCenter()
    }
    
    private func makePivotCenter(){
        let (min, max) = (self.boundingBox)
        let w = Float(max.x - min.x)
        let h = Float(max.y - min.y)
        self.pivot = SCNMatrix4MakeTranslation(w/2 + min.x, h/2 + min.y, 0)
    }
    
    private func makeColor(borderColor: UIColor, backgroundColor: UIColor) {
        let m1 = SCNMaterial()
        m1.diffuse.contents = backgroundColor
        
        let m2 = SCNMaterial()
        m2.diffuse.contents = backgroundColor
        
        let m3 = SCNMaterial()
        m3.diffuse.contents = borderColor
        
        geometry?.materials = [m1, m2, m3]
    }
}
