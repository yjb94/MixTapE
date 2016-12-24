//
//  JoinViewController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 9. 26..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class JoinViewController: UIViewController
{
    var email_save:String = "";
    var password_save:String = "";
    
    @IBOutlet weak var email_textfield: UITextField!
    @IBOutlet weak var password_textfield: UITextField!
    @IBOutlet weak var password_confirm_textfield: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        email_textfield.text = email_save
        password_textfield.text = password_save
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onClose(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    @IBAction func onJoinButtonClicked(sender:AnyObject)
    {
        if(!checkJoinError())  //no error
        {
            let params:[String : AnyObject] = [
                "email": email_textfield.text!,
                "password":password_textfield.text!
            ]
            
            Alamofire.request(.POST, SERVER_URL+"api/user/", parameters:params , encoding: ParameterEncoding.JSON).responseJSON { response in
                HUDController.sharedInstance.dismiss()
                switch response.result
                {
                case .Success:
                    //save json datas
                    if let JSON = response.result.value
                    {
                        let dict:NSMutableDictionary = JSON as! NSMutableDictionary
                        USER_DATA.user = Artist(seq: dict["sequence"] as! Int, name: String(dict["nickname"]!), profile_url: String(dict["profile_url"]!), thumbnail_url: String(dict["thumbnail_url"]!), email: String(dict["email"]!), password: String(dict["password"]!))
                        
                        //load music chart, artist chart, beat chart
                        self.performSegueWithIdentifier("mainTabBarView", sender: self)
                    }
                    
                case .Failure( _):
                    print(response.result.description)
                    //                        self.performSegueWithIdentifier("showJoinView", sender: self)
                }
            }
        }
    }
    
    func checkJoinError() ->Bool
    {
        var err_msg = "";
        
        //check password
        if( password_textfield.text == "")
        {
            err_msg = "plz input password"
        }
        if( password_textfield.text?.characters.count >= Int(_PASSWORD_LEN))
        {
            err_msg = "password too long"
        }
        if (password_textfield.text?.characters.count <  MIN_PASSWORD_LEN)
        {
            err_msg = "password must be longer than 8"
        }
        if (password_textfield.text != password_confirm_textfield.text)
        {
            err_msg = "password does not match the confirm password"
        }
        
        //check email
        if( email_textfield.text == "")
        {
            err_msg = "plz input email"
        }
        if(!Utils.isValidEmail(email_textfield.text!))
        {
            err_msg = "invaild email"
        }
        
        //process
        if( err_msg != "")
        {
            print(err_msg)
            return true
        }
        return false
    }
}