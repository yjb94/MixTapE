//
//  MainTabBarViewController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 11. 12..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit
import Haneke

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor.init(netHex: 0x00b2b2)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem)
    {
        if(item.title == "CHART")
        {
        }
        else if(item.title == "MUSIC")
        {
//            let tab_bar_nav = self.childViewControllers[1] as! TabbarNavigationController
//            let music_chart_view_controller = tab_bar_nav.childViewControllers[0] as! MusicChartViewController
//            music_chart_view_controller.loaded_chart
            
//            let cache = Shared.JSONCache
//            
//            cache.fetch(URL: NSURL(string: "https://api.soundcloud.com/resolve.json?url=http://soundcloud.com/huntsss/illuminati-livin&client_id=175c043157ffae2c6d5fed16c3d95a4c")!).onSuccess { JSON in
//
//                music_chart_view_controller
//            }
        }
        else if(item.title == "MIXTAPE")
        {
        }
        else if(item.title == "SETTINGS")
        {
            
        }
    }
}
