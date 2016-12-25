//
//  SettingsViewController.swift
//  BeatRecorder_3
//
//  Created by Camo_u on 2016. 9. 3..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit
import Haneke

class SettingsViewController: UIViewController
{
    @IBOutlet weak var onoff_label: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        onoff_label.text = (USER_DATA.auto_login == "TRUE") ? "OFF" : "ON"

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        let segueName = segue.identifier
        if segueName == "ArtistProfileSegue"
        {
            //set to loginned user
            (segue.destination as! ArtistProfileViewController).artist_data = USER_DATA.user as! Artist
        }
    }
    
    @IBAction func onAutoLoginOnOff(_ sender: AnyObject)
    {
        USER_DATA.auto_login = (USER_DATA.auto_login == "TRUE") ? "FALSE" : "TRUE"
        onoff_label.text = (USER_DATA.auto_login == "TRUE") ? "OFF" : "ON"

        let cache = Shared.dataCache
        cache.set(value: USER_DATA.auto_login.data(using: String.Encoding.utf8)!, key: USER_DATA.AUTO_LOGIN_KEY)
    }

}
