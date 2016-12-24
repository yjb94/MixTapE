//
//  ArtistInfoViewController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 12. 10..
//  Copyright © 2016년 Camo_u. All rights reserved.
//
import Toucan
import UIKit

class ArtistInfoViewController: AudioChartViewController
{
    var artist_data:Artist!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //customize prev button
        let prevBtn = UIImage(named:"nav_bar_prev_button")
        self.navigationController?.navigationBar.backIndicatorImage = Toucan(image:prevBtn!).resize(CGSize(width: 14, height: 25), fitMode: Toucan.Resize.FitMode.Scale).image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = prevBtn
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.title = artist_data.name
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        self.chart_type = 1
        print(self.loaded_chart)
        //set loaded chart to loaded mixtape list
        //        self.loaded_chart = CHART_DATA.artist_list
        
        super.prepareForSegue(segue, sender: sender)
        
        let segueName = segue.identifier
        if segueName == "ArtistProfileSegue"
        {
            (segue.destinationViewController as! ArtistProfileViewController).artist_data = artist_data
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
