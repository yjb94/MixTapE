//
//  camoURL.swift
//  BeatRecorder_3
//
//  Created by Camo_u on 2016. 9. 3..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit

class camoURL: NSObject
{
    static let sharedInstance = camoURL()   //singleton

    func getJSON(url:String, callback:(json_data:NSDictionary) -> Void) -> Void
    {
        let requestURL: NSURL = NSURL(string:url)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200)  // successful download
            {
                do
                {   
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    callback(json_data: json as! NSDictionary);
                    
                }catch
                {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func getDataFromURL(url:NSURL, callback: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void))
    {
        NSURLSession.sharedSession().dataTaskWithURL(url)
        {
            (data, response, error) in
            callback(data: data, response: response, error: error)
        }.resume()
    }
    
    func postRequest(url:String, params:[String], callback:((json_data:NSDictionary)->Void))
    {
        callback(json_data:[:])
    }
    
    func getImageFromURL(url:String, callback:((data:NSData?)->Void))
    {
        let url = NSURL(string: url)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            dispatch_async(dispatch_get_main_queue(), {
                callback(data: data)
            });
        }
    }
}
