//
//  MarkListViewController.swift
//  WebProject
//
//  Created by mac on 16/11/7.
//  Copyright © 2016年 pluto. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyXMLParser

class MarkListViewController: UITableViewController {
    private var selfOrNot: Bool = true // 首先在个人列表
    private let selfID: String = "2"

    var xml: XML.Accessor?
    
    static let serverPath: String = "http://115.28.158.106/GameServer/GameServer2.php"
    // ›static let serverPath: String = "http://192.168.1.174/GameServer/GameServer2.php"
    
    let mark: Parameters = [
        "name": "逗比HXH",
        "mark": 11
    ]
    
    var markList: [MarkList] = []
    var listForWrite: [MarkList] = []
    
    var self_MarkList: [MarkList] = []
    
    var toAllList: UIBarButtonItem!
    var toSelfList: UIBarButtonItem!

    override func viewDidLoad() {
        self.markList = self.loadFile()
        self.self_MarkList = self.getSelfList()
        
        // 一个点击跳转到全部排名的按钮
        self.toAllList = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(MarkListViewController.toAllList(_:)))
        
        // 一个点击跳转到个人排名的按钮
        self.toSelfList = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(MarkListViewController.toSelfList(_:)))
        
        self.navigationItem.leftBarButtonItems?[1] = self.toAllList
        self.selfOrNot = true
        
        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 30))
        headerView.backgroundColor = .lightGray
        
        let nameLabel:UILabel = UILabel(frame: CGRect(x: 22, y: 0, width: 200, height: 30))
        nameLabel.text = "玩家昵称"
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        
        let markLabel:UILabel = UILabel(frame: CGRect(x: self.tableView.frame.width - 72, y: 0, width: 60, height: 30))
        markLabel.text = "得分"
        markLabel.textAlignment = .right
        markLabel.font = UIFont.systemFont(ofSize: 20)
        
        headerView.addSubview(nameLabel)
        headerView.addSubview(markLabel)
        self.tableView.tableHeaderView = headerView
        
        super.viewDidLoad()
        
        Alamofire.request(MarkListViewController.serverPath, method: .get /*method: .post, parameters: self.mark*/).responseString(completionHandler:  { response in
            print("Request: \(response.request!)")
            print("Success: \(response.result.isSuccess)")
            //print("XML: \(response.result.value!)")
            
            if response.result.isSuccess {
                if let data = response.data {
                    self.xml = XML.parse(data)
                    let arrayMark = self.xml?["root", "server2"]
                    
                    for servers in arrayMark! {
                        let id = servers["id"].text!
                        let name = servers["name"].text!
                        let mark = servers["mark"].text!
                        print("ID: \(id) \nName: \(name)  \nMark: \(mark) \n")
                        self.listForWrite.append(MarkList(Id: id, Name: name, Mark: mark))
                    }
                    self.saveTofile()
                }
            }
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func toAllList(_ sender: Any) {
        self.selfOrNot = false
        self.navigationItem.title = "全服排名"
        self.navigationItem.leftBarButtonItems?[1] = self.toSelfList
        self.tableView.reloadData()
    }
    
    func toSelfList(_ sender: Any) {
        self.selfOrNot = true
        self.navigationItem.title = "本机排名"
        self.navigationItem.leftBarButtonItems?[1] = self.toAllList
        self.tableView.reloadData()
    }
    
    func getSelfList() -> [MarkList] {
        var list: [MarkList] = []
        for listItem in self.markList {
            if listItem.ID == self.selfID {
                list.append(listItem)
            }
        }
        return list
    }
    
    func loadFile() -> [MarkList] {
        print(MarkList.listUrl.path)
        if let file = NSKeyedUnarchiver.unarchiveObject(withFile: MarkList.listUrl.path) {
            return file as! [MarkList]
        } else {
            print("file load failed!")
            let mark: [MarkList] = [
                MarkList(Id: "110", Name: "测试账号1", Mark: "1")
            ]
            return mark
        }
    }
    
    func saveTofile() {
        let success = NSKeyedArchiver.archiveRootObject(self.listForWrite, toFile: MarkList.listUrl.path)
        self.listForWrite.removeAll()
        if !success {
            print("file save failed!")
        } else {
            print("save Successful!")
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
        if self.selfOrNot {
            return self.self_MarkList.count
        } else {
            return self.markList.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "markList", for: indexPath)
        
        if self.selfOrNot {
            //(cell.viewWithTag(1) as! UILabel).text = "\(self.markList[indexPath.row].ID)"
            (cell.viewWithTag(2) as! UILabel).text = self.self_MarkList[indexPath.row].Name
            (cell.viewWithTag(3) as! UILabel).text = "\(self.self_MarkList[indexPath.row].Mark)"
        } else {
            //(cell.viewWithTag(1) as! UILabel).text = "\(self.markList[indexPath.row].ID)"
            (cell.viewWithTag(2) as! UILabel).text = self.markList[indexPath.row].Name
            (cell.viewWithTag(3) as! UILabel).text = "\(self.markList[indexPath.row].Mark)"
        }

        return cell
    }

    @IBAction func refresh(_ sender: Any) {
        self.markList = loadFile()
        self.self_MarkList = getSelfList()
        self.tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.0,
                           delay: 0.05 * Double(index),
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                            },
                           completion: nil)
            index += 1
        }
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
