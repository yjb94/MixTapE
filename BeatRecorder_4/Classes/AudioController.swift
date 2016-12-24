//
//  AudioController.swift
//  BeatRecorder_4
//
//  Created by Camo_u on 2016. 11. 12..
//  Copyright © 2016년 Camo_u. All rights reserved.
//

import TheAmazingAudioEngine

class AudioController
{
    static let sharedInstance = AudioController()   //singleton
    
    var audio_controller:AEAudioController!
    
    var audio_playthrough:AEPlaythroughChannel?
    
    var audio_recorder:AERecorder?
    var record_player_list = NSMutableDictionary()
    var record_playtime_list = Dictionary<Int, Double>()
    var record_channel:AEChannelGroupRef?
    
    var audio_data_list = NSMutableDictionary()
    var audio_player_list = NSMutableDictionary()
    var playing = false
    var volume = 0
    
    init()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.audio_controller = appDelegate.audio_controller
        
        record_channel = audio_controller.createChannelGroup()
    }
    
    func playAudioWith(audio:Audio, callback:(key:String)->Void = { _ in })
    {
        if(audio.local_file_path == nil) //저장된게 없음
        {
            //if mixtape
            if let m = audio as? Mixtape
            {
                SoundCloudLoader.sharedInstance.downloadStreamNotSC(m.stream_url, name_as:(m.id + ".mp3"), callback:
                    { path in
                        if self.initAudioPlayerWith(path, key:m.id)
                        {
                            m.local_file_path = path
                            self.audio_data_list[m.id] = m
                            callback(key:m.id)
                        }
                })
            }
            else if let b = audio as? Beat
            {
                //if beat
                SoundCloudLoader.sharedInstance.downloadStream(b.stream_url, name_as:(b.id + ".mp3"), callback:
                    { path in
                        if self.initAudioPlayerWith(path, key:b.id)
                        {
                            b.local_file_path = path
                            self.audio_data_list[b.id] = b
                            callback(key:b.id)
                        }
                })
            }
        }
        else    //저장된게 있으면 그냥 재생
        {
            if !(initAudioPlayerWith(audio.local_file_path, key:audio.id))
            {
                audio.local_file_path = nil
            }
        }
    }
    
    func initAudioPlayerWith(path:NSURL!, key:String) ->Bool
    {
        do
        {
            let audio_player = try AEAudioFilePlayer(URL:path)
            audio_player.volume = 1.0
            audio_player_list[key] = audio_player
            
            self.audio_controller.addChannels([audio_player])
            return true;
        }
        catch
        {
            print("error initializing audio player")
        }
        return false;
    }
    func play(tf:Bool, key:String)
    {
        if audio_player_list[key] != nil
        {
            (self.audio_player_list[key] as! AEAudioFilePlayer).channelIsPlaying = tf
        }
    }
    
    func playPause(key:String) -> Bool
    {
        if audio_player_list[key] == nil
        {
            return false
        }
        
        if(audio_player_list.count >= 0)
        {
            (self.audio_player_list[key] as! AEAudioFilePlayer).channelIsPlaying = !((self.audio_player_list[key] as! AEAudioFilePlayer).channelIsPlaying)
        }
        else
        {
            print("error play pausing file at index")
        }
        return (self.audio_player_list[key] as! AEAudioFilePlayer).channelIsPlaying
    }
    
    func isPlaying(key:String) -> Bool
    {
        if(audio_player_list.count == 0)
        {
            return false
        }
        if audio_player_list[key] != nil
        {
            return (self.audio_player_list[key] as! AEAudioFilePlayer).channelIsPlaying
        }
        return false
    }
    
    func stopAudio(key:String)
    {
        //정지
        if audio_player_list[key] != nil
        {
            audio_controller.removeChannels([audio_player_list[key]!])
            audio_player_list[key] = nil
            audio_player_list.removeObjectForKey(key)
        }
    }
    func audioAtTime(time:NSTimeInterval, key:String)
    {
        if audio_player_list[key] != nil
        {
            (self.audio_player_list[key] as! AEAudioFilePlayer).currentTime = time
        }
    }
    func getAudioCurrentTime(key:String) -> NSTimeInterval
    {
        if audio_player_list[key] != nil
        {
            return (self.audio_player_list[key] as! AEAudioFilePlayer).currentTime
        }
        return 0
    }
    func getPlaybackTime(key:String) -> Float
    {
        if audio_player_list[key] != nil
        {
            let normalize_time = Float((self.audio_player_list[key] as! AEAudioFilePlayer).currentTime / (self.audio_player_list[key] as! AEAudioFilePlayer).duration)
            return normalize_time
        }
        return 0
    }
    func getAudioData(key:String) -> Audio?
    {
        if audio_data_list[key] != nil
        {
            return audio_data_list[key] as? Audio
        }
        return nil
    }
    func getAudioDuration(key:String) -> NSTimeInterval
    {
        if audio_player_list[key] != nil
        {
            return (self.audio_player_list[key] as! AEAudioFilePlayer).duration
        }
        return 0
    }
    func addPlaythrough()
    {
        if record_channel == nil
        {
            record_channel = audio_controller.createChannelGroup()
        }
        
        self.audio_playthrough = AEPlaythroughChannel.init()
        self.audio_playthrough!.volume = 2;
        self.audio_controller.addInputReceiver(self.audio_playthrough)
        self.audio_controller.addChannels([self.audio_playthrough!], toChannelGroup: record_channel!)
    }
    
    func removePlaythrough()
    {
        if self.audio_playthrough == nil
        {
            return
        }
        if record_channel == nil
        {
            print("no record channel")
            return
        }
        
        self.audio_controller.removeInputReceiver(self.audio_playthrough)
        self.audio_controller.removeChannels([self.audio_playthrough!], fromChannelGroup: record_channel!)
        audio_playthrough = nil
    }
    
    func applyFilter(filter:AEAudioFilter)
    {
        if record_channel == nil
        {
            print("no record channel")
            return
        }
        
        audio_controller.addFilter(filter, toChannelGroup: record_channel!)
    }
    
    func removeFilter(filter:AEAudioFilter)
    {
        if record_channel == nil
        {
            print("no record channel")
            return
        }
            
        audio_controller.removeFilter(filter, fromChannelGroup: record_channel!)
    }
    
    func startRecord(index:Int, key:String)
    {
        if isRecording()
        {
            print("recording already in process")
            return;
        }
        
        do
        {
            audio_recorder = AERecorder.init(audioController: audio_controller)
            
            let documentsUrl = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask , appropriateForURL: nil, create: true)
            let destination = documentsUrl.URLByAppendingPathComponent("recordings" + String(index) + ".m4a", isDirectory: true)
            let url = destination.path
            
            //check file path valid
            
            try audio_recorder?.beginRecordingToFileAtPath(url, fileType: kAudioFileM4AType)
            record_playtime_list[index] = getAudioCurrentTime(key)
            print(AECurrentTimeInHostTicks())
            audio_controller.addInputReceiver(audio_recorder)
            audio_controller.addOutputReceiver(audio_recorder)
        }
        catch
        {
            audio_recorder = nil;
            print("error initializing recorder")
        }
    }
    
    func stopRecord()
    {
        if isRecording()
        {
            audio_recorder?.finishRecording()
            audio_controller.removeInputReceiver(audio_recorder)
            audio_controller.removeOutputReceiver(audio_recorder)
            audio_recorder = nil
        }
    }
    func stopRecordPlaying()
    {
        if (record_channel != nil)
        {
            audio_controller.removeChannelGroup(record_channel!)
            record_channel = nil
        }
    }
    
    func isRecording() -> Bool
    {
        if(audio_recorder != nil)
        {
            return (audio_recorder?.recording)!
        }
        return false
    }
    
    func playRecording(index:Int)
    {
        if !isRecording()
        {
            let documentsUrl = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask , appropriateForURL: nil, create: true)
            let destination = documentsUrl.URLByAppendingPathComponent("recordings" + String(index) + ".m4a", isDirectory: true)
            let url = destination.path
            
            if !NSFileManager().fileExistsAtPath(url!)
            {
                print("no file")
                return
            }
            
            do
            {
                let record_player = try AEAudioFilePlayer(URL:destination)
                record_player.volume = 1.0
                record_player.removeUponFinish = true
                
                if record_player_list[index] != nil
                {
                    record_player.playAtTime(AECurrentTimeInHostTicks())
                }
                self.audio_controller.addChannels([record_player], toChannelGroup: record_channel!)
                
                self.audio_player_list[index] = record_player
            }
            catch
            {
                print("error initialize record player")
                return
            }
        }
    }
}










