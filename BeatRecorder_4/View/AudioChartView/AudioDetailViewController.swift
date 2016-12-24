//
//  AudioDetailViewController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 11. 29..
//  Copyright © 2016년 Camo_u. All rights reserved.
//
import Toucan
import Haneke
import UIKit

class AudioDetailViewController: UIViewController
{
    var audio_data:Audio!
    var audio_key:String = ""
    var is_playing = true
    var chart_type:Int!
    @IBOutlet weak var bg_image_view: UIImageView!
    @IBOutlet weak var artwork_image_view: UIImageView!

    @IBOutlet weak var playback_slider: UISlider!

    @IBOutlet weak var artist_label: UILabel!
    @IBOutlet weak var title_label: UILabel!
    
    @IBOutlet weak var cur_time_label: UILabel!
    @IBOutlet weak var duration_label: UILabel!
    @IBOutlet weak var star_button: UIButton!
    @IBOutlet weak var playpause_button: UIButton!
    
    @IBOutlet weak var seperate_line: UIView!
    @IBOutlet weak var lyrics_label: UILabel!
    
    @IBOutlet weak var select_button: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if audio_data == nil
        {
            self.dismissViewControllerAnimated(false, completion: nil)
            return
        }
        
        if chart_type == 1 || chart_type == 2
        {
            select_button.hidden = true
        }
        
        //label setting
        title_label.text = audio_data.title
        title_label.adjustsFontSizeToFitWidth = true
        
        artist_label.text = audio_data.artist
        star_button.setTitle(String(audio_data.like_cnt) + " LIKES", forState: .Normal)
        
        //image setting
        let url = NSURL(string: audio_data.artwork_url)
        artwork_image_view.hnk_setImageFromURL(url!, placeholder: nil, format: nil, failure: nil) { data in
            //after loading
            //set artwork
            self.artwork_image_view.image = data
        }
        
        self.bg_image_view.hnk_setImageFromURL(url!, placeholder: nil, format: nil, failure: nil) { data in
            //set artwork bg
            self.bg_image_view.image =  Toucan(image:data).resize(CGSize(width: self.view.bounds.width, height: self.view.bounds.height), fitMode: Toucan.Resize.FitMode.Crop).image
            
            let overlay = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            overlay.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            self.bg_image_view.addSubview(overlay)
        }
        
        //lyric label
        var frame = lyrics_label.frame
        frame.size.height = 40
        
        if UIDevice.currentDevice().modelName == "iPhone 5" ||
         UIDevice.currentDevice().modelName == "iPhone 5c" ||
         UIDevice.currentDevice().modelName == "iPhone 5s"
        {
            lyrics_label.numberOfLines = 4
        }
        if UIDevice.currentDevice().modelName == "iPhone 6" ||
            UIDevice.currentDevice().modelName == "iPhone 6s" ||
            UIDevice.currentDevice().modelName == "iPhone SE" ||
            UIDevice.currentDevice().modelName == "iPhone 7"
        {
            lyrics_label.numberOfLines = 8
        }
        if UIDevice.currentDevice().modelName == "iPhone 6 Plus" ||
            UIDevice.currentDevice().modelName == "iPhone 6s Plus" ||
            UIDevice.currentDevice().modelName == "iPhone 7 Plus"
        {
            lyrics_label.numberOfLines = 8
        }
        
        lyrics_label.frame = frame
        lyrics_label.text = audio_data.description
        lyrics_label.lineBreakMode = .ByWordWrapping
        
