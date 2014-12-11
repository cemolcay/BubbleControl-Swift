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
        
        bubble?.layer.borderWidth = 2
        bubble?.layer.borderColor = UIColor.blackColor().CGColor
        
        view.addSubview(bubble!)
    }
    
    @IBAction func addPressed(sender: AnyObject) {
        bubble?.badgeCount++
    }
    
    @IBAction func removePressed(sender: AnyObject) {
        bubble?.badgeCount--
    }
}

