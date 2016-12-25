//
//  AudioChartViewController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 11. 27..
//  Copyright © 2016년 Camo_u. All rights reserved.
//
//

import UIKit
import TheAmazingAudioEngine

protocol AudioChartContainerDelegateProtocol
{
    func getAudioChart() -> Chart
    
    func playAudioWith(_ audio:Audio)
    func isPlaying() -> Bool?
    func stopAudio()
    func playPauseAudio() -> Bool
    func getPlaybackTime() -> Float
    func getAudioData() -> Audio
    func getAudioKey() -> String
    
    func appearAnimated()
    func disappearAnimated()
    func setViewAudioDatas(_ audio:Audio, chart_type:Int)
}

class AudioChartViewController : UIViewController, AudioChartContainerDelegateProtocol
{
    @IBOutlet weak var audio_player_view: UIView!
    @IBOutlet weak var chart_container_view: UIView!
    
    var chart_type:Int = 0
    
    var loaded_chart:Chart = CHART_DATA.beat_list
    
    var cur_audio_key = ""
    
    let ANIMA_SPEED = 0.2
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //init datas(for animation)
        self.audio_player_view.frame.origin.x = -self.audio_player_view.frame.width
        self.audio_player_view.alpha = 0.0
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let segueName = segue.identifier
        
        if segueName == "AudioChartTableSegue"
        {
            (segue.destination as! AudioChartTableViewController).delegate = self;
            (segue.destination as! AudioChartTableViewController).chart_type = chart_type
        }
        else if segueName == "MiniAudioPlayerSegue"
        {
            (segue.destination as! MiniAudioPlayerViewController).delegate = self;
            (segue.destination as! MiniAudioPlayerViewController).chart_type = chart_type;
        }
    }
    func getAudioChart() -> Chart
    {
        return loaded_chart
    }
    
    func setViewAudioDatas(_ audio:Audio, chart_type:Int)
    {
        //set Miniplayer
        
        //get uiview from container
        let views = self.audio_player_view.subviews
        if (views.count == 0){ return; }
        
        //get subviews from views
        let subviews = views[0].subviews
        for view in subviews
        {
            //artwork image view
            if view.tag == 1
            {
                let artwork_view = view as! UIImageView
                let url = URL(string: audio.artwork_url)
                artwork_view.hnk_setImageFromURL(url!)
            }
            //title label
            if view.tag == 2
            {
                let title_label = view as! UILabel
                title_label.text = audio.title
            }
            //artist label
            if view.tag == 3
            {
                let artist_label = view as! UILabel
                artist_label.text = audio.artist
            }
        }
    }
    
    func appearAnimated()
    {
        if(audio_player_view.frame.origin.x >= 0)
        {
            self.audio_player_view.frame.origin.x = -self.audio_player_view.frame.width
        }
        //display animated
        UIView.animate(withDuration: self.ANIMA_SPEED, animations: {
            self.audio_player_view.frame.origin.x = 0
            self.audio_player_view.alpha = 1
        })
    }
    
    func disappearAnimated()
    {
        //display animated
        UIView.animate(withDuration: self.ANIMA_SPEED, animations: {
            self.audio_player_view.frame.origin.x = -self.audio_player_view.bounds.width
            self.audio_player_view.alpha = 0
            }, completion: { finished in
        })
    }
    
    func playAudioWith(_ audio: Audio)
    {
        if cur_audio_key != ""
        {
            AudioController.sharedInstance.stopAudio(cur_audio_key)
        }
        AudioController.sharedInstance.playAudioWith(audio)
        cur_audio_key = audio.id
    }
    
    func stopAudio()
    {
        if cur_audio_key != ""
        {
            AudioController.sharedInstance.stopAudio(cur_audio_key)
        }
        cur_audio_key = ""
    }
    
    func isPlaying() -> Bool?
    {
        if cur_audio_key != ""
        {
            return AudioController.sharedInstance.isPlaying(cur_audio_key)
        }
        return nil
    }
    
    func playPauseAudio() -> Bool
    {
        return AudioController.sharedInstance.playPause(cur_audio_key)
    }
    
    func getPlaybackTime() -> Float
    {
        return AudioController.sharedInstance.getPlaybackTime(cur_audio_key)
    }
    
    func getAudioData() -> Audio
    {
        return AudioController.sharedInstance.getAudioData(cur_audio_key)!
    }
    func getAudioKey() -> String
    {
        return cur_audio_key
    }
}

