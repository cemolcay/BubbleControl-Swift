//
//  BubbleControl.swift
//  BubbleControl-Swift
//
//  Created by Thiha Aung on 3/14/17.
//  Copyright © 2017 Imagination. All rights reserved.
//

import UIKit
import Foundation

let APPDELEGATE: AppDelegate = UIApplication.shared.delegate as! AppDelegate

// MARK: - Animation Constants
private let BubbleControlMoveAnimationDuration: TimeInterval = 0.5
private let BubbleControlSpringDamping: CGFloat = 0.6
private let BubbleControlSpringVelocity: CGFloat = 0.6

// MARK: - UIView Extension
extension UIView : CAAnimationDelegate{
    
    // MARK: Frame Extensions
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set (value) {
            self.frame = CGRect (x: value, y: self.y, width: self.w, height: self.h)
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set (value) {
            self.frame = CGRect (x: self.x, y: value, width: self.w, height: self.h)
        }
    }
    
    var w: CGFloat {
        get {
            return self.frame.size.width
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: value, height: self.h)
        }
    }
    
    var h: CGFloat {
        get {
            return self.frame.size.height
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: self.w, height: value)
        }
    }
    
    
    var position: CGPoint {
        get {
            return self.frame.origin
        } set (value) {
            self.frame = CGRect (origin: value, size: self.frame.size)
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        } set (value) {
            self.frame = CGRect (origin: self.frame.origin, size: size)
        }
    }
    
    
    var left: CGFloat {
        get {
            return self.x
        } set (value) {
            self.x = value
        }
    }
    
    var right: CGFloat {
        get {
            return self.x + self.w
        } set (value) {
            self.x = value - self.w
        }
    }
    
    var top: CGFloat {
        get {
            return self.y
        } set (value) {
            self.y = value
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.y + self.h
        } set (value) {
            self.y = value - self.h
        }
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
    
    
    
    func spring (animations: @escaping ()->Void, completion:((Bool)->Void)?) {
        UIView.animate(withDuration: BubbleControlMoveAnimationDuration,
                       delay: 0,
                       usingSpringWithDamping: BubbleControlSpringDamping,
                       initialSpringVelocity: BubbleControlSpringVelocity,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: animations,
                       completion: completion)
    }
    
    
    func moveY (y: CGFloat) {
        var moveRect = self.frame
        moveRect.origin.y = y
        
        spring(animations: { () -> Void in
            self.frame = moveRect
        }, completion: nil)
    }
    
    func moveX (x: CGFloat) {
        var moveRect = self.frame
        moveRect.origin.x = x
        
        spring(animations: { () -> Void in
            self.frame = moveRect
        }, completion: nil)
    }
    
    func movePoint (x: CGFloat, y: CGFloat) {
        var moveRect = self.frame
        moveRect.origin.x = x
        moveRect.origin.y = y
        
        spring(animations: { () -> Void in
            self.frame = moveRect
        }, completion: nil)
    }
    
    func movePoint (point: CGPoint) {
        var moveRect = self.frame
        moveRect.origin = point
        
        spring(animations: { () -> Void in
            self.frame = moveRect
        }, completion: nil)
    }
    
    
    func setScale (s: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, s, s, s)
        
        self.layer.transform = transform
    }
    
    func alphaTo (to: CGFloat) {
        UIView.animate(withDuration: BubbleControlMoveAnimationDuration,
                       animations: {
                        self.alpha = to
        })
    }
    
    func bubble () {
        self.setScale(s: 1.2)
        spring(animations: { () -> Void in
            self.setScale(s: 1)
        }, completion: nil)
    }
}


// MARK: - BubbleControl
class BubbleControl: UIControl {
    
    // MARK: Constants
    
    let popTriggerDuration: TimeInterval = 0.5
    let popAnimationDuration: TimeInterval = 1
    let popAnimationShakeDuration: TimeInterval = 0.10
    let popAnimationShakeRotations: (CGFloat, CGFloat) = (-30, 30)
    let popAnimationScale: CGFloat = 1.2
    
    let snapOffsetMin: CGFloat = 10
    let snapOffsetMax: CGFloat = 50
    
    
    // MARK: Optionals
    
    var contentView: UIView?
    
