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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class LoginViewController: UIViewController
{
    @IBOutlet weak var join_button: UIButton!
    @IBOutlet weak var email_textfield: UITextField!
    @IBOutlet weak var password_textfield: UITextField!
    @IBOutlet weak var mail_icon: UIImageView!
    
    @IBOutlet weak var forgot_button: UIButton!
    
    override func viewWillAppear(_ animated: Bool)
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
            USER_DATA.auto_login = String(data:data, encoding:String.Encoding.utf8)!
            if(USER_DATA.auto_login == "TRUE")
            {
                cache.fetch(key: USER_DATA.USER_KEY).onSuccess { user_data in
                    
                    let dict = Utils.convertStringToDictionary(String(data:user_data, encoding:String.Encoding.utf8)!)!
                    
                    let user = Artist(seq: dict["sequence"] as! Int, name: dict["nickname"]! as! String, profile_url:dict["profile_url"]! as! String, thumbnail_url: dict["thumbnail_url"]! as! String, email: dict["email"]! as! String, password: dict["password"]! as! String)
                    
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
        forgot_button.isEnabled = false
    }
    
    func completeLoading(_ user:User)
    {
        USER_DATA.user = user
        
        //load music chart
        CHART_DATA.loadMixtape() { i in
            if i >= 3
            {
                HUDController.sharedInstance.dismiss()
                self.performSegue(withIdentifier: "mainTabBarView", sender: self)
            }
        }
        
        //load artist chart
        CHART_DATA.loadArtist() { i in
            if i >= 3
            {
                HUDController.sharedInstance.dismiss()
                self.performSegue(withIdentifier: "mainTabBarView", sender: self)
            }
        }
        
        //load beat chart
        CHART_DATA.loadBeat() { i in
            if i >= 3
            {
                HUDController.sharedInstance.dismiss()
                self.performSegue(withIdentifier: "mainTabBarView", sender: self)
            }
        }

    }
    
    override var prefersStatusBarHidden : Bool
    {
        return true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onForgotPasswordClicked(_ sender: AnyObject)
    {
    }
    @IBAction func onLoginButtonClicked(_ sender:AnyObject)
    {
        if(!checkLoginError())  //no error
        {
            let params:[String : AnyObject] = [
                "email": email_textfield.text! as AnyObject,
                "password":password_textfield.text! as AnyObject
            ]
            HUDController.sharedInstance.show(self.view)
            Alamofire.request(SERVER_URL+"api/login", method: .post, parameters:params , encoding: JSONEncoding.default).responseJSON { response in
                HUDController.sharedInstance.dismiss()
                switch response.result
                {
                case .success:
                    //save json datas
                    if let JSON = response.result.value
                    {
                        HUDController.sharedInstance.show(self.view)
                        let dict:NSMutableDictionary = JSON as! NSMutableDictionary
                        
                        let cache = Shared.dataCache
                        do
                        {
                            try cache.set(value: JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted), key: USER_DATA.USER_KEY)
                        }
                        catch
                        {
                            print("error serializing")
                        }
                        
                        let user = Artist(seq: dict["sequence"] as! Int, name: dict["nickname"]! as! String, profile_url: dict["profile_url"]! as! String, thumbnail_url: dict["thumbnail_url"]! as! String, email: dict["email"]! as! String, password: dict["password"]! as! String)
                        
                        Shared.dataCache.set(value: USER_DATA.auto_login.data(using: String.Encoding.utf8)!, key: USER_DATA.AUTO_LOGIN_KEY)
                        
                        self.completeLoading(user)
                    }
                    
                case .failure( _):
                    print(response.result.description)
                    self.performSegue(withIdentifier: "showJoinView", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "showJoinView")
        {
            let nextViewController = (segue.destination as! JoinViewController)
            nextViewController.email_save = email_textfield.text!
            nextViewController.password_save = password_textfield.text!
        }
    }
}
