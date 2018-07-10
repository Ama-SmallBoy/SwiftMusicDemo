//
//  PlayManage.swift
//  SwiftMusicDemo
//
//  Created by mac on 2018/7/8.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

import AVFoundation

protocol  PlayManagerDelegate{
    
    func playMusicManagerFetchCurrentTime(Currentime:String,totalTime:String,progress:CGFloat) -> Void;
    
    func playMusicManagerEnd() -> Void;
}

class PlayManager: NSObject{
    
  internal  static let playManger:PlayManager = PlayManager();
    
    var player:AVPlayer? = nil
    
    var delegate:PlayManagerDelegate?
    
    var time:Timer? = nil
    
    var arrayLyricModel:NSMutableArray = NSMutableArray();
    
    
    private var myContext = 0
    
    func initPlayer(musicUrl:String) -> Void {
        
        let playItem:AVPlayerItem =  AVPlayerItem(url: URL(fileURLWithPath:musicUrl))
        
        PlayManager.playManger.player = AVPlayer(playerItem:playItem)
    
//        if ((PlayManager.playManger.player?.currentItem ) != nil) {
//
//            PlayManager.playManger.player?.currentItem?.removeObserver(self, forKeyPath:"status", context: &PlayManager.playManger.myContext)
//
//        }
//
         playItem.addObserver(self, forKeyPath:"status", options: NSKeyValueObservingOptions.new, context:&PlayManager.playManger.myContext);
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(playEnd), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil);
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &myContext {
            
            if let newValue:Int = change?[NSKeyValueChangeKey.newKey] as? Int {
             
                //得到的属性的改变：
        
                switch (newValue) {
        
                    case AVPlayerItemStatus.unknown.rawValue:
                        
                        print("未知错误");
            
                        break;
            
                    case AVPlayerItemStatus.readyToPlay.rawValue:
            
                         print("准备播放");
                         
                         //调用播放的方法：
                         self.playMusic();
            
                        break;
            
                    case AVPlayerItemStatus.failed.rawValue:
            
                       print("播放失败");
                       
                        break;
            
                    default:
                        break;
                    }
         
               }
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }



    //播放进度显示：
    @objc func progressAction() -> Void {
        
      self.delegate?.playMusicManagerFetchCurrentTime(Currentime:self.changeSecondsToTime(second: self.fetchCurrentTimeValue()), totalTime: self.changeSecondsToTime(second: self.fetchTotalTimeValue()), progress: self.fectProgressValue())
    }
    
    //获取当前的时间：
    func fetchCurrentTimeValue() -> NSInteger {
        
        let timeCMT:CMTime = (self.player?.currentTime())!;
        
        if timeCMT.timescale == 0 {
            return 0;
        }
        
        let tmpString:NSNumber = NSNumber.init(value: timeCMT.timescale)
    
        return NSInteger(timeCMT.value / tmpString.int64Value);
    }
    
    //获取总时间；
    func fetchTotalTimeValue() -> NSInteger {
        
        let timeCMT:CMTime = (self.player?.currentItem!.duration)!;
        
        if timeCMT.timescale == 0 {
            return 0;
        }
        
        let tmpString:NSNumber = NSNumber.init(value: timeCMT.timescale)
        
        return NSInteger(timeCMT.value / tmpString.int64Value);
    }
    
    
    //获取播放进度
    
    func fectProgressValue() -> CGFloat {
    
        if self.fetchTotalTimeValue()==0 {
            
            return 0.0;
        }
        
        return CGFloat(self.fetchCurrentTimeValue())  / CGFloat(self.fetchTotalTimeValue());
    }
    
    //将时间转化为字符串：
    func changeSecondsToTime(second:NSInteger) -> String {
        
         return  String.init(format:"%.2ld:%.2ld",second / 60, second % 60)    //[NSString  stringWithFormat:@"%.2ld:%.2ld", second / 60, second % 60];
        
    }
    
    //开启时间控制：
    func startTimer() -> Void {
    
        if self.time != nil {
            
            return;
        }
        
        self.time = Timer.scheduledTimer(timeInterval: 0.001, target:self, selector: #selector(progressAction), userInfo: nil, repeats: true)
        
    }
    //关闭控制器
    func stopTimer() -> Void {
        
        self.time?.invalidate();
        
        self.time = nil;
        
    }

    //MARK: 播放的方法：
    
    //播放
    func playMusic() ->Void {
        
        PlayManager.playManger.player?.play();
        
        self.startTimer();
    
    }
    
    //暂停
    func pauseMusic() ->Void {
        
        PlayManager.playManger.player?.pause();
        self.stopTimer();
    }
    //播放结束：
    @objc func playEnd() -> Void {
        // 改变播放的状态：
        self.stopTimer();
    }
    //执行滑竿的控制歌曲的进度的方法
    func byCurrentTimeWithProgress(progress:CGFloat) -> Void {
        self.pauseMusic();
        self.player?.seek(to: CMTimeMake(Int64(progress * CGFloat(self.fetchTotalTimeValue())), 1), completionHandler: { (finished) in
    
            if finished{
               self.playMusic();
            }
        })
    }
    //拆分歌词：
    func fetchLyricSectionWithLyricString(lyricStr:String) -> NSMutableArray {
        
        self.arrayLyricModel.removeAllObjects();
        
        let tmpArr:Array<String> = lyricStr.components(separatedBy: "\r\r\n") as Array;
        
        for contentString in tmpArr {
            
            let arrTmp:Array<String> = contentString.components(separatedBy: "]");
            
            let lyricModel:LyricModel = LyricModel();
            
            lyricModel.lyricString = arrTmp.last! as NSString;
            
            let tmpFirstString:NSString = arrTmp.first! as NSString
            
            if tmpFirstString.length > 1 {
                
                let arrayTime:Array<String> = tmpFirstString.components(separatedBy: "[");
                
                let timeStr:String = arrayTime.last!;
                
                let timeArray:Array<String> = timeStr.components(separatedBy: ".");
                
                lyricModel.lyricTime = timeArray.first! as NSString;
                
                
            }
            self.arrayLyricModel.add(lyricModel);
            
        }
        return self.arrayLyricModel;
    }
    
    func byCurrentTimeFetchIndex(currentTime:String) -> NSInteger {
        
        var  indexTmp:NSInteger = -1;

        for (index,value) in self.arrayLyricModel.enumerated() {
            
            let lyricmodel:LyricModel = value as! LyricModel;
            
            if lyricmodel.lyricTime.isEqual(to: currentTime){
                
                indexTmp = index;
            }
        }
        
        return indexTmp;
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "status", context: &myContext)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil);
    }
    
}



















