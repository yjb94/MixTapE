//
//  SoundCloudLoader.swift
//  BeatRecorder_3
//
//  Created by Camo_u on 2016. 9. 3..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit
import Haneke

let CLIENT_ID = "175c043157ffae2c6d5fed16c3d95a4c"

class SoundCloudLoader: NSObject
{
    static let sharedInstance = SoundCloudLoader()   //singleton
    
    func getStreamLink(_ from_url:String, callback:@escaping (_ link:URL) -> Void) -> Void
    {
        //get track id
        let get_track_request_string = String(format: "https://api.soundcloud.com/resolve.json?url=%@&client_id=%@", from_url, CLIENT_ID)
        
        Shared.JSONCache.fetch(URL: URL(string: get_track_request_string)!).onSuccess { track_json in
//        camoURL.sharedInstance.getJSON(get_track_request_string, callback:
//            { track_json in
                let dict = track_json.dictionary!
                let track_id = (dict["id"] as! NSNumber).stringValue
                let track_url = String(format: "https://api.soundcloud.com/tracks/%@/stream?client_id=%@", track_id, CLIENT_ID)
                let stream_link = URL(string: track_url)!
                callback(stream_link)
            }
//        )
    }
    func downloadStream(_ from_url:String, name_as:String, callback:@escaping (_ path:URL)->Void) -> Void
    {
        let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask , appropriateFor: nil, create: true)
        let destination = documentsUrl.appendingPathComponent(name_as, isDirectory: true)
        if FileManager().fileExists(atPath: destination.path)
        {
            callback(destination)
            print("The file already exists at path")
            return
        }
        
        getStreamLink(from_url, callback:
            { link in
                var downloadTask:URLSessionDownloadTask
                
                downloadTask = URLSession.shared.downloadTask(with: link, completionHandler:
                    { (location:URL?, response:URLResponse?, error:NSError?) -> Void in
                        if error == nil
                        {
                            if(name_as != "")    //if to_url exists
                            {
                                let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask , appropriateFor: nil, create: true)
                                let destination = documentsUrl.appendingPathComponent(name_as, isDirectory: true)
                                if FileManager().fileExists(atPath: destination.path){
                                } else {
                                try! FileManager.default.moveItem(at: location!, to: destination)
                                }
                                callback(destination)
                            }
                            else
                            {
                                callback(location!)
                            }
                        }
                        else
                        {
                            print(error)
                        }
                    } as! (URL?, URLResponse?, Error?) -> Void)
                downloadTask.resume()
            })
    }
    
    func downloadStreamNotSC(_ from_url:String, name_as:String, callback:@escaping (_ path:URL)->Void) -> Void
    {
        let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask , appropriateFor: nil, create: true)
        let destination = documentsUrl.appendingPathComponent(name_as, isDirectory: true)
        if FileManager().fileExists(atPath: destination.path)
        {
            callback(destination)
            print("The file already exists at path")
            return
        }
        
        var downloadTask:URLSessionDownloadTask
                
        downloadTask = URLSession.shared.downloadTask(with: URL(string: from_url)!, completionHandler:
            { (location:URL?, response:URLResponse?, error:NSError?) -> Void in
                if error == nil
                {
                    if(name_as != "")    //if to_url exists
                    {
                        let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask , appropriateFor: nil, create: true)
                        let destination = documentsUrl.appendingPathComponent(name_as, isDirectory: true)
                        if FileManager().fileExists(atPath: destination.path){
                        } else {
                            try! FileManager.default.moveItem(at: location!, to: destination)
                        }
                        callback(destination)
                    }
                    else
                    {
                        callback(location!)
                    }
                }
                else
                {
                    print(error)
                }
        } as! (URL?, URLResponse?, Error?) -> Void)
        downloadTask.resume()
    }
}
