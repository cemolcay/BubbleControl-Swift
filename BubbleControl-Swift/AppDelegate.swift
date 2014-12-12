//
//  AppDelegate.swift
//  BubbleControl-Swift
//
//  Created by Cem Olcay on 11/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var bubble: BubbleControl!

    var animateIcon: Bool = false {
        didSet {
            if animateIcon {
                bubble.didToggle = { on in
                    if let shapeLayer = self.bubble.imageView?.layer.sublayers?[0] as? CAShapeLayer {
                        self.animateBubbleIcon(on)
                    }
                    else {
                        self.bubble.imageView?.image = nil
                        
                        let shapeLayer = CAShapeLayer ()
                        shapeLayer.lineWidth = 0.25
                        shapeLayer.strokeColor = UIColor.blackColor().CGColor
                        shapeLayer.fillMode = kCAFillModeForwards
                        
                        self.bubble.imageView?.layer.addSublayer(shapeLayer)
                        self.animateBubbleIcon(on)
                    }
                }
            } else {
                bubble.didToggle = nil
                bubble.imageView?.layer.sublayers = nil
                bubble.imageView?.image = bubble.image!
            }
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        bubble = BubbleControl (size: CGSizeMake(80, 80))
        bubble.image = UIImage (named: "basket.png")
        
        bubble.navButtonAction = {
            println("pressed in nav bar")
            self.bubble!.popFromNavBar()
        }
        
        bubble.contentView = {
            
            let min: CGFloat = 50
            let max: CGFloat = self.window!.h - 250
            let randH = min + CGFloat(random()%Int(max-min))
            
            let v = UIView (frame: CGRect (x: 0, y: 0, width: self.window!.w, height: max))
            v.backgroundColor = UIColor.grayColor()
            
            let label = UILabel (frame: CGRect (x: 10, y: 10, width: v.w, height: 20))
            label.text = "test text"
            v.addSubview(label)
            
            return v
        }
        
        return true
    }
    
    func animateBubbleIcon (on: Bool) {
        let shapeLayer = self.bubble.imageView!.layer.sublayers![0] as CAShapeLayer
        let from = on ? self.basketBezier().CGPath: self.arrowBezier().CGPath
        let to = on ? self.arrowBezier().CGPath: self.basketBezier().CGPath
        
        let anim = CABasicAnimation (keyPath: "path")
        anim.fromValue = from
        anim.toValue = to
        anim.duration = 0.5
        anim.fillMode = kCAFillModeForwards
        anim.removedOnCompletion = false
        
        shapeLayer.addAnimation (anim, forKey:"bezier")
    }

    func arrowBezier () -> UIBezierPath {
        //// PaintCode Trial Version
        //// www.paintcodeapp.com
        
        let color0 = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        
        var bezier2Path = UIBezierPath()
        bezier2Path.moveToPoint(CGPointMake(21.22, 2.89))
        bezier2Path.addCurveToPoint(CGPointMake(19.87, 6.72), controlPoint1: CGPointMake(21.22, 6.12), controlPoint2: CGPointMake(20.99, 6.72))
        bezier2Path.addCurveToPoint(CGPointMake(14.54, 7.92), controlPoint1: CGPointMake(19.12, 6.72), controlPoint2: CGPointMake(16.72, 7.24))
        bezier2Path.addCurveToPoint(CGPointMake(0.44, 25.84), controlPoint1: CGPointMake(7.27, 10.09), controlPoint2: CGPointMake(1.64, 17.14))
        bezier2Path.addCurveToPoint(CGPointMake(2.39, 26.97), controlPoint1: CGPointMake(-0.08, 29.74), controlPoint2: CGPointMake(1.12, 30.49))
        bezier2Path.addCurveToPoint(CGPointMake(17.62, 16.09), controlPoint1: CGPointMake(4.34, 21.19), controlPoint2: CGPointMake(10.12, 17.14))
        bezier2Path.addLineToPoint(CGPointMake(21.14, 15.64))
        bezier2Path.addLineToPoint(CGPointMake(21.37, 19.47))
        bezier2Path.addLineToPoint(CGPointMake(21.59, 23.29))
        bezier2Path.addLineToPoint(CGPointMake(29.09, 17.52))
        bezier2Path.addCurveToPoint(CGPointMake(36.59, 11.22), controlPoint1: CGPointMake(33.22, 14.37), controlPoint2: CGPointMake(36.59, 11.52))
        bezier2Path.addCurveToPoint(CGPointMake(22.12, -0.33), controlPoint1: CGPointMake(36.59, 10.69), controlPoint2: CGPointMake(24.89, 1.39))
        bezier2Path.addCurveToPoint(CGPointMake(21.22, 2.89), controlPoint1: CGPointMake(21.44, -0.71), controlPoint2: CGPointMake(21.22, 0.19))
        bezier2Path.closePath()
        bezier2Path.moveToPoint(CGPointMake(31.87, 8.82))
        bezier2Path.addCurveToPoint(CGPointMake(34.64, 11.22), controlPoint1: CGPointMake(33.44, 9.94), controlPoint2: CGPointMake(34.72, 10.99))
        bezier2Path.addCurveToPoint(CGPointMake(28.87, 15.87), controlPoint1: CGPointMake(34.64, 11.44), controlPoint2: CGPointMake(32.09, 13.54))
        bezier2Path.addLineToPoint(CGPointMake(23.09, 20.14))
        bezier2Path.addLineToPoint(CGPointMake(22.87, 17.07))
        bezier2Path.addLineToPoint(CGPointMake(22.64, 13.99))
        bezier2Path.addLineToPoint(CGPointMake(18.97, 14.44))
        bezier2Path.addCurveToPoint(CGPointMake(6.22, 19.24), controlPoint1: CGPointMake(13.04, 15.12), controlPoint2: CGPointMake(9.44, 16.54))
        bezier2Path.addCurveToPoint(CGPointMake(5.09, 16.84), controlPoint1: CGPointMake(2.77, 22.24), controlPoint2: CGPointMake(2.39, 21.49))
        bezier2Path.addCurveToPoint(CGPointMake(20.69, 8.22), controlPoint1: CGPointMake(8.09, 11.82), controlPoint2: CGPointMake(14.54, 8.22))
        bezier2Path.addCurveToPoint(CGPointMake(22.72, 5.14), controlPoint1: CGPointMake(22.57, 8.22), controlPoint2: CGPointMake(22.72, 7.99))
        bezier2Path.addLineToPoint(CGPointMake(22.72, 2.07))
        bezier2Path.addLineToPoint(CGPointMake(25.94, 4.47))
        bezier2Path.addCurveToPoint(CGPointMake(31.87, 8.82), controlPoint1: CGPointMake(27.67, 5.74), controlPoint2: CGPointMake(30.37, 7.77))
        bezier2Path.closePath()
        bezier2Path.miterLimit = 4;
        
        color0.setFill()
        bezier2Path.fill()
        return bezier2Path
    }
    
    func basketBezier () -> UIBezierPath {
        //// PaintCode Trial Version
        //// www.paintcodeapp.com
        
        let color0 = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        
        var bezier2Path = UIBezierPath()
        bezier2Path.moveToPoint(CGPointMake(0.86, 0.36))
        bezier2Path.addCurveToPoint(CGPointMake(3.41, 6.21), controlPoint1: CGPointMake(-0.27, 1.41), controlPoint2: CGPointMake(0.48, 2.98))
        bezier2Path.addLineToPoint(CGPointMake(6.41, 9.51))
        bezier2Path.addLineToPoint(CGPointMake(3.18, 9.73))
        bezier2Path.addCurveToPoint(CGPointMake(-0.27, 12.96), controlPoint1: CGPointMake(0.03, 9.96), controlPoint2: CGPointMake(-0.04, 10.03))
        bezier2Path.addCurveToPoint(CGPointMake(0.48, 16.71), controlPoint1: CGPointMake(-0.42, 14.83), controlPoint2: CGPointMake(-0.12, 16.18))
        bezier2Path.addCurveToPoint(CGPointMake(3.26, 23.46), controlPoint1: CGPointMake(1.08, 17.08), controlPoint2: CGPointMake(2.28, 20.16))
        bezier2Path.addCurveToPoint(CGPointMake(18.33, 32.08), controlPoint1: CGPointMake(6.03, 32.91), controlPoint2: CGPointMake(4.61, 32.08))
        bezier2Path.addCurveToPoint(CGPointMake(33.41, 23.46), controlPoint1: CGPointMake(32.06, 32.08), controlPoint2: CGPointMake(30.63, 32.91))
        bezier2Path.addCurveToPoint(CGPointMake(36.18, 16.71), controlPoint1: CGPointMake(34.38, 20.16), controlPoint2: CGPointMake(35.58, 17.08))
        bezier2Path.addCurveToPoint(CGPointMake(36.93, 12.96), controlPoint1: CGPointMake(36.78, 16.18), controlPoint2: CGPointMake(37.08, 14.83))
        bezier2Path.addCurveToPoint(CGPointMake(33.48, 9.73), controlPoint1: CGPointMake(36.71, 10.03), controlPoint2: CGPointMake(36.63, 9.96))
        bezier2Path.addLineToPoint(CGPointMake(30.26, 9.51))
        bezier2Path.addLineToPoint(CGPointMake(33.33, 6.13))
        bezier2Path.addCurveToPoint(CGPointMake(36.18, 1.48), controlPoint1: CGPointMake(35.06, 4.26), controlPoint2: CGPointMake(36.33, 2.16))
        bezier2Path.addCurveToPoint(CGPointMake(28.23, 4.63), controlPoint1: CGPointMake(35.66, -1.22), controlPoint2: CGPointMake(33.26, -0.24))
        bezier2Path.addLineToPoint(CGPointMake(23.06, 9.58))
        bezier2Path.addLineToPoint(CGPointMake(18.33, 9.58))
        bezier2Path.addLineToPoint(CGPointMake(13.61, 9.58))
        bezier2Path.addLineToPoint(CGPointMake(8.51, 4.71))
        bezier2Path.addCurveToPoint(CGPointMake(0.86, 0.36), controlPoint1: CGPointMake(3.78, 0.13), controlPoint2: CGPointMake(2.06, -0.84))
        bezier2Path.closePath()
        bezier2Path.moveToPoint(CGPointMake(10.08, 12.66))
        bezier2Path.addCurveToPoint(CGPointMake(14.58, 12.21), controlPoint1: CGPointMake(12.33, 14.38), controlPoint2: CGPointMake(14.58, 14.16))
        bezier2Path.addCurveToPoint(CGPointMake(18.33, 11.08), controlPoint1: CGPointMake(14.58, 11.38), controlPoint2: CGPointMake(15.48, 11.08))
        bezier2Path.addCurveToPoint(CGPointMake(22.08, 12.21), controlPoint1: CGPointMake(21.18, 11.08), controlPoint2: CGPointMake(22.08, 11.38))
        bezier2Path.addCurveToPoint(CGPointMake(26.58, 12.66), controlPoint1: CGPointMake(22.08, 14.16), controlPoint2: CGPointMake(24.33, 14.38))
        bezier2Path.addCurveToPoint(CGPointMake(32.21, 11.08), controlPoint1: CGPointMake(28.08, 11.61), controlPoint2: CGPointMake(29.88, 11.08))
        bezier2Path.addCurveToPoint(CGPointMake(35.58, 13.33), controlPoint1: CGPointMake(35.43, 11.08), controlPoint2: CGPointMake(35.58, 11.16))
        bezier2Path.addLineToPoint(CGPointMake(35.58, 15.58))
        bezier2Path.addLineToPoint(CGPointMake(18.33, 15.58))
        bezier2Path.addLineToPoint(CGPointMake(1.08, 15.58))
        bezier2Path.addLineToPoint(CGPointMake(1.08, 13.33))
        bezier2Path.addCurveToPoint(CGPointMake(4.46, 11.08), controlPoint1: CGPointMake(1.08, 11.16), controlPoint2: CGPointMake(1.23, 11.08))
        bezier2Path.addCurveToPoint(CGPointMake(10.08, 12.66), controlPoint1: CGPointMake(6.78, 11.08), controlPoint2: CGPointMake(8.58, 11.61))
        bezier2Path.closePath()
        bezier2Path.moveToPoint(CGPointMake(11.21, 22.86))
        bezier2Path.addCurveToPoint(CGPointMake(12.71, 28.71), controlPoint1: CGPointMake(11.21, 28.18), controlPoint2: CGPointMake(11.36, 28.71))
        bezier2Path.addCurveToPoint(CGPointMake(14.43, 22.86), controlPoint1: CGPointMake(14.06, 28.71), controlPoint2: CGPointMake(14.21, 28.11))
        bezier2Path.addCurveToPoint(CGPointMake(15.56, 17.08), controlPoint1: CGPointMake(14.58, 18.96), controlPoint2: CGPointMake(14.96, 17.08))
        bezier2Path.addCurveToPoint(CGPointMake(16.23, 21.21), controlPoint1: CGPointMake(16.16, 17.08), controlPoint2: CGPointMake(16.38, 18.36))
        bezier2Path.addCurveToPoint(CGPointMake(18.56, 28.93), controlPoint1: CGPointMake(15.86, 27.13), controlPoint2: CGPointMake(16.46, 29.23))
        bezier2Path.addCurveToPoint(CGPointMake(20.21, 22.86), controlPoint1: CGPointMake(20.13, 28.71), controlPoint2: CGPointMake(20.21, 28.33))
        bezier2Path.addCurveToPoint(CGPointMake(21.11, 17.08), controlPoint1: CGPointMake(20.21, 18.88), controlPoint2: CGPointMake(20.51, 17.08))
        bezier2Path.addCurveToPoint(CGPointMake(22.23, 22.86), controlPoint1: CGPointMake(21.71, 17.08), controlPoint2: CGPointMake(22.08, 18.96))
        bezier2Path.addCurveToPoint(CGPointMake(23.96, 28.71), controlPoint1: CGPointMake(22.46, 28.11), controlPoint2: CGPointMake(22.61, 28.71))
        bezier2Path.addCurveToPoint(CGPointMake(25.46, 22.86), controlPoint1: CGPointMake(25.31, 28.71), controlPoint2: CGPointMake(25.46, 28.18))
        bezier2Path.addLineToPoint(CGPointMake(25.46, 17.08))
        bezier2Path.addLineToPoint(CGPointMake(29.43, 17.08))
        bezier2Path.addCurveToPoint(CGPointMake(31.53, 24.58), controlPoint1: CGPointMake(33.93, 17.08), controlPoint2: CGPointMake(33.86, 16.78))
        bezier2Path.addLineToPoint(CGPointMake(29.88, 30.21))
        bezier2Path.addLineToPoint(CGPointMake(18.33, 30.21))
        bezier2Path.addLineToPoint(CGPointMake(6.78, 30.21))
        bezier2Path.addLineToPoint(CGPointMake(5.13, 24.58))
        bezier2Path.addCurveToPoint(CGPointMake(7.31, 17.08), controlPoint1: CGPointMake(2.81, 16.78), controlPoint2: CGPointMake(2.73, 17.08))
        bezier2Path.addLineToPoint(CGPointMake(11.21, 17.08))
        bezier2Path.addLineToPoint(CGPointMake(11.21, 22.86))
        bezier2Path.closePath()
        bezier2Path.miterLimit = 4;
        
        color0.setFill()
        bezier2Path.fill()
        return bezier2Path
    }
}

