//
//  User.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 12. 10..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit

class User
{
    var seq:Int?
    var name:String!
    var profile_url:String = ""
    var thumbnail_url:String!
    var email:String!
    var password:String!
    
    init()
    {
    }
    
    init(seq:Int, name:String, profile_url:String, thumbnail_url:String, email:String, password:String)
    {
        self.seq = seq
        self.name = name
        self.profile_url = profile_url
        self.thumbnail_url = thumbnail_url
        self.email = email
        self.password = password
    }
    
    func toDictionary() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        dict["seq"] = self.seq! as Int
        dict["name"] = self.name as String
        dict["profile_url"] = self.profile_url as String
        dict["thumbnail_url"] = self.thumbnail_url as String
        dict["email"] = self.email as String
        dict["password"] = self.password as String
        return dict
    }
}

class Artist : User
{
    var aka:String?
    
    var mixtape = [String]()
    var mixtape_cnt:Int = 0
    var follwer_cnt:Int = 0
    var follwings_cnt:Int = 0
    
    var liked_audio = [String]()
    
    override init()
    {
        super.init()
    }
    
    override init(seq:Int, name:String, profile_url:String, thumbnail_url:String, email:String, password:String)
    {
        super.init(seq: seq, name: name, profile_url: profile_url, thumbnail_url: thumbnail_url, email: email, password: password)
    }
    
    override func toDictionary() -> NSMutableDictionary
    {
        let dict = super.toDictionary()
        if self.aka != nil
        {
            dict["aka"] = self.aka! as String
        }
        dict["mixtape_cnt"] = self.mixtape_cnt as Int
        dict["follwer_cnt"] = self.follwer_cnt as Int
        dict["follwings_cnt"] = self.follwings_cnt as Int
        return dict
    }
    
    func readFromDictionary(data_dic:NSDictionary)
    {
        self.seq = data_dic.valueForKey("sequence") as? Int
        
        if let email = data_dic.valueForKey("email") as? String
        {
            self.email = email
        }
        if let password = data_dic.valueForKey("password") as? String
        {
            self.password = password
        }
        if let profile_url = data_dic.valueForKey("profile_url") as? String
        {
            self.profile_url = profile_url
        }
        
        if let thumbnail_url = data_dic.valueForKey("thumbnail_url") as? String
        {
            self.thumbnail_url = thumbnail_url
        }
        
        if let nickname = data_dic.valueForKey("nickname") as? String
        {
            self.name = nickname
        }
        
        
    }
}