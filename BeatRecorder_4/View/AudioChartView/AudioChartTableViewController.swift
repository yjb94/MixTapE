//
//  AudioChartTableViewController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 11. 23..
//  Copyright © 2016년 Camo_u. All rights reserved.
//
import UIKit
import TheAmazingAudioEngine
import AVFoundation
import Toucan
import Haneke

class AudioChartTableViewController: UITableViewController, UISearchBarDelegate
{
    var delegate:AudioChartContainerDelegateProtocol?
    
    var chart_type:Int?
    var audio_chart:Chart!
    var audio_image_array = NSMutableDictionary()
    var prev_index:Int = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //load audio chart
        audio_chart = (delegate?.getAudioChart())!
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.audio_chart.getChartLength()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("AUDIO_CELL") as! AudioChartTableViewCell
        
        let cur_audio_data = audio_chart.getAudioDataAt(indexPath.row)
        setAudioCellData(cell, audio_data:cur_audio_data, index:indexPath.row)
        
        return cell
    }
    
    func setAudioCellData(cell:AudioChartTableViewCell, audio_data:Audio, index:Int)
    {
        //set artwork image
        let url = NSURL(string: audio_data.artwork_url)
        cell.artwork_view.hnk_setImageFromURL(url!, placeholder: nil, format: nil, failure: nil) { data in
            //after loading
            //set artwork
            cell.artwork_view.image = data
            self.audio_image_array[index] = data
            
            //set artwork bg
            cell.bg_artwork_view.image =  Toucan(image:data).resize(CGSize(width: 600, height: 136), fitMode: Toucan.Resize.FitMode.Crop).image
            
            if cell.overlayed
            {
                return
            }
            
            let overlay = UIView(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height))
            overlay.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            cell.bg_artwork_view.addSubview(overlay)
            
            cell.overlayed = true
        }
        
        //set title
        cell.title_label.text = audio_data.title
        
        //set artist
        cell.artist_label.text = audio_data.artist
        
        //set likes
        cell.like_label.text = String(audio_data.like_cnt) + " likes"
        
        //set play button data
        cell.play_button.tag = index
    }
    
    @IBAction func onPlayButton(sender: UIButton)
    {
        let audio_index = sender.tag
        if(delegate?.isPlaying() == true && (prev_index == audio_index))
        {
            return
        }
        let audio_data = audio_chart.getAudioDataAt(audio_index)
        
        prev_index = audio_index
            
        //play audio with mini audio view
        delegate?.appearAnimated()
        delegate?.playAudioWith(audio_data)
        
        //send audio data
        delegate?.setViewAudioDatas(audio_data, chart_type: self.chart_type!)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "showAudioDetailView")
        {
            //set data
            let audioDetailViewController = (segue.destinationViewController as! AudioDetailViewController)
            //set audio data
            let audio_data = audio_chart.getAudioDataAt(sender as! Int)
            audioDetailViewController.audio_data = audio_data
            audioDetailViewController.audio_key = (delegate?.getAudioKey())!
            audioDetailViewController.chart_type = chart_type
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let audio_data = audio_chart.getAudioDataAt(indexPath.row)
        
        if audio_data.id != delegate?.getAudioKey()
        {
            delegate?.playAudioWith(audio_data)
        }
        performSegueWithIdentifier("showAudioDetailView", sender: indexPath.row)
    }
    
    func reloadData()
    {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}
