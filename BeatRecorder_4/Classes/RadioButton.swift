//
//  RadioButton.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 12. 2..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import UIKit

class RadioButton: UIButton
{
    var alternateButton:Array<RadioButton>?
    
    override func awakeFromNib()
    {
        self.layer.cornerRadius = 1
        self.layer.borderWidth = 0.4
        self.layer.borderColor = UIColor.init(netHex: 0x00b2b2).CGColor
        self.layer.masksToBounds = true
        
        self.setTitleColor(UIColor.init(netHex: 0x00b2b2), forState: .Selected)
    }
    
    func unselectAlternateButtons()
    {
        if alternateButton != nil
        {
            for aButton:RadioButton in alternateButton!
            {
                aButton.selected = false
            }
        }
        else
        {
            toggleButton()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        unselectAlternateButtons()
        toggleButton()
        super.touchesBegan(touches, withEvent: event)
    }
    
    func toggleButton()
    {
        self.selected = !selected
    }
    
    override var selected: Bool
    {
        didSet {
            if selected
            {
                self.backgroundColor = UIColor.init(white: 1, alpha: 0.2)
            }
            else
            {
                self.backgroundColor = UIColor.clearColor()
            }
        }
    }
}