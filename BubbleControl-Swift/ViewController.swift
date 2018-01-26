//
//  ViewController.swift
//  BubbleControl-Swift
//
//  Created by Thiha Aung on 3/14/17.
//  Copyright © 2017 Imagination. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var bubble: BubbleControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBubble()
    }
    
    // MARK: Bubble

    func setupBubble () {
        let win = APPDELEGATE.window!
        
        bubble = BubbleControl (size: CGSize(width: 80, height: 80))
        bubble.image = UIImage (named: "basket.png")
        
        bubble.didNavigationBarButtonPressed = {
            print("pressed in nav bar")
            self.bubble!.popFromNavBar()
        }
        
        bubble.setOpenAnimation = { content, background in
            self.bubble.contentView!.bottom = win.bottom
            if (self.bubble.center.x > win.center.x) {
                self.bubble.contentView!.left = win.right
                self.bubble.contentView!.spring(animations: { () -> Void in
                    self.bubble.contentView!.right = win.right
                }, completion: nil)
            } else {
                self.bubble.contentView!.right = win.left
                self.bubble.contentView!.spring(animations: { () -> Void in
                    self.bubble.contentView!.left = win.left
                }, completion: nil)
            }
        }
        
        
        //let min: CGFloat = 50
        let max: CGFloat = win.h - 250
        //let randH = min + CGFloat(random()%Int(max-min))
        
        let v = UIView (frame: CGRect (x: 0, y: 0, width: win.w, height: max))
        v.backgroundColor = UIColor.gray
        
        let label = UILabel (frame: CGRect (x: 10, y: 10, width: v.w, height: 20))
        label.text = "test text"
        v.addSubview(label)
        
        bubble.contentView = v
        
        win.addSubview(bubble)
    }
    
    // MARK: Animation
    
    var animateIcon: Bool = false {
        didSet {
            if animateIcon {
                bubble.didToggle = { on in
                    if (self.bubble.imageView?.layer.sublayers?[0] as? CAShapeLayer) != nil {
                        self.animateBubbleIcon(on)
                    }
                    else {
                        self.bubble.imageView?.image = nil
                        
                        let shapeLayer = CAShapeLayer ()
                        shapeLayer.lineWidth = 0.25
                        shapeLayer.strokeColor = UIColor.black.cgColor
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
    
    func animateBubbleIcon (_ on: Bool) {
        let shapeLayer = self.bubble.imageView!.layer.sublayers![0] as! CAShapeLayer
        let from = on ? self.basketBezier().cgPath: self.arrowBezier().cgPath
        let to = on ? self.arrowBezier().cgPath: self.basketBezier().cgPath
        
        let anim = CABasicAnimation (keyPath: "path")
        anim.fromValue = from
        anim.toValue = to
        anim.duration = 0.5
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        
        shapeLayer.add (anim, forKey:"bezier")
    }
    
    func arrowBezier () -> UIBezierPath {
        //// PaintCode Trial Version
        //// www.paintcodeapp.com
        
        let color0 = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 21.22, y: 2.89))
        bezier2Path.addCurve(to: CGPoint(x: 19.87, y: 6.72), controlPoint1: CGPoint(x: 21.22, y: 6.12), controlPoint2: CGPoint(x: 20.99, y: 6.72))
        bezier2Path.addCurve(to: CGPoint(x: 14.54, y: 7.92), controlPoint1: CGPoint(x: 19.12, y: 6.72), controlPoint2: CGPoint(x: 16.72, y: 7.24))
        bezier2Path.addCurve(to: CGPoint(x: 0.44, y: 25.84), controlPoint1: CGPoint(x: 7.27, y: 10.09), controlPoint2: CGPoint(x: 1.64, y: 17.14))
        bezier2Path.addCurve(to: CGPoint(x: 2.39, y: 26.97), controlPoint1: CGPoint(x: -0.08, y: 29.74), controlPoint2: CGPoint(x: 1.12, y: 30.49))
        bezier2Path.addCurve(to: CGPoint(x: 17.62, y: 16.09), controlPoint1: CGPoint(x: 4.34, y: 21.19), controlPoint2: CGPoint(x: 10.12, y: 17.14))
        bezier2Path.addLine(to: CGPoint(x: 21.14, y: 15.64))
        bezier2Path.addLine(to: CGPoint(x: 21.37, y: 19.47))
        bezier2Path.addLine(to: CGPoint(x: 21.59, y: 23.29))
        bezier2Path.addLine(to: CGPoint(x: 29.09, y: 17.52))
        bezier2Path.addCurve(to: CGPoint(x: 36.59, y: 11.22), controlPoint1: CGPoint(x: 33.22, y: 14.37), controlPoint2: CGPoint(x: 36.59, y: 11.52))
        bezier2Path.addCurve(to: CGPoint(x: 22.12, y: -0.33), controlPoint1: CGPoint(x: 36.59, y: 10.69), controlPoint2: CGPoint(x: 24.89, y: 1.39))
        bezier2Path.addCurve(to: CGPoint(x: 21.22, y: 2.89), controlPoint1: CGPoint(x: 21.44, y: -0.71), controlPoint2: CGPoint(x: 21.22, y: 0.19))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: 31.87, y: 8.82))
        bezier2Path.addCurve(to: CGPoint(x: 34.64, y: 11.22), controlPoint1: CGPoint(x: 33.44, y: 9.94), controlPoint2: CGPoint(x: 34.72, y: 10.99))
        bezier2Path.addCurve(to: CGPoint(x: 28.87, y: 15.87), controlPoint1: CGPoint(x: 34.64, y: 11.44), controlPoint2: CGPoint(x: 32.09, y: 13.54))
        bezier2Path.addLine(to: CGPoint(x: 23.09, y: 20.14))
        bezier2Path.addLine(to: CGPoint(x: 22.87, y: 17.07))
        bezier2Path.addLine(to: CGPoint(x: 22.64, y: 13.99))
        bezier2Path.addLine(to: CGPoint(x: 18.97, y: 14.44))
        bezier2Path.addCurve(to: CGPoint(x: 6.22, y: 19.24), controlPoint1: CGPoint(x: 13.04, y: 15.12), controlPoint2: CGPoint(x: 9.44, y: 16.54))
        bezier2Path.addCurve(to: CGPoint(x: 5.09, y: 16.84), controlPoint1: CGPoint(x: 2.77, y: 22.24), controlPoint2: CGPoint(x: 2.39, y: 21.49))
        bezier2Path.addCurve(to: CGPoint(x: 20.69, y: 8.22), controlPoint1: CGPoint(x: 8.09, y: 11.82), controlPoint2: CGPoint(x: 14.54, y: 8.22))
        bezier2Path.addCurve(to: CGPoint(x: 22.72, y: 5.14), controlPoint1: CGPoint(x: 22.57, y: 8.22), controlPoint2: CGPoint(x: 22.72, y: 7.99))
        bezier2Path.addLine(to: CGPoint(x: 22.72, y: 2.07))
        bezier2Path.addLine(to: CGPoint(x: 25.94, y: 4.47))
        bezier2Path.addCurve(to: CGPoint(x: 31.87, y: 8.82), controlPoint1: CGPoint(x: 27.67, y: 5.74), controlPoint2: CGPoint(x: 30.37, y: 7.77))
        bezier2Path.close()
        bezier2Path.miterLimit = 4;
        
        color0.setFill()
        bezier2Path.fill()
        return bezier2Path
    }
    
    func basketBezier () -> UIBezierPath {
        //// PaintCode Trial Version
        //// www.paintcodeapp.com
        
        let color0 = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 0.86, y: 0.36))
        bezier2Path.addCurve(to: CGPoint(x: 3.41, y: 6.21), controlPoint1: CGPoint(x: -0.27, y: 1.41), controlPoint2: CGPoint(x: 0.48, y: 2.98))
        bezier2Path.addLine(to: CGPoint(x: 6.41, y: 9.51))
        bezier2Path.addLine(to: CGPoint(x: 3.18, y: 9.73))
        bezier2Path.addCurve(to: CGPoint(x: -0.27, y: 12.96), controlPoint1: CGPoint(x: 0.03, y: 9.96), controlPoint2: CGPoint(x: -0.04, y: 10.03))
        bezier2Path.addCurve(to: CGPoint(x: 0.48, y: 16.71), controlPoint1: CGPoint(x: -0.42, y: 14.83), controlPoint2: CGPoint(x: -0.12, y: 16.18))
        bezier2Path.addCurve(to: CGPoint(x: 3.26, y: 23.46), controlPoint1: CGPoint(x: 1.08, y: 17.08), controlPoint2: CGPoint(x: 2.28, y: 20.16))
        bezier2Path.addCurve(to: CGPoint(x: 18.33, y: 32.08), controlPoint1: CGPoint(x: 6.03, y: 32.91), controlPoint2: CGPoint(x: 4.61, y: 32.08))
        bezier2Path.addCurve(to: CGPoint(x: 33.41, y: 23.46), controlPoint1: CGPoint(x: 32.06, y: 32.08), controlPoint2: CGPoint(x: 30.63, y: 32.91))
        bezier2Path.addCurve(to: CGPoint(x: 36.18, y: 16.71), controlPoint1: CGPoint(x: 34.38, y: 20.16), controlPoint2: CGPoint(x: 35.58, y: 17.08))
        bezier2Path.addCurve(to: CGPoint(x: 36.93, y: 12.96), controlPoint1: CGPoint(x: 36.78, y: 16.18), controlPoint2: CGPoint(x: 37.08, y: 14.83))
        bezier2Path.addCurve(to: CGPoint(x: 33.48, y: 9.73), controlPoint1: CGPoint(x: 36.71, y: 10.03), controlPoint2: CGPoint(x: 36.63, y: 9.96))
        bezier2Path.addLine(to: CGPoint(x: 30.26, y: 9.51))
        bezier2Path.addLine(to: CGPoint(x: 33.33, y: 6.13))
        bezier2Path.addCurve(to: CGPoint(x: 36.18, y: 1.48), controlPoint1: CGPoint(x: 35.06, y: 4.26), controlPoint2: CGPoint(x: 36.33, y: 2.16))
        bezier2Path.addCurve(to: CGPoint(x: 28.23, y: 4.63), controlPoint1: CGPoint(x: 35.66, y: -1.22), controlPoint2: CGPoint(x: 33.26, y: -0.24))
        bezier2Path.addLine(to: CGPoint(x: 23.06, y: 9.58))
        bezier2Path.addLine(to: CGPoint(x: 18.33, y: 9.58))
        bezier2Path.addLine(to: CGPoint(x: 13.61, y: 9.58))
        bezier2Path.addLine(to: CGPoint(x: 8.51, y: 4.71))
        bezier2Path.addCurve(to: CGPoint(x: 0.86, y: 0.36), controlPoint1: CGPoint(x: 3.78, y: 0.13), controlPoint2: CGPoint(x: 2.06, y: -0.84))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: 10.08, y: 12.66))
        bezier2Path.addCurve(to: CGPoint(x: 14.58, y: 12.21), controlPoint1: CGPoint(x: 12.33, y: 14.38), controlPoint2: CGPoint(x: 14.58, y: 14.16))
        bezier2Path.addCurve(to: CGPoint(x: 18.33, y: 11.08), controlPoint1: CGPoint(x: 14.58, y: 11.38), controlPoint2: CGPoint(x: 15.48, y: 11.08))
        bezier2Path.addCurve(to: CGPoint(x: 22.08, y: 12.21), controlPoint1: CGPoint(x: 21.18, y: 11.08), controlPoint2: CGPoint(x: 22.08, y: 11.38))
        bezier2Path.addCurve(to: CGPoint(x: 26.58, y: 12.66), controlPoint1: CGPoint(x: 22.08, y: 14.16), controlPoint2: CGPoint(x: 24.33, y: 14.38))
        bezier2Path.addCurve(to: CGPoint(x: 32.21, y: 11.08), controlPoint1: CGPoint(x: 28.08, y: 11.61), controlPoint2: CGPoint(x: 29.88, y: 11.08))
        bezier2Path.addCurve(to: CGPoint(x: 35.58, y: 13.33), controlPoint1: CGPoint(x: 35.43, y: 11.08), controlPoint2: CGPoint(x: 35.58, y: 11.16))
        bezier2Path.addLine(to: CGPoint(x: 35.58, y: 15.58))
        bezier2Path.addLine(to: CGPoint(x: 18.33, y: 15.58))
        bezier2Path.addLine(to: CGPoint(x: 1.08, y: 15.58))
        bezier2Path.addLine(to: CGPoint(x: 1.08, y: 13.33))
        bezier2Path.addCurve(to: CGPoint(x: 4.46, y: 11.08), controlPoint1: CGPoint(x: 1.08, y: 11.16), controlPoint2: CGPoint(x: 1.23, y: 11.08))
        bezier2Path.addCurve(to: CGPoint(x: 10.08, y: 12.66), controlPoint1: CGPoint(x: 6.78, y: 11.08), controlPoint2: CGPoint(x: 8.58, y: 11.61))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: 11.21, y: 22.86))
        bezier2Path.addCurve(to: CGPoint(x: 12.71, y: 28.71), controlPoint1: CGPoint(x: 11.21, y: 28.18), controlPoint2: CGPoint(x: 11.36, y: 28.71))
        bezier2Path.addCurve(to: CGPoint(x: 14.43, y: 22.86), controlPoint1: CGPoint(x: 14.06, y: 28.71), controlPoint2: CGPoint(x: 14.21, y: 28.11))
        bezier2Path.addCurve(to: CGPoint(x: 15.56, y: 17.08), controlPoint1: CGPoint(x: 14.58, y: 18.96), controlPoint2: CGPoint(x: 14.96, y: 17.08))
        bezier2Path.addCurve(to: CGPoint(x: 16.23, y: 21.21), controlPoint1: CGPoint(x: 16.16, y: 17.08), controlPoint2: CGPoint(x: 16.38, y: 18.36))
        bezier2Path.addCurve(to: CGPoint(x: 18.56, y: 28.93), controlPoint1: CGPoint(x: 15.86, y: 27.13), controlPoint2: CGPoint(x: 16.46, y: 29.23))
        bezier2Path.addCurve(to: CGPoint(x: 20.21, y: 22.86), controlPoint1: CGPoint(x: 20.13, y: 28.71), controlPoint2: CGPoint(x: 20.21, y: 28.33))
        bezier2Path.addCurve(to: CGPoint(x: 21.11, y: 17.08), controlPoint1: CGPoint(x: 20.21, y: 18.88), controlPoint2: CGPoint(x: 20.51, y: 17.08))
        bezier2Path.addCurve(to: CGPoint(x: 22.23, y: 22.86), controlPoint1: CGPoint(x: 21.71, y: 17.08), controlPoint2: CGPoint(x: 22.08, y: 18.96))
        bezier2Path.addCurve(to: CGPoint(x: 23.96, y: 28.71), controlPoint1: CGPoint(x: 22.46, y: 28.11), controlPoint2: CGPoint(x: 22.61, y: 28.71))
        bezier2Path.addCurve(to: CGPoint(x: 25.46, y: 22.86), controlPoint1: CGPoint(x: 25.31, y: 28.71), controlPoint2: CGPoint(x: 25.46, y: 28.18))
        bezier2Path.addLine(to: CGPoint(x: 25.46, y: 17.08))
        bezier2Path.addLine(to: CGPoint(x: 29.43, y: 17.08))
        bezier2Path.addCurve(to: CGPoint(x: 31.53, y: 24.58), controlPoint1: CGPoint(x: 33.93, y: 17.08), controlPoint2: CGPoint(x: 33.86, y: 16.78))
        bezier2Path.addLine(to: CGPoint(x: 29.88, y: 30.21))
        bezier2Path.addLine(to: CGPoint(x: 18.33, y: 30.21))
        bezier2Path.addLine(to: CGPoint(x: 6.78, y: 30.21))
        bezier2Path.addLine(to: CGPoint(x: 5.13, y: 24.58))
        bezier2Path.addCurve(to: CGPoint(x: 7.31, y: 17.08), controlPoint1: CGPoint(x: 2.81, y: 16.78), controlPoint2: CGPoint(x: 2.73, y: 17.08))
        bezier2Path.addLine(to: CGPoint(x: 11.21, y: 17.08))
        bezier2Path.addLine(to: CGPoint(x: 11.21, y: 22.86))
        bezier2Path.close()
        bezier2Path.miterLimit = 4;
        
        color0.setFill()
        bezier2Path.fill()
        return bezier2Path
    }
    
    // MARK: IBActions
    
    @IBAction func postionValueChanged(_ sender: UISwitch) {
        bubble.movesBottom = sender.isOn
    }
    
    @IBAction func animateIconValueChanged(_ sender: UISwitch) {
        animateIcon = sender.isOn
    }
    
    @IBAction func snapInsideChanged(_ sender: UISwitch) {
        bubble.snapsInside = sender.isOn
    }
    
    @IBAction func addPressed(_ sender: AnyObject) {
        bubble.badgeCount += 1
    }
    
    @IBAction func removePressed(_ sender: AnyObject) {
        bubble.badgeCount -= 1
    }
}

