//
//  CustomSlider.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 11. 29..
//  Copyright © 2016년 Camo_u. All rights reserved.
//
import Toucan
import UIKit

class CustomSlider: UISlider
{
    override func trackRectForBounds(bounds: CGRect) -> CGRect
    {
        //keeps original origin and width, changes height, you get the idea
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 1.0))
        super.trackRectForBounds(customBounds)
        return customBounds
    }
}
