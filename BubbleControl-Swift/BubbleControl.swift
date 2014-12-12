//
//  BubbleControl.swift
//  BubbleControl-Swift
//
//  Created by Cem Olcay on 11/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import UIKit

let APPDELEGATE: UIApplicationDelegate
    = (UIApplication.sharedApplication().delegate as AppDelegate)

private let BubbleControlMoveAnimationDuration: NSTimeInterval = 0.5
private let BubbleControlSpringDamping: CGFloat = 0.6
private let BubbleControlSpringVelocity: CGFloat = 0.6


extension UIView {
    
    // MARK: Frame Extensions
    
    var x: CGFloat {
        return self.frame.origin.x
    }
    
    var y: CGFloat {
        return self.frame.origin.y
    }
    
    var w: CGFloat {
        return self.frame.size.width
    }
    
    var h: CGFloat {
        return self.frame.size.height
    }
    
    
    var left: CGFloat {
        return self.x
    }
    
    var right: CGFloat {
        return self.x + self.w
    }
    
    var top: CGFloat {
        return self.y
    }
    
    var bottom: CGFloat {
        get {
            return self.y + self.h
        } set (newValue) {
            setY(newValue - h)
        }
    }
    
    
    func setX (x: CGFloat) {
        self.frame = CGRect (x: x, y: self.y, width: self.w, height: self.h)
    }
    
    func setY (y: CGFloat) {
        self.frame = CGRect (x: self.x, y: y, width: self.w, height: self.h)
    }
    
    func setW (w: CGFloat) {
        self.frame = CGRect (x: self.x, y: self.y, width: w, height: self.h)
    }
    
    func setH (h: CGFloat) {
        self.frame = CGRect (x: self.x, y: self.y, width: self.w, height: h)
    }
    
    
    func setSize (size: CGSize) {
        self.frame = CGRect (x: self.x, y: self.y, width: size.width, height: size.height)
    }
    
    func setPosition (position: CGPoint) {
        self.frame = CGRect (x: position.x, y: position.y, width: self.w, height: self.h)
    }
    
    
    func leftWithOffset (offset: CGFloat) -> CGFloat {
        return self.left - offset
    }
    
    func rightWithOffset (offset: CGFloat) -> CGFloat {
        return self.right + offset
    }
    
    func topWithOffset (offset: CGFloat) -> CGFloat {
        return self.top - offset
    }
    
    func botttomWithOffset (offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }
    
    
    
    func moveY (y: CGFloat) {
        var moveRect = self.frame
        moveRect.origin.y = y
        
        UIView.animateWithDuration(BubbleControlMoveAnimationDuration,
            delay: 0,
            usingSpringWithDamping: BubbleControlSpringDamping,
            initialSpringVelocity: BubbleControlSpringVelocity,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.frame = moveRect
            },
            completion: nil)
    }
    
    func moveX (x: CGFloat) {
        var moveRect = self.frame
        moveRect.origin.x = x
        
        UIView.animateWithDuration(BubbleControlMoveAnimationDuration,
            delay: 0,
            usingSpringWithDamping: BubbleControlSpringDamping,
            initialSpringVelocity: BubbleControlSpringVelocity,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.frame = moveRect
            },
            completion: nil)
    }
    
    func movePoint (x: CGFloat, y: CGFloat) {
        var moveRect = self.frame
        moveRect.origin.x = x
        moveRect.origin.y = y
        
        UIView.animateWithDuration(BubbleControlMoveAnimationDuration,
            delay: 0,
            usingSpringWithDamping: BubbleControlSpringDamping,
            initialSpringVelocity: BubbleControlSpringVelocity,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.frame = moveRect
            },
            completion: nil)
    }
    
    func movePoint (point: CGPoint) {
        var moveRect = self.frame
        moveRect.origin = point
        
        UIView.animateWithDuration(BubbleControlMoveAnimationDuration,
            delay: 0,
            usingSpringWithDamping: BubbleControlSpringDamping,
            initialSpringVelocity: BubbleControlSpringVelocity,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.frame = moveRect
            },
            completion: nil)
    }
    
    
    func setScale (s: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, s, s, s)
        
        self.layer.transform = transform
    }
    
    func alphaTo (to: CGFloat) {
        UIView.animateWithDuration(BubbleControlMoveAnimationDuration,
            animations: {
                self.alpha = to
            })
    }
    
    func bubble () {
        
        self.setScale(1.2)
        UIView.animateWithDuration(BubbleControlMoveAnimationDuration,
            delay: 0,
            usingSpringWithDamping: BubbleControlSpringDamping,
            initialSpringVelocity: BubbleControlSpringVelocity,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.setScale(1)
            },
            completion: nil)
    }
}


class BubbleControl: UIControl {
    

    // MARK: State

    enum BubbleControlState {
        case Snap       // snapped edge
        case Drag       // dragging around
        case Pop        // long pressed and popping
        case NavBar     // popped and went to nav bar
    }
    
    var bubbleState: BubbleControlState = .Snap
    
    

    // MARK: Constants
    
