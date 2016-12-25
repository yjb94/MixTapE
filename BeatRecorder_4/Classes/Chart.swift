//
//  Chart.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 11. 23..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit



class Chart
{
    var chart_type:Int = 0
    
    var audio_data_list = Array<Audio>()
    var user_data_list = Array<User>()
    
    init(chart_type:Int=0)
    {
        self.chart_type = chart_type
    }
    
    func getChartLength() -> Int
    {
        if chart_type == 0 || chart_type == 2
        {
            return audio_data_list.count
        }
        else if chart_type == 1
        {
            return user_data_list.count
        }
        return 0
    }
    
    func addAudio(_ audio:Audio)
    {
        audio_data_list.append(audio)
    }
    
    func addUser(_ user:User)
    {
        user_data_list.append(user)
    }
    
    func getAudioDataAt(_ index:Int) -> Audio
    {
        if getChartLength() >= index
        {
            return audio_data_list[index]
        }
        return Audio()
    }
    
    func getUserDataAt(_ index:Int) -> User!
    {
        if getChartLength() >= index
        {
            return user_data_list[index]
        }
        return User()
    }
}
