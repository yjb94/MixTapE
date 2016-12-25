//
//  TabbarNavigationController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 11. 25..
//  Copyright © 2016년 Camo_u. All rights reserved.
//
import UIKit

class TabbarNavigationController : UINavigationController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set nav bar color
        self.navigationBar.barTintColor = UIColor.init(red: 0, green: 178, blue: 178)
        
        //set nav bar text datas
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Raleway", size: 20)!]
        self.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
