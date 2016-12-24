//
//  SoundCloudLoader.swift
//  BeatRecorder_3
//
//  Created by Camo_u on 2016. 9. 3..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit

let CLIENT_ID = "175c043157ffae2c6d5fed16c3d95a4c"

class SoundCloudLoader: NSObject
{
    static let sharedInstance = SoundCloudLoader()   //singleton
    
    func getStreamLink(from_url:String, callback:(link:NSURL) -> Void) -> Void
    {
        //get track id
        let get_track_request_string = String(format: "https://api.soundcloud.com/resolve.json?url=%@&client_id=%@", from_url, CLIENT_ID)
        
        camoURL.sharedInstance.getJSON(get_track_request_string, callback:
            { track_json in
                let track_id = (track_json.valueForKey("id") as! NSNumber).stringValue
                let track_url = String(format: "https://api.soundcloud.com/tracks/%@/stream?client_id=%@", track_id, CLIENT_ID)
                let stream_link = NSURL(string: track_url)!
                callback(link:stream_link)
            })
    }
    func downloadStream(from_url:String, name_as:String, callback:(path:NSURL)->Void) -> Void
    {
        let documentsUrl = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask , appropriateForURL: nil, create: true)
        let destination = documentsUrl.URLByAppendingPathComponent(name_as, isDirectory: true)
        if NSFileManager().fileExistsAtPath(destination.path!)
        {
            callback(path: destination)
            print("The file already exists at path")
            return
        }
        
        getStreamLink(from_url, callback:
            { link in
                var downloadTask:NSURLSessionDownloadTask
                
                downloadTask = NSURLSession.sharedSession().downloadTaskWithURL(link, completionHandler:
                    { (location:NSURL?, response:NSURLResponse?, error:NSError?) -> Void in
                        if error == nil
                        {
                            if(name_as != "")    //if to_url exists
                            {
                                let documentsUrl = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask , appropriateForURL: nil, create: true)
                                let destination = documentsUrl.URLByAppendingPathComponent(name_as, isDirectory: true)
                                if NSFileManager().fileExistsAtPath(destination.path!){
                                } else {
                                try! NSFileManager.defaultManager().moveItemAtURL(location!, toURL: destination)
                                }
                                callback(path: destination)
                            }
                            else
                            {
                                callback(path: location!)
                            }
                        }
                        else
                        {
                            print(error)
                        }
                    })
                downloadTask.resume()
            })
    }
    
    func downloadStreamNotSC(from_url:String, name_as:String, callback:(path:NSURL)->Void) -> Void
    {
        let documentsUrl = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask , appropriateForURL: nil, create: true)
        let destination = documentsUrl.URLByAppendingPathComponent(name_as, isDirectory: true)
        if NSFileManager().fileExistsAtPath(destination.path!)
        {
            callback(path: destination)
            print("The file already exists at path")
            return
        }
        
        var downloadTask:NSURLSessionDownloadTask
                
        downloadTask = NSURLSession.sharedSession().downloadTaskWithURL(NSURL(string: from_url)!, completionHandler:
            { (location:NSURL?, response:NSURLResponse?, error:NSError?) -> Void in
                if error == nil
                {
                    if(name_as != "")    //if to_url exists
                    {
                        let documentsUrl = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask , appropriateForURL: nil, create: true)
                        let destination = documentsUrl.URLByAppendingPathComponent(name_as, isDirectory: true)
                        if NSFileManager().fileExistsAtPath(destination.path!){
                        } else {
                            try! NSFileManager.defaultManager().moveItemAtURL(location!, toURL: destination)
                        }
                        callback(path: destination)
                    }
                    else
                    {
                        callback(path: location!)
                    }
                }
                else
                {
                    print(error)
                }
        })
        downloadTask.resume()
    }
}
