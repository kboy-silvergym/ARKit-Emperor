//
//  MaterialViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/12/23.
//  Copyright © 2018 KBOY. All rights reserved.
//

import UIKit
import ARKit
import ColorSlider
import ThicknessSlider

class MaterialViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var lightSegmentControl: UISegmentedControl!
    @IBOutlet weak var materialSegmentControl: UISegmentedControl!
    @IBOutlet weak var infoLabel: UILabel!
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    lazy var boxNode: SCNNode = {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        box.firstMaterial?.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: box)
        return node
    }()
    
    private var currentLightningModel: SCNMaterial.LightingModel? = .constant
    private var currentMaterialProprtyName: String = "diffuse"
    private var currentMaterialProprty: SCNMaterialProperty? = SCNMaterialProperty()
    private var currentColor: UIColor = .red
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene.rootNode.addChildNode(boxNode)
        
        // slider
        let colorSlider = ColorSlider(orientation: .vertical, previewSide: .left)
        colorSlider.frame = CGRect(x: view.frame.width - 20,
                                   y: view.center.y - 100,
                                   width: 20, height: 200)
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)
        view.addSubview(colorSlider)
        
        // slider
        let thickSlider = ThicknessSlider()
        thickSlider.frame = CGRect(x: 0,
                                   y: view.center.y - 72,
                                   width: 60, height: 144)
        thickSlider.slider.addTarget(self, action: #selector(type(of: self).thickSliderValueChanged), for: .valueChanged)
        view.addSubview(thickSlider)
        
        updateInfoLabel()
        currentMaterialProprty = boxNode.geometry?.firstMaterial?.diffuse
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    private func updateInfoLabel(){
        guard let currentLightningModel = currentLightningModel,
            let currentMaterialProprty = currentMaterialProprty else {
                return
        }
        infoLabel.text = currentLightningModel.rawValue + "\n"
            + currentMaterialProprtyName + "\n"
            + "intensity: " + currentMaterialProprty.intensity.description.prefix(4)
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        let color = slider.color
        currentMaterialProprty?.contents = color
        currentColor = color
        updateInfoLabel()
    }
    
    @objc func thickSliderValueChanged(_ sender: UISlider) {
        currentMaterialProprty?.intensity = CGFloat(sender.value)
        updateInfoLabel()
    }
    
    @IBAction func lightSegmentChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            currentLightningModel = .constant
        case 1:
            currentLightningModel = .blinn
        case 2:
            currentLightningModel = .lambert
        case 3:
            currentLightningModel = .phong
        case 4:
            currentLightningModel = .phong
        default:
            break
        }
        boxNode.geometry?.firstMaterial?.lightingModel = currentLightningModel!
        updateInfoLabel()
    }
    
    @IBAction func materialSegmentChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        let material = boxNode.geometry?.firstMaterial
        switch index {
        case 0:
            currentMaterialProprtyName = "diffuse"
            currentMaterialProprty = material?.diffuse
        case 1:
            currentMaterialProprtyName = "specular"
            currentMaterialProprty = material?.specular
        case 2:
            currentMaterialProprtyName = "normal"
            currentMaterialProprty = material?.normal
        case 3:
            currentMaterialProprtyName = "reflective"
            currentMaterialProprty = material?.reflective
        case 4:
            currentMaterialProprtyName = "transparent"
            currentMaterialProprty = material?.transparent
        case 5:
            currentMaterialProprtyName = "ambientOcclusion"
            currentMaterialProprty = material?.ambientOcclusion
        case 6:
            currentMaterialProprtyName = "selfIllumination"
            currentMaterialProprty = material?.selfIllumination
        case 7:
            currentMaterialProprtyName = "emission"
            currentMaterialProprty = material?.emission
        case 8:
            currentMaterialProprtyName = "multiply"
            currentMaterialProprty = material?.multiply
        case 9:
            currentMaterialProprtyName = "ambient"
            currentMaterialProprty = material?.ambient
        case 10:
            currentMaterialProprtyName = "displacement"
            currentMaterialProprty = material?.displacement
        default:
            break
        }
        updateInfoLabel()
    }
}