    var snapsInside: Bool = false
    var popsToNavBar: Bool = true
    var movesBottom: Bool = false
    
    
    // MARK: Actions
    
    var didToggle: ((Bool) -> ())?
    var didNavigationBarButtonPressed: (() -> ())?
    var didPop: (()->())?
    
    var setOpenAnimation: ((_ contentView: UIView, _ backgroundView: UIView?)->())?
    var setCloseAnimation: ((_ contentView: UIView, _ backgroundView: UIView?) -> ())?
    
    
    // MARK: Bubble State
    
    enum BubbleControlState {
        case Snap       // snapped to edge
        case Drag       // dragging around
        case Pop        // long pressed and popping
        case NavBar     // popped and went to nav bar
    }
    
    var bubbleState: BubbleControlState = .Snap {
        didSet {
            if bubbleState == .Snap {
                setupSnapInsideTimer()
            } else {
                snapOffset = snapOffsetMin
            }
        }
    }
    
    
    // MARK: Snap
    
    private var snapOffset: CGFloat!
    
    private var snapInTimer: Timer?
    private var snapInInterval: TimeInterval = 2
    
    
    // MARK: Toggle
    
    private var positionBeforeToggle: CGPoint?
    
    var toggle: Bool = false {
        didSet {
            didToggle? (toggle)
            if toggle {
                openContentView()
            } else {
                closeContentView()
            }
        }
    }
    
    
    // MARK: Navigation Button
    
    private var barButtonItem: UIBarButtonItem?
    
    
    // MARK: Badge
    
    private var badgeLabel: UILabel?
    
    var badgeCount: Int = 0 {
        didSet {
            if badgeCount < 0 {
                badgeCount = 0
            } else if badgeCount > 0 {
                badgeLabel?.isHidden = false
                badgeLabel?.text = "\(badgeCount)"
                badgeLabel?.bubble()
            } else {
                badgeLabel?.isHidden = true
            }
            
            barButtonItem?.setBadgeValue(value: badgeCount)
        }
    }
    
    
    // MARK: Image
    
