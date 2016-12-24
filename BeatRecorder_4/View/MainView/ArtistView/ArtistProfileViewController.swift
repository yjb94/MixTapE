//
//  ArtistInfoViewController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 12. 10..
//  Copyright © 2016년 Camo_u. All rights reserved.
//
import Toucan
import UIKit

class ArtistProfileViewController: UIViewController
{
    var artist_data:Artist!
    
    @IBOutlet weak var cover_image: UIImageView!
    @IBOutlet weak var profile_image: UIImageView!
    
    @IBOutlet weak var artist_label: UILabel!
    
    @IBOutlet weak var following_cnt: UIButton!
    @IBOutlet weak var follwer_cnt: UIButton!
    @IBOutlet weak var mixtape_cnt: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //set view datas
        profile_image.hnk_setImageFromURL(NSURL(string: artist_data.profile_url)!, placeholder: nil, format: nil, failure: nil) { data in
            //after loading
            //set profile
            self.profile_image.image = data
            self.profile_image.layer.borderWidth = 1.0
            self.profile_image.layer.masksToBounds = false
            self.profile_image.layer.borderColor = UIColor.clearColor().CGColor
            self.profile_image.layer.cornerRadius = self.profile_image.frame.width/2
            self.profile_image.clipsToBounds = true
        }
        
        cover_image.hnk_setImageFromURL(NSURL(string: artist_data.thumbnail_url)!, placeholder: nil, format: nil, failure: nil) { data in
            //after loading
            //set profile
            self.cover_image.image = Toucan(image: data).resizeByCropping(CGSize(width: 600, height: 172)).image
            
            let overlay = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 197))
            overlay.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            self.cover_image.addSubview(overlay)
        }
        
        artist_label.text = artist_data.name
        
        mixtape_cnt.setTitle(String(artist_data.mixtape_cnt), forState: .Normal)
        follwer_cnt.setTitle(String(artist_data.follwer_cnt), forState: .Normal)
        following_cnt.setTitle(String(artist_data.follwings_cnt), forState: .Normal)
        
        if(artist_data.seq == USER_DATA.user.seq)
        {
            following_cnt.enabled = false
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
    }
    @IBAction func onViewMixtape(sender: AnyObject)
    {
    }
    @IBAction func onFollowerClick(sender: AnyObject)
    {
    }
    @IBAction func onFollowingClick(sender: AnyObject)
    {
        following_cnt.setTitle(String(artist_data.follwings_cnt+1), forState: .Normal)
    }
}
