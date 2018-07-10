//
//  MusicListTController.swift
//  SwiftMusicDemo
//
//  Created by mac on 2018/7/8.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit
import YYModel
import Foundation
class MusicListTController: UITableViewController {
    
    var dataArray:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.red;
        
        let  tmpView:UIView = UIView();
        
        tmpView.backgroundColor = UIColor.gray;
        
        self.tableView.tableFooterView = tmpView;
        
        self.tableView.register(UINib.init(nibName: "MusicListTableCell", bundle: nil), forCellReuseIdentifier: "MusicListTableCell");
        
        self.tableView.rowHeight = 146.0;
        
        //读取pllist文件：
        
        let pathStr:String = Bundle.main.path(forResource: "MusicUrls", ofType: "plist")!;
        
        let tmpArr:NSArray = NSArray.init(contentsOfFile: pathStr)!;
        
        print(tmpArr.count)
        
        self.dataArray = NSMutableArray();
        
        for  tmpdic in tmpArr{
            
            let musicModel:MusicModel = MusicModel();
            
            let tmpDic:NSDictionary = tmpdic as! NSDictionary;
            //KVC
            musicModel.musicName = tmpDic.object(forKey: "musicName") as! String;
            musicModel.musicSinger = tmpDic.object(forKey: "musicSinger") as! String;
            musicModel.musicImageUrl = tmpDic.object(forKey: "musicImageUrl") as! String;
            musicModel.musicLyrics = tmpDic.object(forKey: "musicLyrics") as! String;
            
            musicModel.musicUrl = tmpDic.object(forKey: "musicUrl") as! String;
   
            self.dataArray.add(musicModel);
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    
        return self.dataArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MusicListTableCell = tableView.dequeueReusableCell(withIdentifier: "MusicListTableCell", for: indexPath) as! MusicListTableCell;
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        let musicModel: MusicModel = self.dataArray[indexPath.row] as! MusicModel;
        
        cell.bindObject(musicModel: musicModel);
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 跳转到该页面播放页面
        
        let  playMusicViewController:PlayMusicViewController = PlayMusicViewController.sharedPlayerVC;
        
        let musicModel: MusicModel = self.dataArray[indexPath.row] as! MusicModel;
        
        playMusicViewController.musicModel = musicModel;
        
        playMusicViewController.indexPath = indexPath.row;
        
        playMusicViewController.dataArray = self.dataArray;
        
        self.navigationController?.pushViewController(playMusicViewController, animated: true);
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
