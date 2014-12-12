//
//  ViewController.swift
//  BubbleControl-Swift
//
//  Created by Cem Olcay on 11/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var bubble: BubbleControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBubble()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupBubble () {
        bubble = BubbleControl (size: CGSizeMake(80, 80))
        bubble?.image = UIImage (named: "basket.png")
        bubble?.navButtonAction = {
            println("pressed in nav bar")
            self.bubble!.popFromNavBar()
        }
        
        bubble?.contentView = {
            let v = UIView (frame: CGRect (x: 0, y: 0, width: self.view.w, height: 200))
            v.backgroundColor = UIColor.grayColor()
            
            let label = UILabel (frame: CGRect (x: 10, y: 10, width: v.w, height: 20))
            label.text = "test text"
            v.addSubview(label)
            
            return v
        }
        
        APPDELEGATE.window!!.addSubview(bubble!)
    }
    
    @IBAction func addPressed(sender: AnyObject) {
        bubble?.badgeCount++
    }
    
    @IBAction func removePressed(sender: AnyObject) {
        bubble?.badgeCount--
    }
}

