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
        self.layer.borderColor = UIColor.init(netHex: 0x00b2b2).cgColor
        self.layer.masksToBounds = true
        
        self.setTitleColor(UIColor.init(netHex: 0x00b2b2), for: .selected)
    }
    
    func unselectAlternateButtons()
    {
        if alternateButton != nil
        {
            for aButton:RadioButton in alternateButton!
            {
                aButton.isSelected = false
            }
        }
        else
        {
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        unselectAlternateButtons()
        toggleButton()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton()
    {
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool
    {
        didSet {
            if isSelected
            {
                self.backgroundColor = UIColor.init(white: 1, alpha: 0.2)
            }
            else
            {
                self.backgroundColor = UIColor.clear
            }
        }
    }
}
