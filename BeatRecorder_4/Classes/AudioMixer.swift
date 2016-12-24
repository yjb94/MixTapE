//
//  AudioMixer.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 12. 9..
//  Copyright © 2016년 Camo_u. All rights reserved.
//
import TheAmazingAudioEngine
import UIKit

class AudioMixer
{
    var dynamics = Dynamics()
    var equalizer = Eq()
    var chorus = Chorus()
    var sends = Sends()
}

class Dynamics
{
    var compression:AELimiterFilter? = nil
    var amount:Float = 0.5
    
    func removeFilter()
    {
        
        if compression != nil
        {
            AudioController.sharedInstance.removeFilter(compression!)
            compression = nil
        }
        
    }
    
    func setCompression(amount:Float)
    {
        removeFilter()
        
        self.amount = amount
        compression = AELimiterFilter.init()
        compression?.level = self.amount
        
        AudioController.sharedInstance.applyFilter(compression!)
    }
}

class Eq
{
    var low:AELowPassFilter? = nil
    var high:AEHighPassFilter? = nil
    
    func removeFilter()
    {
        if low != nil
        {
            AudioController.sharedInstance.removeFilter(low!)
            low = nil
        }
        
        if high != nil
        {
            AudioController.sharedInstance.removeFilter(high!)
            high = nil
        }
    }
    
    func setEQ(low_amount:Double=0.0, high_amout:Double=0.0)
    {
        removeFilter()
        
        low = AELowPassFilter.init()
        low?.resonance = low_amount
        
        
        high = AEHighPassFilter.init()
        high?.resonance = high_amout
        
        AudioController.sharedInstance.applyFilter(low!);
        AudioController.sharedInstance.applyFilter(high!);
    }
}

class Chorus
{
    var chorus:AEDelayFilter? = nil
    var amount:Double = 50.0
    
    func removeFilter()
    {
        if chorus != nil
        {
            AudioController.sharedInstance.removeFilter(chorus!)
            chorus = nil
        }
    }
    
    func setChorus(amount:Double)
    {
        self.amount = amount
        
        removeFilter()
        
        chorus = AEDelayFilter.init()
        chorus?.delayTime = self.amount
        
        AudioController.sharedInstance.applyFilter(chorus!)
    }
}

class Sends
{
    var reverb:AEReverbFilter? = nil
    var ambience:Double = 0.0
    var amount:Double = 40.0
    
    func removeFilter()
    {
        if reverb != nil
        {
            AudioController.sharedInstance.removeFilter(reverb!)
            reverb = nil
        }
    }
    
    func setReverb(amount:Double=40.0, ambience:Double=0.0)
    {
        self.amount = amount
        self.ambience = ambience
        
        removeFilter()
        reverb = AEReverbFilter.init()
        reverb?.gain = self.ambience
        reverb?.dryWetMix = self.amount
        
        AudioController.sharedInstance.applyFilter(reverb!)        
    }
}