    var imageView: UIImageView?
    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }
    
    
    // MARK: Init
    
    init (size: CGSize) {
        super.init(frame: CGRect (origin: CGPoint.zero, size: size))
        defaultInit()
    }
    
    init (image: UIImage) {
        let size = image.size
        super.init(frame: CGRect (origin: CGPoint.zero, size: size))
        self.image = image
        
        defaultInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func defaultInit () {
        
        // self
        snapOffset = snapOffsetMin
        layer.cornerRadius = w/2
        
        // image view
        imageView = UIImageView (frame: frame.insetBy(dx: 20, dy: 20))
        addSubview(imageView!)
        
        // circle border
        let borderView = UIView (frame: frame)
        borderView.layer.borderColor = UIColor.black.cgColor
        borderView.layer.borderWidth = 2
        borderView.layer.cornerRadius = w/2
        borderView.layer.masksToBounds = true
        borderView.isUserInteractionEnabled = false
        addSubview(borderView)
        
        // badge label
        badgeLabel = UILabel (frame: frame.insetBy(dx: 25, dy: 25))
        badgeLabel?.center = CGPoint(x:(left + badgeLabel!.w/2), y: (top + badgeLabel!.h/2))
        badgeLabel?.backgroundColor = UIColor.red
        badgeLabel?.textAlignment = NSTextAlignment.center
        badgeLabel?.textColor = UIColor.white
        badgeLabel?.text = "\(badgeCount)"
        badgeLabel?.layer.cornerRadius = badgeLabel!.w/2
        badgeLabel?.layer.masksToBounds = true
        addSubview(badgeLabel!)
        
        badgeCount = 0
        
        // events
        addTarget(self, action: #selector(BubbleControl.touchDown), for: UIControlEvents.touchDown)
        addTarget(self, action: #selector(BubbleControl.touchUp), for: UIControlEvents.touchUpInside)
        addTarget(self, action: #selector(BubbleControl.touchDrag(sender:event:)), for: UIControlEvents.touchDragInside)
        
        let longPress = UILongPressGestureRecognizer (target: self, action: #selector(BubbleControl.longPressHandler(press:)))
        longPress.minimumPressDuration = 0.75
        addGestureRecognizer(longPress)
        
        // place
        center.x = APPDELEGATE.window!.w - w/2 + snapOffset
        center.y = 84 + h/2
        snap()
    }
    
    
    // MARK: Snap To Edge
    
    func snap () {
        let window = APPDELEGATE.window!
        
        // if control on left side
        var targetX = window.leftWithOffset(offset: snapOffset)
        var badgeTargetX = w - badgeLabel!.w
        
        // if control on right side
        if center.x > window.w/2 {
            targetX = window.rightWithOffset(offset: snapOffset) - w
            badgeTargetX = 0
        }
        
        // move to snap position
        moveX(x: targetX)
        badgeLabel!.moveX(x: badgeTargetX)
    }
    
    func snapInside () {
        print("snap inside !")
        if !toggle && bubbleState == .Snap {
            snapOffset = snapOffsetMax
            snap()
        }
    }
    
    func setupSnapInsideTimer () {
        if !snapsInside {
            return
        }
        
        if let timer = snapInTimer {
            if timer.isValid {
                timer.invalidate()
            }
        }
        
        snapInTimer = Timer.scheduledTimer(timeInterval: snapInInterval,
                                           target: self,
                                           selector: #selector(BubbleControl.snapInside),
                                           userInfo: nil,
                                           repeats: false)
    }
    
    
    func lockInWindowBounds () {
        let window = APPDELEGATE.window!
        
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
            rect.origin.y = window.botttomWithOffset(offset: -h)
            frame = rect
        }
        
        if right > window.w {
            var rect = frame
            rect.origin.x = window.rightWithOffset(offset: -w)
            frame = rect
        }
    }
    
    
    // MARK: Events
    
    func touchDown () {
        bubble()
    }
    
    func touchUp () {
        if bubbleState == .Snap {
            toggle = !toggle
        } else {
            bubbleState = .Snap
            snap()
        }
    }
    
    func touchDrag (sender: BubbleControl, event: UIEvent) {
        bubbleState = .Drag
        
        if toggle {
            toggle = false
        }
        
        let touch = event.allTouches!.first!
        let location = touch.location(in: APPDELEGATE.window!)
        
        center = location
        lockInWindowBounds()
    }
    
    
    func longPressHandler (press: UILongPressGestureRecognizer) {
        
        if toggle {
            return
        }
        
        switch press.state {
        case .began:
            pop()
        case .ended:
            if bubbleState == .Pop {
                cancelPop()
            }
        default:
            return
        }
    }
    
    func navButtonPressed (sender: AnyObject) {
        didNavigationBarButtonPressed? ()
    }
    
    
    // MARK: Animations
    
    func animationDidStop(anim: CAAnimation!,
                          finished flag: Bool) {
        if flag {
            if anim == layer.animation(forKey: "pop") {
                layer.removeAnimation(forKey: "pop")
                
                didPop? ()
                
                if popsToNavBar {
                    popToNavBar()
                }
            }
        }
    }
    
    func degreesToRadians (angle: CGFloat) -> CGFloat {
        return (CGFloat (M_PI) * angle) / 180.0
    }
    
    
    // MARK: Pop
    
    func pop() {
        bubbleState = .Pop
        snap()
        
        let shake = CABasicAnimation(keyPath: "transform.rotation")
        shake.fromValue = degreesToRadians(angle: popAnimationShakeRotations.0)
        shake.toValue = degreesToRadians(angle: popAnimationShakeRotations.1)
        shake.duration = popAnimationShakeDuration
        shake.repeatCount = Float.infinity
        shake.autoreverses = true
        
        let grow = CABasicAnimation(keyPath: "transform.scale")
        grow.fromValue = 1
        grow.toValue = popAnimationScale
        grow.duration = popAnimationDuration
        
        let anims = CAAnimationGroup()
        anims.animations = [shake, grow]
        anims.duration = popAnimationDuration
        anims.delegate = self
        anims.isRemovedOnCompletion = false
        
        layer.add(anims, forKey: "pop")
    }
    
    func cancelPop () {
        snap()
        layer.removeAnimation(forKey: "pop")
    }
    
    
    func popToNavBar () {
        bubbleState = .NavBar
        
        spring(animations: { () -> Void in
            self.setScale(s: 0)
            self.alpha = 0.5
        }, completion: { finished in
            self.setScale(s: 1)
            self.isHidden = true
        })
        
        
        var barButton: UIBarButtonItem?
        
        if image != nil {
            let navButton = UIButton (frame: CGRect (x: 0, y: 0, width: 20, height: 20))
            navButton.setBackgroundImage(image!, for: .normal)
            navButton.addTarget(self, action: #selector(BubbleControl.navButtonPressed(sender:)),
                                for: .touchUpInside)
            
            barButton = UIBarButtonItem (customView: navButton)
        } else {
            barButton = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.action
                , target: self, action : #selector(BubbleControl.navButtonPressed(sender:)))
        }
        
        barButtonItem = barButton
        barButtonItem?.setBadgeValue(value: badgeCount)
        
        if let last = APPDELEGATE.window!.rootViewController as? UINavigationController {
            let vc = last.viewControllers[0]
            vc.navigationItem.setRightBarButton(barButtonItem!, animated: true)
        }
    }
    
    func popFromNavBar () {
        if let last = APPDELEGATE.window!.rootViewController as? UINavigationController {
            let vc = last.viewControllers[0]
            vc.navigationItem.rightBarButtonItem = nil
            
            bubbleState = .Snap
            self.barButtonItem = nil
            self.isHidden = false
            
            let toPosition = self.frame.origin
            self.position = CGPoint(x: APPDELEGATE.window!.right, y: APPDELEGATE.window!.top)
            self.movePoint(point: toPosition)
            self.alphaTo(to: 1)
        }
    }
    
    
    // MARK: Toggle
    
    func openContentView () {
        if let v = contentView {
            let win = APPDELEGATE.window!
            win.addSubview(v)
            win.bringSubview(toFront: self)
            
            snapOffset = snapOffsetMin
            snap()
            positionBeforeToggle = frame.origin
            
            if let anim = setOpenAnimation {
                anim (v, win.subviews[0] as UIView)
            } else {
                v.bottom = win.bottom
            }
            
            if movesBottom {
                movePoint(point: CGPoint (x: win.center.x - w/2, y: win.bottom - h - snapOffset))
            } else {
                moveY(y: v.top - h - snapOffset)
            }
        }
    }
    
    func closeContentView () {
        if let v = contentView {
            
            if let anim = setCloseAnimation {
                anim (v, (APPDELEGATE.window?.subviews[0])!)
            } else {
                v.removeFromSuperview()
            }
            
            if (bubbleState == .Snap) {
                setupSnapInsideTimer()
                movePoint(point: positionBeforeToggle!)
            }
        }
    }
}

// MARK: - UIBarButtonItem Badge Extension
private var barButtonAssociatedObjectBadge: UInt8 = 0
extension UIBarButtonItem {
    
    private var badgeLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &barButtonAssociatedObjectBadge) as! UILabel?
        } set (value) {
            objc_setAssociatedObject(self, &barButtonAssociatedObjectBadge, value, objc_AssociationPolicy(rawValue: UInt(objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN.rawValue))!)
        }
    }
    
    func setBadgeValue (value: Int) {
        print("value \(value)")
        if let label = badgeLabel {
            if value > 0 {
                label.isHidden = false
                label.text = "\(value)"
                label.bubble()
            } else {
                label.isHidden = true
            }
        } else {
            let view = self.value(forKey: "view") as? UIView
            
            badgeLabel = UILabel (frame: CGRect (x: 0, y: 0, width: 20, height: 20))
            badgeLabel?.center = CGPoint (x: (view?.right)!, y: (view?.top)!)
            badgeLabel?.backgroundColor = UIColor.red
            
            badgeLabel?.layer.cornerRadius = badgeLabel!.h/2
            badgeLabel?.layer.masksToBounds = true
            
            badgeLabel?.textAlignment = NSTextAlignment.center
            badgeLabel?.textColor = UIColor.white
            badgeLabel?.font = UIFont.systemFont(ofSize: 15)
            badgeLabel?.text = "\(value)"
            
            
            if value == 0 {
                badgeLabel?.isHidden = true
            }
            
            view?.addSubview(badgeLabel!)
        }
    }
}
