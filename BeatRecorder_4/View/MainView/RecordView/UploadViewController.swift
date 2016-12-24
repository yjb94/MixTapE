//
//  UploadViewController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 12. 13..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit
import Toucan
import TheAmazingAudioEngine
import Alamofire

class UploadViewController: UIViewController, UITextViewDelegate
{
    var audio_data:Audio!
    var audio_key:String = ""
    var mixtape_data:Mixtape?
    
    var lyrics_save:String = ""
    
    @IBOutlet weak var title_textfield: UITextField!
    @IBOutlet weak var bg_image_view: UIImageView!
    @IBOutlet weak var lyrics_text_view: UITextView!
    var lyric_placeholderLabel : UILabel!
    
    @IBOutlet weak var description_text_view: UITextView!
    var desc_placeholderLabel : UILabel!
    
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
        lyrics_text_view.text = lyrics_save
        lyric_placeholderLabel = UILabel()
        lyric_placeholderLabel.text = "Enter your Lyrics here..."
        lyric_placeholderLabel.font = UIFont.italicSystemFontOfSize(lyrics_text_view.font!.pointSize)
        lyric_placeholderLabel.sizeToFit()
        lyrics_text_view.addSubview(lyric_placeholderLabel)
        lyric_placeholderLabel.frame.origin = CGPointMake(5, lyrics_text_view.font!.pointSize / 2)
        lyric_placeholderLabel.textColor = UIColor.init(netHex: 0xa2a2a2)
        lyric_placeholderLabel.hidden = !lyrics_text_view.text.isEmpty
        
        
        //description view setting
        description_text_view.delegate = self
        desc_placeholderLabel = UILabel()
        desc_placeholderLabel.text = "Enter your Descriptions here..."
        desc_placeholderLabel.font = UIFont.italicSystemFontOfSize(description_text_view.font!.pointSize)
        desc_placeholderLabel.sizeToFit()
        description_text_view.addSubview(desc_placeholderLabel)
        desc_placeholderLabel.frame.origin = CGPointMake(5, description_text_view.font!.pointSize / 2)
        desc_placeholderLabel.textColor = UIColor.init(netHex: 0xa2a2a2)
        desc_placeholderLabel.hidden = !description_text_view.text.isEmpty
    }
    
    func textViewDidChange(textView: UITextView)
    {
        if textView == lyrics_text_view
        {
            lyric_placeholderLabel.hidden = !textView.text.isEmpty
        }
        else if textView == description_text_view
        {
            desc_placeholderLabel.hidden = !textView.text.isEmpty
        }
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onUploadClicked(sender: UIButton)
    {
        //server url
        HUDController.sharedInstance.show(self.view)
        let url = SERVER_URL+"api/file/"+audio_data.id+"_recording.m4a?id=" + String(USER_DATA.user.seq)
        
        //recording url
        let documentsUrl = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask , appropriateForURL: nil, create: true)
        let destination = documentsUrl.URLByAppendingPathComponent("recordings0.m4a", isDirectory: true)
        
        Alamofire.upload(.POST, url, multipartFormData:  { multipartFormData in
            multipartFormData.appendBodyPart(fileURL: self.audio_data.local_file_path!, name: self.audio_data.id+".mp3")
            
//            multipartFormData.appendBodyPart(fileURL: destination, name: "recording.m4a")
            
            }, encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .Success(request: let upload, _, _):
                    
                    upload.responseJSON { response in   //success
                        
                    HUDController.sharedInstance.dismiss()
                    self.performSegueWithIdentifier("mainTabBarView", sender: nil)
                        
                    }
                case .Failure(let encodingError):
                    HUDController.sharedInstance.dismiss()
                    print(encodingError)
                }
        })
    }
    @IBAction func onCloseButton(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion:{
        })
    }
}