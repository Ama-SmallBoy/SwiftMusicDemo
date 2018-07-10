//
//  PlayMusicViewController.swift
//  SwiftMusicDemo
//
//  Created by mac on 2018/7/8.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class PlayMusicViewController: UIViewController,PlayManagerDelegate,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var songImg: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var currentTimeLable: UILabel!

    @IBOutlet weak var TotalDurationLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    var dataArray:NSMutableArray? = nil;
    
    var musicModel:MusicModel? = nil;
    
    var indexPath:NSInteger = 0;

    var roateTime:NSInteger = 100;
    
    var index:NSInteger = -1;//初始化一个不可能等的数值
    
    //将其生成单例
    internal static let sharedPlayerVC:PlayMusicViewController = PlayMusicViewController();
    
//    UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayViewControllerID") as! PlayMusicViewController;

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initFaceUI();// 初始化UI
        PlayManager.playManger.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        // 判断是不是同一首歌曲
        if indexPath==index {
            return;
        }
        self.playMusicDemo();
        index = indexPath;
    }
    
    func initFaceUI() -> Void {
        
        self.songImg.layoutIfNeeded();
        
        self.songImg.layer.masksToBounds = true;
    
        self.songImg.layer.cornerRadius = 117.5;
        
        let tmpUrl:NSURL = NSURL(string:musicModel!.musicImageUrl)!;
        
        self.songImg.sd_setImage(with: tmpUrl as URL, completed: nil);
        
        self.slider.setThumbImage(UIImage.init(named:"slider"), for: .normal);
        
        self.slider.setThumbImage(UIImage.init(named: "slider"), for: .highlighted);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //拖拽处理
    @IBAction func playSlider(_ sender: UISlider) {
        
        PlayManager.playManger.byCurrentTimeWithProgress(progress: CGFloat(sender.value));
    }
    
    @IBAction func playOrPauseAction(_ sender: UIButton) {
        
        if sender.isSelected {
            
            PlayManager.playManger.playMusic();
            sender.setTitle("暂停", for: UIControlState.normal);
        
        }else {
            
            PlayManager.playManger.pauseMusic();
            sender.setTitle("播放", for: UIControlState.normal);
        }
        sender.isSelected = !sender.isSelected;
    }
    
    //上一首歌
    @IBAction func playUPItemAction(_ sender: UIButton) {
        
        if indexPath > 0 {
            indexPath-=1;
        }else {
            indexPath = (self.dataArray?.count)! - 1;
        }
        self.playMusicDemo();
    }
    
    func playMusicDemo() -> Void {
        
        musicModel = self.dataArray?[indexPath] as? MusicModel;
        
        let path:String = Bundle.main.path(forResource: musicModel!.musicUrl, ofType: "mp3")!;
        
        PlayManager.playManger.initPlayer(musicUrl: path)
        
        self.title = musicModel?.musicName;
        
        let tmpUrl:NSURL = NSURL(string:musicModel!.musicImageUrl)!;
        
        self.songImg.sd_setImage(with: tmpUrl as URL, completed: nil);
    }
    
    //下一首歌
    @IBAction func playNextItemAction(_ sender: UIButton) {

        if indexPath < (self.dataArray?.count)! - 1 {
            indexPath+=1;
        }else {
            indexPath = 0;
        }
        self.playMusicDemo();
    }
    
    //获取时间相关参数
    func playMusicManagerFetchCurrentTime(Currentime: String, totalTime: String, progress: CGFloat) {
        
        //初始化slider
        
        self.slider.value = Float(progress);
        
        self.currentTimeLable.text = Currentime;
    
        self.TotalDurationLabel.text = totalTime;
        
        if roateTime == 100 {
            
            self.songImg.transform = self.songImg.transform.rotated(by: CGFloat(M_2_PI));
            
            roateTime = 0;
        }
        roateTime += 1;
        
        //加载歌词：滚动：
        let index:NSInteger = PlayManager.playManger.byCurrentTimeFetchIndex(currentTime: Currentime);

        if index == -1 {
            return;
        }
    
        let indexpath:IndexPath = IndexPath(row: index, section: 0);
        self.tableView.selectRow(at: indexpath, animated: true, scrollPosition: UITableViewScrollPosition.middle);
    }
    
    //播放结束
    func playMusicManagerEnd() {
        
        let btn:UIButton? = nil;
        self.playNextItemAction(btn!);
    }
    //MARK------UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PlayManager.playManger.fetchLyricSectionWithLyricString(lyricStr: (self.musicModel?.musicLyrics)!).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell");
        
        if cell==nil {
            
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell");
        }
        cell?.textLabel?.textAlignment = NSTextAlignment.center;
        
        let lymodelArr:Array<LyricModel> = PlayManager.playManger.fetchLyricSectionWithLyricString(lyricStr: (self.musicModel?.musicLyrics)!) as! Array<LyricModel>
        
        let modelLyric = lymodelArr[indexPath.row];
        
        cell?.textLabel?.text = modelLyric.lyricString as String;
        
        cell?.textLabel?.highlightedTextColor = UIColor.red;
        
        let backColorView:UIView = UIView();
        
        backColorView.backgroundColor = UIColor.white;
        
        cell?.selectedBackgroundView=backColorView;

        return cell!;
    }

}
