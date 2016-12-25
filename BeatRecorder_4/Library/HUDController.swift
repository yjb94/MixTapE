//
//  HUDController.swift
//  BeatRecorder_3
//
//  Created by Camo_u on 2016. 9. 8..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit
import JGProgressHUD

class HUDController: NSObject
{
    static let sharedInstance = HUDController()   //singleton
    
    var hud:JGProgressHUD!
    
    init(style:JGProgressHUDStyle=JGProgressHUDStyle.dark, text:String = "")
    {
        self.hud = JGProgressHUD(style:style)
        if text != ""
        {
            self.hud.textLabel.text = text;
        }
    }
    
    func show(_ in_view:UIView)
    {
        self.hud.show(in: in_view)
    }
    
    func dismiss()
    {
        self.hud.dismiss(animated: true)
    }
}
        
