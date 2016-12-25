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
    @IBAction func onClose(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: {});
    }
    
    @IBAction func onJoinButtonClicked(_ sender:AnyObject)
    {
        if(!checkJoinError())  //no error
        {
            let params:[String : AnyObject] = [
                "email": email_textfield.text! as AnyObject,
                "password":password_textfield.text! as AnyObject
            ]
            
            Alamofire.request(SERVER_URL+"api/user/", method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                HUDController.sharedInstance.dismiss()
                switch response.result
                {
                case .success:
                    //save json datas
                    if let JSON = response.result.value
                    {
                        let dict:NSMutableDictionary = JSON as! NSMutableDictionary
                        USER_DATA.user = Artist(seq: dict["sequence"] as! Int, name: dict["nickname"]! as! String, profile_url: dict["profile_url"]! as! String, thumbnail_url: dict["thumbnail_url"]! as! String, email: dict["email"]! as! String, password: dict["password"]! as! String)
                        
                        //load music chart, artist chart, beat chart
                        self.performSegue(withIdentifier: "mainTabBarView", sender: self)
                    }
                    
                case .failure( _):
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
