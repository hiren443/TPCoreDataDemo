//
//  CircleChartView.swift
//  OnDotDemo
//
//  Created by Hiren Bhadreshwara on 18/09/17.
//  Copyright © 2017 Hiren Bhadreshwara. All rights reserved.
//

import Foundation
import UIKit

class CircleChartView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var endArc:CGFloat = 0.0{   // in range of 0.0 to 1.0
        didSet{
            setNeedsDisplay()
        }
    }
    var arcWidth:CGFloat = 10.0
    
    var arcColor = UIColor.cyan
    var arcBackgroundColor = UIColor.clear
    var isPie = false
    
    override func draw(_ rect: CGRect) {
        
        //Important constants for circle
        let fullCircle = 2.0 * CGFloat(M_PI)
        let start:CGFloat = -0.25 * fullCircle
        let end:CGFloat = endArc * fullCircle + start
        
        //find the centerpoint of the rect
        let centerPoint = CGPoint(x: rect.midX,y: rect.midY)
        
        //define the radius by the smallest side of the view
        var radius:CGFloat = 0.0
        if rect.width > rect.height{
            radius = (rect.width - arcWidth) / 2.0
        }else{
            radius = (rect.height - arcWidth) / 2.0
        }
        
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        //set colorspace
        //let colorspace = CGColorSpaceCreateDeviceRGB()
        //set line attributes
        context!.setLineWidth(arcWidth)
        context!.setLineCap(CGLineCap.round)
        
        //make the circle background
        
        
        context!.setStrokeColor(arcBackgroundColor.cgColor)
        context!.setFillColor(arcBackgroundColor.cgColor)
        context?.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: fullCircle, clockwise: true)
        context!.strokePath()
        
        
        //draw the arc or pie
        
        if isPie {
            context!.setFillColor(arcColor.cgColor)
            context!.move(to: centerPoint)
            context?.addArc(center: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: true)
            context!.fillPath()
        }else{
            context!.setStrokeColor(arcColor.cgColor)
            context!.setLineWidth(arcWidth * 1 )
            context?.addArc(center: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: true)
            context!.strokePath()
        }
        
    }
    
    
    
}
