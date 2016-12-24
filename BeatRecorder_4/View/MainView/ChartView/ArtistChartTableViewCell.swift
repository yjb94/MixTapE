//
//  ArtistChartTableViewCell.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 12. 10..
//  Copyright © 2016년 Camo_u. All rights reserved.
//
import UIKit

class ArtistChartTableViewCell: UITableViewCell
{
    @IBOutlet weak var profile_view: UIImageView!
    @IBOutlet weak var bg_profile_view: UIImageView!
    @IBOutlet weak var artist_label: UILabel!
    
    var overlayed:Bool = false
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}