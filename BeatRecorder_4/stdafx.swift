//
//  stdafx.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 9. 27..
//  Copyright © 2016년 Camo_u. All rights reserved.
//
import UIKit
import Alamofire
import Haneke

//const
let MIN_PASSWORD_LEN = 8
let SERVER_URL = "http://163.180.117.199:8000/"

struct USER_DATA
{
    static var user:User = Artist()
    static let USER_KEY = "2"
    
    static var auto_login:String = "TRUE"
    static let AUTO_LOGIN_KEY = "1"
}

class CHART_DATA
{
    static var setted_cnt:Int = 0;
    static var beat_list:Chart = Chart(chart_type: 0)
    static var artist_list:Chart = Chart(chart_type: 1)
    static var mixtape_list:Chart = Chart(chart_type: 2)
    
    class func loadMixtape(callback:(setted_cnt:Int)->Void)
    {
        Shared.JSONCache.fetch(URL: NSURL(string: SERVER_URL + "api/mixtape")!).onSuccess { JSON in
            let mixtape_list = JSON.array
            for i in mixtape_list
            {
                let mixtape = Mixtape()
                mixtape.readFromDictionary(i as! NSDictionary)
                Shared.JSONCache.fetch(URL: NSURL(string: SERVER_URL + "api/audio/" + mixtape.audio_info)!).onSuccess { AUDIO_INFO in
                    let dict = AUDIO_INFO.dictionary
                    mixtape.readAfter(dict)
                    self.mixtape_list.addAudio(mixtape)
                }
            }
            
            setted_cnt += 1
            callback(setted_cnt: setted_cnt)
        }
    }
    
    class func loadBeat(callback:(setted_cnt:Int)->Void)
    {
        Shared.JSONCache.fetch(URL: NSURL(string: SERVER_URL + "api/beat")!).onSuccess { JSON in
            let beat_list = JSON.array
            for i in beat_list
            {
                let dict:NSDictionary = i as! NSDictionary
                let beat = Beat()
                beat.readFromDictionary(dict)
                self.beat_list.addAudio(beat)
            }
            
            setted_cnt += 1
            callback(setted_cnt: setted_cnt)
        }
    }
    class func loadArtist(callback:(setted_cnt:Int)->Void)
    {
        Shared.JSONCache.fetch(URL: NSURL(string: SERVER_URL + "api/user/?all=1")!).onSuccess { JSON in
            let artist_list = JSON.array
            for i in artist_list
            {
                let dict:NSDictionary = i as! NSDictionary
                let artist = Artist()
                artist.readFromDictionary(dict)
                self.artist_list.addUser(artist)
            }
            
            setted_cnt += 1
            callback(setted_cnt: setted_cnt)
        }
    }
}

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int)
    {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}