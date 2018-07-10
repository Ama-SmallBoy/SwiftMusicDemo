//
//  MusicListTableCell.swift
//  SwiftMusicDemo
//
//  Created by mac on 2018/7/8.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class MusicListTableCell: UITableViewCell {
    
    @IBOutlet weak var imgHeadView: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var singerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
   
    }
    
    func bindObject(musicModel:MusicModel) -> Void {
        
        let tmpUrl:NSURL = NSURL(string:musicModel.musicImageUrl)!;
        
        imgHeadView.sd_setImage(with: tmpUrl as URL, completed: nil);
        
        songNameLabel.text = musicModel.musicName;
        
        singerName.text = musicModel.musicSinger;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
