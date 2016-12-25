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
            self.view.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.view.insertSubview(blurEffectView, at: 0) //if you have more UIViews, use an insertSubview API to place it where needed
        }
        else
        {
            self.view.backgroundColor = UIColor.black
        }
        
        //progress bar 용 타이머
        let loop_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MiniAudioPlayerViewController.progressTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(loop_timer, forMode: RunLoopMode.commonModes)
        
        //add remove gesture
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(MiniAudioPlayerViewController.respondToSwipeGesture(_:)))
        swipe.direction = UISwipeGestureRecognizerDirection.left
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
    override func viewWillAppear(_ animated: Bool)
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
            playpause_button.setImage(UIImage(named:"audio_pause_circle.png"),for:UIControlState())
        }
        else
        {
            playpause_button.setImage(UIImage(named:"audio_play_circle.png"),for:UIControlState())
        }
    }
    
    @IBAction func onPlayPauseClick(_ sender: AnyObject)
    {
        is_playing = (delegate?.playPauseAudio())!
        
        if(is_playing)
        {
            playpause_button.setImage(UIImage(named:"audio_pause_circle.png"),for:UIControlState())
        }
        else
        {
            playpause_button.setImage(UIImage(named:"audio_play_circle.png"),for:UIControlState())
        }
    }
    
    func respondToSwipeGesture(_ gesture: UISwipeGestureRecognizer)
    {
        delegate?.stopAudio()
        delegate?.disappearAnimated()
    }
    
    func respondToTapGesture(_ gesture: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "showAudioDetailView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "showAudioDetailView")
        {
            //set data
            let audioDetailViewController = (segue.destination as! AudioDetailViewController)
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