    let popTriggerDuration: NSTimeInterval = 0.5
    let popAnimationDuration: NSTimeInterval = 1
    let popAnimationShakeDuration: NSTimeInterval = 0.10
    let popAnimationShakeRotations: (CGFloat, CGFloat) = (-30, 30)
    let popAnimationScale: CGFloat = 1.2
    
    
    
    // MARK: Layout
    
    var snapOffset: CGFloat = 10
    var barButtonItem: UIBarButtonItem?
    var borderView: UIView?

    
    private var imageView: UIImageView?
    
    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }
    
    
    private var badgeLabel: UILabel?
    
    var badgeCount: Int = 0 {
        didSet {
            if badgeCount < 0 {
                badgeCount = 0
            } else if badgeCount > 0 {
                badgeLabel?.hidden = false
                badgeLabel?.text = "\(badgeCount)"
            } else {
                badgeLabel?.hidden = true
            }
            
            if (bubbleState == .NavBar) {
                barButtonItem!.setBadgeValue(badgeCount)
            }
        }
    }
    
    private var _content: UIView?
    var contentView: (() -> UIView)?
    
    
    
    // MARK: Properties
    
    var toggle: Bool = false {
        didSet {
            if toggle {
                openContentView()
            } else {
                closeContentView()
            }
        }
    }
    
    var navButtonAction: (() -> ())?
    
    
    
    // MARK: Init
    
    init (size: CGSize) {
        super.init(frame: CGRect (origin: CGPointZero, size: size))
        defaultInit()
    }
    
    init (image: UIImage) {
        let size = image.size
        super.init(frame: CGRect (origin: CGPointZero, size: size))
        self.image = image
        defaultInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func defaultInit () {
        layer.cornerRadius = w/2
        
        imageView = UIImageView (frame: CGRectInset(frame, 20, 20))
        addSubview(imageView!)
        
        borderView = UIView (frame: frame)
        borderView?.layer.borderColor = UIColor.blackColor().CGColor
        borderView?.layer.borderWidth = 2
        borderView?.layer.cornerRadius = w/2
        borderView?.layer.masksToBounds = true
        borderView?.userInteractionEnabled = false
        addSubview(borderView!)
        
        badgeLabel = UILabel (frame: CGRectInset(frame, 25, 25))
        badgeLabel?.center = CGPointMake(left + badgeLabel!.w/2, top + badgeLabel!.h/2)
        badgeLabel?.backgroundColor = UIColor.redColor()
        badgeLabel?.textAlignment = NSTextAlignment.Center
        badgeLabel?.textColor = UIColor.whiteColor()
        badgeLabel?.text = "\(badgeCount)"
        badgeLabel?.layer.cornerRadius = badgeLabel!.w/2
        badgeLabel?.layer.masksToBounds = true
        addSubview(badgeLabel!)
        
        
        badgeCount = 2
        
        addTarget(self, action: "touchDown", forControlEvents: UIControlEvents.TouchDown)
        addTarget(self, action: "touchUp", forControlEvents: UIControlEvents.TouchUpInside)
        addTarget(self, action: "touchDrag:event:", forControlEvents: UIControlEvents.TouchDragInside)
        
        var longPress = UILongPressGestureRecognizer (target: self, action: "longPressHandler:")
        longPress.minimumPressDuration = 0.75
        addGestureRecognizer(longPress)
        
        center.x = APPDELEGATE.window!!.w - w/2 + snapOffset
        center.y = 84 + h/2
    }
    
    
    
    // MARK: Snap To Edge
    
    func snap () {
        let window = APPDELEGATE.window!!

        var targetX = window.leftWithOffset(snapOffset)
        var badgeTargetX = w - badgeLabel!.w
        
        if center.x > window.w/2 {
            targetX = window.rightWithOffset(snapOffset) - w
            badgeTargetX = 0
        }
        
        
        badgeLabel!.moveX(badgeTargetX)
        moveX(targetX)
        bubbleState = .Snap
    }
    
    func lockInWindowBounds () {
        let window = APPDELEGATE.window!!
        
        if top < 64 {
            var rect = frame
            rect.origin.y = 64
            frame = rect
        }
        
        if left < 0 {
            var rect = frame
            rect.origin.x = 0
            frame = rect
        }
        
        
        if bottom > window.h {
            var rect = frame
            rect.origin.y = window.botttomWithOffset(-h)
            frame = rect
        }
        
        if right > window.w {
            var rect = frame
            rect.origin.x = window.rightWithOffset(-w)
            frame = rect
        }
    }
    
    
    
    // MARK: Events
    
    func touchDown () {
        bounce()
    }
    
    func touchUp () {
        if bubbleState == .Snap {
            toggle = !toggle
        } else {
            snap()
        }
    }
    
    func touchDrag (sender: BubbleControl, event: UIEvent) {
        
        if toggle {
            closeContentView()
        }
        
        bubbleState = .Drag
        
        let touch = event.allTouches()?.anyObject() as UITouch
        let location = touch.locationInView(APPDELEGATE.window!)
        
        center = location
        lockInWindowBounds()
    }
    
    
    func navButtonPressed (sender: AnyObject) {
        navButtonAction? ()
    }
    

    func longPressHandler (press: UILongPressGestureRecognizer) {
        switch press.state {
        case .Began:
            pop()
            if toggle {
                toggle = !toggle
            }
            
        case .Ended:
            if bubbleState == .Pop {
                cancelPop()
            }
            
        default:
            return
        }
    }
    
    
    
    // MARK: Animations
    
    func bounce () {
        self.bubble()
    }
    
    override func animationDidStop(anim: CAAnimation!,
        finished flag: Bool) {
        if flag {
            if anim == layer.animationForKey("pop") {
                layer.removeAnimationForKey("pop")
                popToNavBar()
            }
        }
    }
    
    func degreesToRadians (angle: CGFloat) -> CGFloat {
        return (CGFloat (M_PI) * angle) / 180.0
    }
    
    
    
    // MARK: Pop
    
    func pop () {
        bubbleState = .Pop
        
        let shake = CABasicAnimation(keyPath: "transform.rotation")
        shake.fromValue = degreesToRadians(popAnimationShakeRotations.0)
        shake.toValue = degreesToRadians(popAnimationShakeRotations.1)
        shake.duration = popAnimationShakeDuration
        shake.repeatCount = Float.infinity
        shake.autoreverses = true
        
        let grow = CABasicAnimation (keyPath: "transform.scale")
        grow.fromValue = 1
        grow.toValue = popAnimationScale
        grow.duration = popAnimationDuration
        
        let anims = CAAnimationGroup ()
        anims.animations = [shake, grow]
        anims.duration = popAnimationDuration
        anims.delegate = self
        anims.removedOnCompletion = false
        
        layer.addAnimation(anims, forKey: "pop")
    }
    
    func cancelPop () {
        snap()
        layer.removeAnimationForKey("pop")
    }
    
    
    func popToNavBar () {
        bubbleState = .NavBar
        
        alphaTo(0)
        
        var barButton: UIBarButtonItem?
        
        if let img = image {
            let navButton = UIButton (frame: CGRect (x: 0, y: 0, width: 20, height: 20))
            navButton.setBackgroundImage(image!, forState: .Normal)
            navButton.addTarget(self, action: "navButtonPressed:",
                forControlEvents: .TouchUpInside)
            
            barButton = UIBarButtonItem (customView: navButton)
        } else {
            barButton = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.Action
                , target: self, action: "navButtonPressed:")
        }
        
        barButtonItem = barButton
        barButtonItem?.setBadgeValue(badgeCount)
        
        if let last = APPDELEGATE.window!!.rootViewController? as? UINavigationController {
            let vc = last.viewControllers[0] as UIViewController
            vc.navigationItem.setRightBarButtonItem(barButtonItem!, animated: true)
        }
    }
    
    func popFromNavBar () {
        if let last = APPDELEGATE.window!!.rootViewController? as? UINavigationController {
            let vc = last.viewControllers[0] as UIViewController
            vc.navigationItem.rightBarButtonItem = nil
            
            bubbleState = .Snap
            self.barButtonItem = nil
            self.hidden = false
            self.alphaTo(1)
        }
    }
    
    
    
    // MARK: Toggle
    
    func openContentView () {
        if let v = contentView {
            _content = v()
            APPDELEGATE.window!!.addSubview(_content!)
            _content?.bottom = APPDELEGATE.window!!.bottom
            
            moveY(_content!.top - h - snapOffset)
        }
    }
    
    func closeContentView () {
        if let v = _content {
            v.removeFromSuperview()
        }
    }
    
}



