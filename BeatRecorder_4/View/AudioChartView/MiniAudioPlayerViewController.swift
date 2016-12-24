//
//  MiniAudioPlayerViewController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 11. 27..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit
import TheAmazingAudioEngine

class MiniAudioPlayerViewController : UIViewController
{
    @IBOutlet weak var music_progress_bar: UIProgressView!
    @IBOutlet weak var artwork_image_view: UIImageView!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var artist_label: UILabel!
    @IBOutlet weak var playpause_button: UIButton!
    
    var chart_type:Int?
    
    var delegate:AudioChartContainerDelegateProtocol?
    
    var is_playing = false
    let ANIMA_SPEED = 0.2
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //background blur effect
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled()
        {
            self.view.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            self.view.insertSubview(blurEffectView, atIndex: 0) //if you have more UIViews, use an insertSubview API to place it where needed
        }
        else
        {
            self.view.backgroundColor = UIColor.blackColor()
        }
        
        //progress bar 용 타이머
        let loop_timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(MiniAudioPlayerViewController.progressTimer), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(loop_timer, forMode: NSRunLoopCommonModes)
        
        //add remove gesture
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(MiniAudioPlayerViewController.respondToSwipeGesture(_:)))
        swipe.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipe)
        
        //add tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(MiniAudioPlayerViewController.respondToTapGesture(_:)))
        self.view.addGestureRecognizer(tap)
    }
    func progressTimer()
    {
        if(is_playing)
        {
            music_progress_bar.progress = (delegate?.getPlaybackTime())!
        }
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let flag = delegate?.isPlaying()
        if flag == nil
        {
            return
        }
        is_playing = flag!
        
        if(is_playing)
        {
            playpause_button.setImage(UIImage(named:"audio_pause_circle.png"),forState:UIControlState.Normal)
        }
        else
        {
            playpause_button.setImage(UIImage(named:"audio_play_circle.png"),forState:UIControlState.Normal)
        }
    }
    
    @IBAction func onPlayPauseClick(sender: AnyObject)
    {
        is_playing = (delegate?.playPauseAudio())!
        
        if(is_playing)
        {
            playpause_button.setImage(UIImage(named:"audio_pause_circle.png"),forState:UIControlState.Normal)
        }
        else
        {
            playpause_button.setImage(UIImage(named:"audio_play_circle.png"),forState:UIControlState.Normal)
        }
    }
    
    func respondToSwipeGesture(gesture: UISwipeGestureRecognizer)
    {
        delegate?.stopAudio()
        delegate?.disappearAnimated()
    }
    
    func respondToTapGesture(gesture: UITapGestureRecognizer)
    {
        performSegueWithIdentifier("showAudioDetailView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "showAudioDetailView")
        {
            //set data
            let audioDetailViewController = (segue.destinationViewController as! AudioDetailViewController)
            audioDetailViewController.audio_data = delegate?.getAudioData()
            audioDetailViewController.audio_key = (delegate?.getAudioKey())!
            audioDetailViewController.chart_type = chart_type
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

