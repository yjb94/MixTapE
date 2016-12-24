//
//  RecordViewController.swift
//  BeatRecorder_3
//
//  Created by Camo_u on 2016. 9. 3..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit
import Toucan
import TheAmazingAudioEngine

class RecordViewController : UIViewController, UITextViewDelegate
{
    var audio_data:Audio!
    var audio_key:String = ""
    var is_playing = true
    
    var audio_mixer = AudioMixer()
    
    @IBOutlet weak var bg_image_view: UIImageView!
    
    @IBOutlet weak var lyrics_text_view: UITextView!
    var placeholderLabel : UILabel!
    
    @IBOutlet weak var dance_button: RadioButton!
    @IBOutlet weak var edge_button: RadioButton!
    @IBOutlet weak var natural_button: RadioButton!
    @IBOutlet weak var bright_button: RadioButton!
    @IBOutlet weak var custom_button: RadioButton!
    
    @IBOutlet weak var playback_slider: CustomSlider!
    
    @IBOutlet weak var playpause_button: UIButton!
    @IBOutlet weak var record_button: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        if audio_data == nil
        {
            self.dismissViewControllerAnimated(false, completion: nil)
            return
        }
        
        //image setting
        let url = NSURL(string: audio_data.artwork_url)
        self.bg_image_view.hnk_setImageFromURL(url!, placeholder: nil, format: nil, failure: nil) { data in
            //set artwork bg
            self.bg_image_view.image =  Toucan(image:data).resize(CGSize(width: self.view.bounds.width, height: self.view.bounds.height), fitMode: Toucan.Resize.FitMode.Crop).image
            
            let overlay = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            overlay.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            self.bg_image_view.addSubview(overlay)
            
        }
        
        //lyrics view setting
        lyrics_text_view.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter your Lyrics here..."
        placeholderLabel.font = UIFont.italicSystemFontOfSize(lyrics_text_view.font!.pointSize)
        placeholderLabel.sizeToFit()
        lyrics_text_view.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, lyrics_text_view.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor.init(netHex: 0xa2a2a2)
        placeholderLabel.hidden = !lyrics_text_view.text.isEmpty
        
        
        //radio button setting
        dance_button.selected = false
        edge_button.selected = false
        natural_button.selected = false
        bright_button.selected = false
        custom_button.selected = false
        
        dance_button?.alternateButton = [edge_button!, natural_button!, bright_button!, custom_button!]
        edge_button?.alternateButton = [dance_button!, natural_button!, bright_button!, custom_button!]
        natural_button?.alternateButton = [dance_button!, edge_button!, bright_button!, custom_button!]
        bright_button?.alternateButton = [dance_button!, edge_button!, natural_button!, custom_button!]
        custom_button?.alternateButton = [dance_button!, edge_button!, natural_button!, bright_button!]
        
        
        
        //audio settings
        initAudio();
        
        //set playback
        setPlayback();
    }
    
    
    func setPlayback()
    {
        //playback
        playback_slider.minimumValue = 0
        playback_slider.maximumValue = Float(AudioController.sharedInstance.getAudioDuration(audio_key))
        playback_slider.value = Float(AudioController.sharedInstance.getAudioCurrentTime(audio_key))
        playback_slider.addTarget(self, action: #selector(RecordViewController.sliderValueChanged(_:)), forControlEvents: .ValueChanged)
        
        //set thumb
        let thumb_img = UIImage(named: "playback_thumb.png")!
        playback_slider.setThumbImage(Toucan(image:thumb_img).resize(CGSize(width: 15, height: 15), fitMode: Toucan.Resize.FitMode.Scale).image, forState: .Normal)
        
        //playback 용 타이머
        let loop_timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RecordViewController.progressTimer), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(loop_timer, forMode: NSRunLoopCommonModes)
    }
    
    func sliderValueChanged(sender:UISlider)
    {
        if audio_key == ""
        {
            return
        }
        AudioController.sharedInstance.audioAtTime(NSTimeInterval(sender.value), key: audio_key)
//        AudioController.sharedInstance.play(true, key: audio_key)
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
        }
    }

    func initAudio()
    {
        //audio to 0 sec
        AudioController.sharedInstance.audioAtTime(0, key: audio_key)
        
        //set audio(paused)
        AudioController.sharedInstance.play(false, key: audio_key)
        is_playing = false
        
        //set playthrough
        AudioController.sharedInstance.addPlaythrough()
    }
    
    func textViewDidChange(textView: UITextView)
    {
        placeholderLabel.hidden = !textView.text.isEmpty
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //audio settings
        initAudio();
        
        //set playback
        setPlayback();
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func onRecordStartStop(sender: UIButton)
    {
        if(!AudioController.sharedInstance.isRecording())
        {
            AudioController.sharedInstance.startRecord(0, key: audio_key)
            record_button.setImage(UIImage(named:"record_stop_button.png"),forState:UIControlState.Normal)
        }
        else
        {
            AudioController.sharedInstance.stopRecord()
            record_button.setImage(UIImage(named:"record_start_button.png"),forState:UIControlState.Normal)
        }
    }
    
    @IBAction func onAudioPlayPause(sender: UIButton)
    {
        is_playing = AudioController.sharedInstance.playPause(audio_key)
        
        if(is_playing)
        {
            AudioController.sharedInstance.playRecording(0)
            playpause_button.setImage(UIImage(named:"record_pasue_button.png"),forState:UIControlState.Normal)
        }
        else
        {
            playpause_button.setImage(UIImage(named:"record_play_button.png"),forState:UIControlState.Normal)
        }
    }
        
    @IBAction func onDoneClicked(sender: UIButton)
    {
        
    }
    
    @IBAction func onCloseButton(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion:{
        })
    }
    @IBAction func onFilterSelected(sender: UIButton)
    {
        audio_mixer.dynamics.removeFilter()
        audio_mixer.equalizer.removeFilter()
        audio_mixer.chorus.removeFilter()
        audio_mixer.sends.removeFilter()
        
        if dance_button.selected
        {
            audio_mixer.sends.setReverb(40, ambience: 1)
            audio_mixer.chorus.setChorus(0.001)
        }
        else if edge_button.selected
        {
            audio_mixer.dynamics.setCompression(0.001)
            audio_mixer.sends.setReverb(20, ambience: 0)
        }
        else if natural_button.selected
        {
            audio_mixer.sends.setReverb(40, ambience: 1)
        }
        else if bright_button.selected
        {
            audio_mixer.sends.setReverb(80, ambience: 0)
        }
        else if custom_button.selected
        {
            audio_mixer.sends.setReverb(40, ambience: 1)
            audio_mixer.equalizer.setEQ(0.5, high_amout: 0.5)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showUploadView"
        {
            //set data
            let uploadViewController = (segue.destinationViewController as! UploadViewController)
            //set audio data
            uploadViewController.audio_data = self.audio_data
            uploadViewController.audio_key = audio_key
            uploadViewController.lyrics_save = lyrics_text_view.text
        }
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        audio_mixer.dynamics.removeFilter()
        audio_mixer.equalizer.removeFilter()
        audio_mixer.chorus.removeFilter()
        audio_mixer.sends.removeFilter()
        
        AudioController.sharedInstance.stopRecordPlaying()
        AudioController.sharedInstance.removePlaythrough()
    }
}
