//
//  MusicChartViewController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 12. 11..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit

class MusicChartViewController: AudioChartViewController
{
    var temp:Int?
    
    override func viewDidLoad()
    {
//        print(temp)
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        self.chart_type = 2
        self.loaded_chart = CHART_DATA.mixtape_list
        
        super.prepare(for: segue, sender: sender)
    }
}
