//
//  Audio.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 11. 12..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit
import Haneke

class Audio
{
    var seq = ""
    var id = ""
    var title = ""
    var artist = ""
    var stream_url = ""
    var artwork_url = ""
    var waveform_url = ""
    
    var local_file_path:URL?
    var description = ""
    var like_cnt = 0;
    var play_cnt = 0;
    var rest_url = ""
    
    func toDictionary() -> NSMutableDictionary
    {
        let dict = NSMutableDictionary()
        dict["id"] = self.id as String
        dict["title"] = self.title as String
        dict["artist"] = self.artist as String
        dict["stream_url"] = self.stream_url as String
        dict["artwork_url"] = self.artwork_url as String
        dict["waveform_url"] = self.waveform_url as String
        dict["local_file_path"] = "\(self.local_file_path)"
        dict["description"] = self.description as String
        dict["like_cnt"] = String(self.like_cnt)
        dict["play_cnt"] = String(self.play_cnt)
        dict["rest_url"] = self.rest_url as String
        return dict
    }
}

class Beat : Audio
{
    var used_cnt = 0;
    
    func readFromDictionary(_ data_dic:NSDictionary)
    {
        self.seq = ((data_dic.value(forKey: "sequence") as? NSNumber)?.stringValue)!
        
        if let id = (data_dic.value(forKey: "id") as? NSNumber)?.stringValue
        {
            self.id = id
        }
        
        if let local_file_path = data_dic.value(forKey: "local_file_path") as? String
        {
            self.local_file_path = URL(string: local_file_path)
        }
        
        if let user_data = data_dic.value(forKey: "audio_info")
        {
            if let title = (user_data as AnyObject).value(forKey: "title") as? String
            {
                self.title = title
            }
            
            if let artist = (user_data as AnyObject).value(forKey: "artist") as? String
            {
                self.artist = artist
            }
            if let waveform_url = (user_data as AnyObject).value(forKey: "waveform_url") as? String
            {
                self.waveform_url = waveform_url
            }
            
            if let stream_url = (user_data as AnyObject).value(forKey: "stream_url") as? String
            {
                self.stream_url = stream_url
            }
            
            if let like_cnt = (user_data as AnyObject).value(forKey: "like_cnt") as? String
            {
                self.like_cnt = Int(like_cnt)!
            }
            
            if let play_cnt = (user_data as AnyObject).value(forKey: "play_cnt") as? String
            {
                self.play_cnt = Int(play_cnt)!
            }
            
            if let description = (user_data as AnyObject).value(forKey: "description") as? String
            {
                self.description = description
            }
            
            if let artwork_url = (user_data as AnyObject).value(forKey: "artwork_url") as? String
            {
                self.artwork_url = artwork_url.replacingOccurrences(of: "large", with: "t500x500")
            }
            
            if(self.artwork_url == "")
            {
                if let avatar_url = (user_data as AnyObject).value(forKey: "avatar_url") as? String
                {
                    self.artwork_url = avatar_url
                }
            }
            
        }
        
        if let rest_url = data_dic.value(forKey: "rest_url") as? String
        {
            self.rest_url = rest_url
        }
    }

}

class Mixtape : Audio
{
    var audio_info = ""
    var beat:Audio?
    var voice:Audio?
    var mixing_info = ""
    var lyrics = ""
    
    func readFromDictionary(_ data_dic:NSDictionary)
    {
        self.seq = ((data_dic.value(forKey: "sequence") as? NSNumber)?.stringValue)!
        
        if let id = (data_dic.value(forKey: "id") as? NSNumber)?.stringValue
        {
            self.id = id
        }
        
        if let lyrics = data_dic.value(forKey: "lyrics") as? String
        {
            self.lyrics = lyrics
        }

        if let local_file_path = data_dic.value(forKey: "local_file_path") as? String
        {
            self.local_file_path = URL(string: local_file_path)
        }
        
        if let audio_info = (data_dic.value(forKey: "audio_info") as? NSNumber)?.stringValue
        {
            self.audio_info = audio_info
        }
    }
    
    func readAfter(_ data_dic:NSDictionary)
    {
        
        if let stream_url = data_dic.value(forKey: "stream_url") as? String
        {
            self.stream_url = stream_url
        }
        
        if let like_cnt = data_dic.value(forKey: "like_cnt") as? String
        {
            self.like_cnt = Int(like_cnt)!
        }
        
        if let description = data_dic.value(forKey: "description") as? String
        {
            self.description = description
        }
        
        if let artwork_url = data_dic.value(forKey: "artwork_url") as? String
        {
            self.artwork_url = artwork_url.replacingOccurrences(of: "large", with: "t500x500")
        }
        
        if let artist = data_dic.value(forKey: "artist") as? String
        {
            self.artist = artist
        }
        
        if let title = data_dic.value(forKey: "title") as? String
        {
            self.title = title
        }
        
        if let waveform_url = data_dic.value(forKey: "waveform_url") as? String
        {
            self.waveform_url = waveform_url
        }
    }
};
