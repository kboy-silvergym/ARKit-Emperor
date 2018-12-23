//
//  ThicknessSlider.swift
//  ThicknessSlider
//
//  Created by Kei Fujikawa on 2018/12/23.
//  Copyright © 2018 KBOY. All rights reserved.
//

import UIKit

public class ThicknessSlider: UIView {
    static let width: CGFloat = 60
    static let height: CGFloat = 144
    
    public let slider = VerticalUISlider()
    
    var originalX: CGFloat?
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "common_camera_brushsize_bar"))
        return imageView
    }()
    
    public init(){
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: type(of: self).width,
                                 height: type(of: self).height))
        
        // 背景画像を後ろに敷く
        let point = CGPoint(x: self.frame.origin.x + type(of: self).width/4 - 2, y: self.frame.origin.y)
        let size = CGSize(width: type(of: self).width/2, height: type(of: self).height)
        backgroundImageView.frame = CGRect(origin: point, size: size)
        addSubview(backgroundImageView)
        
        // たてのUISliderおく
        // 背景画像より縦幅がカーソル分でかい
        let thumbSize: CGFloat = 28
        slider.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: self.frame.origin.y - thumbSize/2),
                              size: CGSize(width: frame.size.width,
                                           height: frame.size.height + thumbSize))
        addSubview(slider)
        
        //        slider.addTarget(self, action: #selector(type(of: self).touchDragInside), for: .touchDragInside)
        //
        //        slider.addTarget(self, action: #selector(type(of: self).sliderValueChanged), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func touchDragInside(_ sender: UISlider) {
        show()
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        hide()
    }
    
    func setOriginalX(){
        self.originalX = self.frame.origin.x
    }
    
    public func show(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.frame.origin.x = self.originalX! + self.frame.size.width/4
        }, completion: { finished in
        })
    }
    
    public func hide(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.frame.origin.x = self.originalX!
        }, completion: { finished in
        })
    }
}

public class VerticalUISlider: UISlider {
    
    init(){
        super.init(frame: .zero)
        self.transform = CGAffineTransform(rotationAngle: -.pi/2)
        
        self.tintColor = .clear
        self.maximumTrackTintColor = .clear
        self.isContinuous = false
        self.setThumbImage(#imageLiteral(resourceName: "common_camera_brushsize_oval"), for: .normal)
        
        self.sizeToFit()
        self.value = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Use properly calculated rect
        var newRect = super.trackRect(forBounds: bounds)
        // 太さ
        newRect.size.height = 60
        return newRect
    }
    
}

