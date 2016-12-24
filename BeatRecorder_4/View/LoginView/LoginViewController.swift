//
//  ViewController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 9. 26..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class LoginViewController: UIViewController
{
    @IBOutlet weak var join_button: UIButton!
    @IBOutlet weak var email_textfield: UITextField!
    @IBOutlet weak var password_textfield: UITextField!
    @IBOutlet weak var mail_icon: UIImageView!
    
    @IBOutlet weak var forgot_button: UIButton!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //auto login
        HUDController.sharedInstance.show(view)
        let cache = Shared.dataCache
        cache.fetch(key: USER_DATA.AUTO_LOGIN_KEY).onSuccess { data in
            USER_DATA.auto_login = String(data:data, encoding:NSUTF8StringEncoding)!
            if(USER_DATA.auto_login == "TRUE")
            {
                cache.fetch(key: USER_DATA.USER_KEY).onSuccess { user_data in
                    
                    let dict = Utils.convertStringToDictionary(String(data:user_data, encoding:NSUTF8StringEncoding)!)!
                    
                    let user = Artist(seq: dict["sequence"] as! Int, name: String(dict["nickname"]!), profile_url: String(dict["profile_url"]!), thumbnail_url: String(dict["thumbnail_url"]!), email: String(dict["email"]!), password: String(dict["password"]!))
                    
                    self.completeLoading(user)
                }
            }
            HUDController.sharedInstance.dismiss()
        }
        .onFailure
        {err in
            print(err.debugDescription)
            HUDController.sharedInstance.dismiss()
        }
        forgot_button.enabled = false
    }
    
    func completeLoading(user:User)
    {
        USER_DATA.user = user
        
        //load music chart
        CHART_DATA.loadMixtape() { i in
            if i >= 3
            {
                HUDController.sharedInstance.dismiss()
                self.performSegueWithIdentifier("mainTabBarView", sender: self)
            }
        }
        
        //load artist chart
        CHART_DATA.loadArtist() { i in
            if i >= 3
            {
                HUDController.sharedInstance.dismiss()
                self.performSegueWithIdentifier("mainTabBarView", sender: self)
            }
        }
        
        //load beat chart
        CHART_DATA.loadBeat() { i in
            if i >= 3
            {
                HUDController.sharedInstance.dismiss()
                self.performSegueWithIdentifier("mainTabBarView", sender: self)
            }
        }

    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onForgotPasswordClicked(sender: AnyObject)
    {
    }
    @IBAction func onLoginButtonClicked(sender:AnyObject)
    {
        if(!checkLoginError())  //no error
        {
            let params:[String : AnyObject] = [
                "email": email_textfield.text!,
                "password":password_textfield.text!
            ]
            HUDController.sharedInstance.show(self.view)
            Alamofire.request(.POST, SERVER_URL+"api/login", parameters:params , encoding: ParameterEncoding.JSON).responseJSON { response in
                HUDController.sharedInstance.dismiss()
                switch response.result
                {
                case .Success:
                    //save json datas
                    if let JSON = response.result.value
                    {
                        HUDController.sharedInstance.show(self.view)
                        let dict:NSMutableDictionary = JSON as! NSMutableDictionary
                        
                        let cache = Shared.dataCache
                        do
                        {
                            try cache.set(value: NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted), key: USER_DATA.USER_KEY)
                        }
                        catch
                        {
                            print("error serializing")
                        }
                        
                        let user = Artist(seq: dict["sequence"] as! Int, name: String(dict["nickname"]!), profile_url: String(dict["profile_url"]!), thumbnail_url: String(dict["thumbnail_url"]!), email: String(dict["email"]!), password: String(dict["password"]!))
                        
                        Shared.dataCache.set(value: USER_DATA.auto_login.dataUsingEncoding(NSUTF8StringEncoding)!, key: USER_DATA.AUTO_LOGIN_KEY)
                        
                        self.completeLoading(user)
                    }
                    
                case .Failure( _):
                    print(response.result.description)
                    self.performSegueWithIdentifier("showJoinView", sender: self)
                }
            }
        }
    }
    
    func checkLoginError() ->Bool
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
//        if (password_textfield.text?.characters.count < MIN_PASSWORD_LEN)
//        {
//            err_msg = "password must be longer than 8"
//        }
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "showJoinView")
        {
            let nextViewController = (segue.destinationViewController as! JoinViewController)
            nextViewController.email_save = email_textfield.text!
            nextViewController.password_save = password_textfield.text!
        }
    }
}