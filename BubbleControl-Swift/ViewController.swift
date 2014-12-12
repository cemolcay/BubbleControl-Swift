//
//  ViewController.swift
//  BubbleControl-Swift
//
//  Created by Cem Olcay on 11/12/14.
//  Copyright (c) 2014 Cem Olcay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APPDELEGATE.window?.addSubview(APPDELEGATE.bubble)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPressed(sender: AnyObject) {
        APPDELEGATE.bubble.badgeCount++
    }
    
    @IBAction func removePressed(sender: AnyObject) {
        APPDELEGATE.bubble.badgeCount--
    }
}

