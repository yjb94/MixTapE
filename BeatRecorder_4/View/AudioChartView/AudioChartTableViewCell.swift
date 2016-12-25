//
//  AudioChartTableViewCell.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 11. 23..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit

class AudioChartTableViewCell: UITableViewCell
{
    @IBOutlet weak var artwork_view: UIImageView!
    @IBOutlet weak var bg_artwork_view: UIImageView!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var artist_label: UILabel!
    @IBOutlet weak var play_button: UIButton!
    @IBOutlet weak var like_label: UILabel!
    
    var overlayed:Bool = false
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