// MARK: - UIBarButtonItem Badge Extension

private var barButtonAssociatedObjectBadge: UInt8 = 0
extension UIBarButtonItem {

    private var badgeLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &barButtonAssociatedObjectBadge) as UILabel?
        } set (value) {
            objc_setAssociatedObject(self, &barButtonAssociatedObjectBadge, value, UInt(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    func setBadgeValue (value: Int) {
        if let label = badgeLabel {
            if value > 0 {
                label.hidden = false
                label.text = "\(value)"
            } else {
                label.hidden = true
            }
        } else {
            if value > 0 {
                let view = valueForKey("view") as? UIView
                
                badgeLabel = UILabel (frame: CGRect (x: 0, y: 0, width: 20, height: 20))
                badgeLabel?.center = CGPoint (x: view!.right, y: view!.top)
                badgeLabel?.backgroundColor = UIColor.redColor()
                
                badgeLabel?.layer.cornerRadius = badgeLabel!.h/2
                badgeLabel?.layer.masksToBounds = true
                
                badgeLabel?.textAlignment = NSTextAlignment.Center
                badgeLabel?.textColor = UIColor.whiteColor()
                badgeLabel?.font = UIFont.systemFontOfSize(15)
                badgeLabel?.text = "\(value)"
                
                view?.addSubview(badgeLabel!)
            }
        }
    }
}

