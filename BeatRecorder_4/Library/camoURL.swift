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

//    func getJSON(_ url:String, callback:@escaping (_ json_data:NSDictionary) -> Void) -> Void
//    {
//        let requestURL: URL = URL(string:url)!
//        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
//        let session = URLSession.shared
//        let task = session.dataTask(with: urlRequest, completionHandler: {
//            (data, response, error) -> Void in
//            
//            let httpResponse = response as! HTTPURLResponse
//            let statusCode = httpResponse.statusCode
//            
//            if (statusCode == 200)  // successful download
//            {
//                do
//                {   
//                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
//                    callback(json_data: json as! NSDictionary);
//                    
//                }catch
//                {
//                    print("Error with Json: \(error)")
//                }
//            }
//        }) 
//        task.resume()
//    }
    
//    func getDataFromURL(_ url:URL, callback: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: NSError? ) -> Void))
//    {
//        URLSession.shared.dataTask(with: url, completionHandler: {
//            (data, response, error) in
//            callback(data, response, error)
//        })        
//.resume()
//    }
    
    func postRequest(_ url:String, params:[String], callback:((_ json_data:NSDictionary)->Void))
    {
        callback([:])
    }
    
    func getImageFromURL(_ url:String, callback:@escaping ((_ data:Data?)->Void))
    {
        let url = URL(string: url)
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
        {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            DispatchQueue.main.async(execute: {
                callback(data)
            });
        }
    }
}
