//
//  ArtistChartViewController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 12. 10..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit
import Toucan
import Haneke
import Alamofire

class ArtistChartTableViewController: UITableViewController
{
    var char_type = 1
    var artist_chart:Chart!
    var artist_image_array = NSMutableDictionary()
    var prev_index:Int = -1
    var mixtape_list:Chart = Chart(chart_type: 2)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        artist_chart = CHART_DATA.artist_list
        //load audio chart
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.artist_chart!.getChartLength()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ARTIST_CELL") as! ArtistChartTableViewCell
        
        let cur_user_data = artist_chart?.getUserDataAt(indexPath.row)
        setAristCellData(cell, user_data:cur_user_data!, index:indexPath.row)
        
        return cell
    }
    
    func setAristCellData(_ cell:ArtistChartTableViewCell, user_data:User, index:Int)
    {
        //set artwork image
        let url = URL(string: user_data.profile_url)
        cell.profile_view.hnk_setImageFromURL(url!, placeholder: nil, format: nil, failure: nil) { data in
            //after loading
            //set artwork
            cell.profile_view.image = data
            self.artist_image_array[index] = data
        }
        
        cell.bg_profile_view.hnk_setImageFromURL(URL(string: user_data.thumbnail_url)!, placeholder: nil, format: nil, failure: nil) { data in
            //set artwork bg
            cell.bg_profile_view.image = Toucan(image: data).resizeByCropping(CGSize(width: 1200, height: 136)).image
            
            if cell.overlayed
            {
                return
            }
            
            let overlay = UIView(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height))
            overlay.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            cell.bg_profile_view.addSubview(overlay)
            
            cell.overlayed = true
        }
        
        //set artist
        cell.artist_label.text = user_data.name
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "showArtistView")
        {
            //set data
            let artistInfoViewController = (segue.destination as! ArtistInfoViewController)
            //set audio data
            let user_data = artist_chart?.getUserDataAt(sender as! Int) as! Artist
            artistInfoViewController.artist_data = user_data
            artistInfoViewController.loaded_chart = mixtape_list
            
            //set back button
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Raleway", size: 20)!], for: UIControlState())
            navigationItem.backBarButtonItem = backButton
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //load artist's mixtapes
        HUDController.sharedInstance.show(self.view)
        
        let data:User! = artist_chart.getUserDataAt(indexPath.row)
        var seq = ""
        if let v = data.seq {
            seq = "\(v)"
        }

        Shared.JSONCache.fetch(URL: URL(string: SERVER_URL + "api/mixtape/" + seq)!).onSuccess { JSON in
            HUDController.sharedInstance.dismiss()
            
            let mixtape_list = JSON.array
            var count = 0
            for i in mixtape_list!
            {
                let mixtape = Mixtape()
                mixtape.readFromDictionary(i as! NSDictionary)
                Shared.JSONCache.fetch(URL: URL(string: SERVER_URL + "api/audio/" + mixtape.audio_info)!).onSuccess { AUDIO_INFO in
                    let dict = AUDIO_INFO.dictionary as! NSDictionary
                    mixtape.readAfter(dict)
                    self.mixtape_list.addAudio(mixtape)
                    count+=1
                    if( (mixtape_list?.count)! <= count)
                    {
                        self.performSegue(withIdentifier: "showArtistView", sender: indexPath.row)
                    }
                }
            }
        }
        .onFailure { _ in HUDController.sharedInstance.dismiss() }
        
        
        
    }
}
