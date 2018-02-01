//
//  GradientView.swift
//  GarbageAlarm-Design
//
//  Created by WonIk on 2018. 1. 28..
//  Copyright © 2018년 WonIk. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var FirstColor: UIColor = UIColor.clear{
        didSet {
            updateView()
        }
    }
    @IBInspectable var SecondColor: UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    
    override class var layerClass : AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [ FirstColor.cgColor, SecondColor.cgColor ]
//        layer.locations = [ 0.3 ] 
        layer.startPoint = CGPoint(x: 0.0, y: 0.2)
        layer.endPoint = CGPoint(x: 1.0, y: 0.8)
    }
}
