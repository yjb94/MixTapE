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
            self.dismiss(animated: false, completion: nil)
            return
        }
        
        //image setting
        let url = URL(string: audio_data.artwork_url)
        self.bg_image_view.hnk_setImageFromURL(url!, placeholder: nil, format: nil, failure: nil) { data in
            //set artwork bg
            self.bg_image_view.image =  Toucan(image:data).resize(CGSize(width: self.view.bounds.width, height: self.view.bounds.height), fitMode: Toucan.Resize.FitMode.crop).image
            
            let overlay = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            overlay.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            self.bg_image_view.addSubview(overlay)
            
        }
        
        //lyrics view setting
        lyrics_text_view.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter your Lyrics here..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: lyrics_text_view.font!.pointSize)
        placeholderLabel.sizeToFit()
        lyrics_text_view.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: lyrics_text_view.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor.init(netHex: 0xa2a2a2)
        placeholderLabel.isHidden = !lyrics_text_view.text.isEmpty
        
        
        //radio button setting
        dance_button.isSelected = false
        edge_button.isSelected = false
        natural_button.isSelected = false
        bright_button.isSelected = false
        custom_button.isSelected = false
        
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
        playback_slider.addTarget(self, action: #selector(RecordViewController.sliderValueChanged(_:)), for: .valueChanged)
        
        //set thumb
        let thumb_img = UIImage(named: "playback_thumb.png")!
        playback_slider.setThumbImage(Toucan(image:thumb_img).resize(CGSize(width: 15, height: 15), fitMode: Toucan.Resize.FitMode.scale).image, for: .normal)
        
        //playback 용 타이머
        let loop_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RecordViewController.progressTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(loop_timer, forMode: RunLoopMode.commonModes)
    }
    
    func sliderValueChanged(_ sender:UISlider)
    {
        if audio_key == ""
        {
            return
        }
        AudioController.sharedInstance.audioAtTime(TimeInterval(sender.value), key: audio_key)
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
    
    func textViewDidChange(_ textView: UITextView)
    {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    override func viewWillAppear(_ animated: Bool)
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle
    {
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func onRecordStartStop(_ sender: UIButton)
    {
        if(!AudioController.sharedInstance.isRecording())
        {
            AudioController.sharedInstance.startRecord(0, key: audio_key)
            record_button.setImage(UIImage(named:"record_stop_button.png"),for:UIControlState())
        }
        else
        {
            AudioController.sharedInstance.stopRecord()
            record_button.setImage(UIImage(named:"record_start_button.png"),for:UIControlState())
        }
    }
    
    @IBAction func onAudioPlayPause(_ sender: UIButton)
    {
        is_playing = AudioController.sharedInstance.playPause(audio_key)
        
        if(is_playing)
        {
            AudioController.sharedInstance.playRecording(0)
            playpause_button.setImage(UIImage(named:"record_pasue_button.png"),for:UIControlState())
        }
        else
        {
            playpause_button.setImage(UIImage(named:"record_play_button.png"),for:UIControlState())
        }
    }
        
    @IBAction func onDoneClicked(_ sender: UIButton)
    {
        
    }
    
    @IBAction func onCloseButton(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion:{
        })
    }
    @IBAction func onFilterSelected(_ sender: UIButton)
    {
        audio_mixer.dynamics.removeFilter()
        audio_mixer.equalizer.removeFilter()
        audio_mixer.chorus.removeFilter()
        audio_mixer.sends.removeFilter()
        
        if dance_button.isSelected
        {
            audio_mixer.sends.setReverb(40, ambience: 1)
            audio_mixer.chorus.setChorus(0.001)
        }
        else if edge_button.isSelected
        {
            audio_mixer.dynamics.setCompression(0.001)
            audio_mixer.sends.setReverb(20, ambience: 0)
        }
        else if natural_button.isSelected
        {
            audio_mixer.sends.setReverb(40, ambience: 1)
        }
        else if bright_button.isSelected
        {
            audio_mixer.sends.setReverb(80, ambience: 0)
        }
        else if custom_button.isSelected
        {
            audio_mixer.sends.setReverb(40, ambience: 1)
            audio_mixer.equalizer.setEQ(0.5, high_amout: 0.5)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showUploadView"
        {
            //set data
            let uploadViewController = (segue.destination as! UploadViewController)
            //set audio data
            uploadViewController.audio_data = self.audio_data
            uploadViewController.audio_key = audio_key
            uploadViewController.lyrics_save = lyrics_text_view.text
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        audio_mixer.dynamics.removeFilter()
        audio_mixer.equalizer.removeFilter()
        audio_mixer.chorus.removeFilter()
        audio_mixer.sends.removeFilter()
        
        AudioController.sharedInstance.stopRecordPlaying()
        AudioController.sharedInstance.removePlaythrough()
    }
}
