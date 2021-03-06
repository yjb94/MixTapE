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
        self.navigationController?.navigationBar.backIndicatorImage = Toucan(image:prevBtn!).resize(CGSize(width: 14, height: 25), fitMode: Toucan.Resize.FitMode.scale).image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = prevBtn
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.title = artist_data.name
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle
    {
        return UIStatusBarStyle.lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        self.chart_type = 1
        print(self.loaded_chart)
        //set loaded chart to loaded mixtape list
        //        self.loaded_chart = CHART_DATA.artist_list
        
        super.prepare(for: segue, sender: sender)
        
        let segueName = segue.identifier
        if segueName == "ArtistProfileSegue"
        {
            (segue.destination as! ArtistProfileViewController).artist_data = artist_data
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
