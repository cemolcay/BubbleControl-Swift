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
        
        view.addSubview(bubble!)
    }
    
    @IBAction func addPressed(sender: AnyObject) {
        bubble?.badgeCount++
    }
    
    @IBAction func removePressed(sender: AnyObject) {
        bubble?.badgeCount--
    }
}