        //play audio
        if audio_key == ""
        {
            AudioController.sharedInstance.playAudioWith(audio_data, callback: { key in
                self.audio_key = key
                self.playpause_button.setImage(UIImage(named:"detail_view_pause_button.png"),forState:UIControlState.Normal)
                self.setPlayback()
            })
        }
        else
        {
            setPlayback()
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        is_playing = AudioController.sharedInstance.isPlaying(audio_key)
        
        if(is_playing)
        {
            playpause_button.setImage(UIImage(named:"detail_view_pause_button.png"),forState:UIControlState.Normal)
        }
        else
        {
            playpause_button.setImage(UIImage(named:"detail_view_play_button.png"),forState:UIControlState.Normal)
        }
    }
    
    
    func setPlayback()
    {
        //playback
        playback_slider.minimumValue = 0
        playback_slider.maximumValue = Float(AudioController.sharedInstance.getAudioDuration(audio_key))
        playback_slider.value = Float(AudioController.sharedInstance.getAudioCurrentTime(audio_key))
        playback_slider.addTarget(self, action: #selector(AudioDetailViewController.sliderValueChanged(_:)), forControlEvents: .ValueChanged)
        
        //cur time
        cur_time_label.text = String(Utils.secondToMMSS(Int(AudioController.sharedInstance.getAudioCurrentTime(audio_key))))
        
        //duration
        duration_label.text = String(Utils.secondToMMSS(Int(AudioController.sharedInstance.getAudioDuration(audio_key))))
        
        //set thumb
        let thumb_img = UIImage(named: "playback_thumb.png")!
        playback_slider.setThumbImage(Toucan(image:thumb_img).resize(CGSize(width: 15, height: 15), fitMode: Toucan.Resize.FitMode.Scale).image, forState: .Normal)
        
        //playback 용 타이머
        let loop_timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(AudioDetailViewController.progressTimer), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(loop_timer, forMode: NSRunLoopCommonModes)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func sliderValueChanged(sender:UISlider)
    {
        if audio_key == ""
        {
            return
        }
        AudioController.sharedInstance.audioAtTime(NSTimeInterval(sender.value), key: audio_key)
        AudioController.sharedInstance.play(true, key: audio_key)
        cur_time_label.text = String(Utils.secondToMMSS(Int(AudioController.sharedInstance.getAudioCurrentTime(audio_key))))
    }
    
    func progressTimer()
    {
        if audio_key == ""
        {
            return
        }
        
        if(AudioController.sharedInstance.isPlaying(audio_key))
        {
            playback_slider.value = Float(AudioController.sharedInstance.getAudioCurrentTime(audio_key))
            //cur time
            cur_time_label.text = String(Utils.secondToMMSS(Int(AudioController.sharedInstance.getAudioCurrentTime(audio_key))))
        }
    }
    
    @IBAction func onCloseClicked(sender: UIButton)
    {
        if chart_type == 0 //if mixtape beat chart
        {
            let tab_bar = self.presentingViewController
            let tab_bar_nav = tab_bar!.childViewControllers[2] as! TabbarNavigationController
            let audio_chart_view_controller = tab_bar_nav.childViewControllers[0] as! AudioChartViewController
            audio_chart_view_controller.setViewAudioDatas(self.audio_data, chart_type: self.chart_type)
            audio_chart_view_controller.appearAnimated()

        }
        else if chart_type == 1 //artist chart
        {
            let tab_bar = self.presentingViewController
            let tab_bar_nav = tab_bar!.childViewControllers[0] as! TabbarNavigationController
            let artist_info_view_controller = tab_bar_nav.childViewControllers[1] as!ArtistInfoViewController
            artist_info_view_controller.setViewAudioDatas(self.audio_data, chart_type: self.chart_type)
            artist_info_view_controller.appearAnimated()
        }
        else if chart_type == 2 //music chart
        {
            let tab_bar = self.presentingViewController
            let tab_bar_nav = tab_bar!.childViewControllers[1] as! TabbarNavigationController
            let music_chart_view_controller = tab_bar_nav.childViewControllers[0] as! MusicChartViewController
            music_chart_view_controller.setViewAudioDatas(self.audio_data, chart_type: self.chart_type)
            music_chart_view_controller.appearAnimated()
        }
        
        self.dismissViewControllerAnimated(true, completion:{
        })
    }
    
    @IBAction func onPlayPauseClick(sender: AnyObject)
    {
        is_playing = AudioController.sharedInstance.playPause(audio_key)
        
        if(is_playing)
        {
            playpause_button.setImage(UIImage(named:"detail_view_pause_button.png"),forState:UIControlState.Normal)
        }
        else
        {
            playpause_button.setImage(UIImage(named:"detail_view_play_button.png"),forState:UIControlState.Normal)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showRecordView"
        {
            //set data
            let audioDetailViewController = (segue.destinationViewController as! RecordViewController)
            //set audio data
            audioDetailViewController.audio_data = self.audio_data
            audioDetailViewController.audio_key = audio_key
        }
    }
    @IBAction func onLikeClicked(sender: AnyObject)
    {
        star_button.setTitle(String(audio_data.like_cnt+1) + " LIKES", forState: .Normal)
    }
}