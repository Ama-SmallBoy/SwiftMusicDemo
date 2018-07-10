//
//  MusicModel.swift
//  SwiftMusicDemo
//
//  Created by mac on 2018/7/8.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class MusicModel: NSObject {
    
    var musicName = ""      //歌名

    var musicUrl = ""       //歌曲地址

    var musicImageUrl = ""  //图片地址

    var musicSinger = ""    //歌手名字

    var musicLyrics = ""    //歌词
    
    // 重写 setValuesForKeysWithDictionary 那么字典中可以有的字段在类中没有对应属性
   func setValuesForKeysWithDictionary(keyedValues: [NSDictionary : AnyObject]) {
        
    
    }

}
