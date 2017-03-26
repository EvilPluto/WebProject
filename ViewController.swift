//
//  ViewController.swift
//  WebProject
//
//  Created by mac on 16/11/3.
//  Copyright © 2016年 pluto. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyXMLParser

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var difficultyTable: UITableView!
    static var difficultySel: String = "Easy"
    let difficultyValues = ["Easy", "Normal", "Hard"]
    
    var xml: XML.Accessor?
    
    let mark: Parameters = [
        "name": "HXH",
        "mark": 0
    ]
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBAction func selectDifficulty(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.difficultyTable.alpha = self.difficultyTable.alpha == 1 ? 0 : 1
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "difficultyTitle", for: indexPath)
        Cell.textLabel?.backgroundColor = UIColor.clear
        Cell.textLabel?.text = self.difficultyValues[indexPath.row]
        Cell.textLabel?.textColor = UIColor.white
        Cell.textLabel?.textAlignment = .center
        Cell.textLabel?.highlightedTextColor =  .red
        Cell.textLabel?.shadowColor =  .white
        
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.difficultyTable.alpha = 0
        },
            completion: { (finished: Bool) -> Void in
                self.selectBtn.setTitle(self.difficultyValues[indexPath.row], for: .normal)
                ViewController.difficultySel = self.difficultyValues[indexPath.row]
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.difficultyTable.delegate = self
        self.difficultyTable.dataSource = self
        self.difficultyTable.rowHeight = 30

        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func startGame(_ sender: AnyObject) {
//        
//        let writeArray = [
//            [
//                [5,9,8,1,7,4,2,6,3],
//                [7,6,4,9,3,2,1,8,5],
//                [3,1,2,5,8,6,4,9,7],
//                [6,7,9,4,2,8,5,3,1],
//                [8,3,5,6,1,7,9,4,2],
//                [2,4,1,3,9,5,8,7,6],
//                [4,8,6,2,5,3,7,1,9],
//                [9,2,3,7,4,1,6,5,8],
//                [1,5,7,8,6,9,3,2,4]
//            ],
//            [
//                [0,0,0,1,0,0,2,6,0],
//                [7,0,0,0,3,0,0,0,0],
//                [3,0,2,0,8,0,4,0,0],
//                [0,0,0,4,0,8,0,0,1],
//                [0,3,5,0,0,0,9,4,0],
//                [2,0,0,3,0,5,0,0,0],
//                [0,0,6,0,5,0,7,0,9],
//                [0,0,0,0,4,0,0,0,8],
//                [0,5,7,0,0,9,0,0,0]
//            ]
//        ] as NSArray
//        
//        //let numberListPath = Bundle.main.url(forResource: "Normal", withExtension: "plist")
//        var numberListPath = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
//        numberListPath?.appendPathComponent("Hard.plist")
//        writeArray.write(to: numberListPath!, atomically: true)
//        print("Path: \(numberListPath!.path)")
        //listPaths.write(to: numberListPath!, atomically: true)
        /*
        Alamofire.request("http://192.168.1.174/GameServer/GameServer2.php", method: .get /*method: .post, parameters: self.mark*/).responseString(completionHandler:  { response in
            print("Request: \(response.request!)")
            print("Success: \(response.result.isSuccess)")
            //print("XML: \(response.result.value!)")
            
            if let data = response.data {
                self.xml = XML.parse(data)
                let arrayMark = self.xml?["root", "server2"]
                
                for servers in arrayMark! {
                    let id = servers["id"].int!
                    let name = servers["name"].text!
                    let mark = servers["mark"].text!
                    print("ID: \(id) \nName: \(name)  \nMark: \(mark) \n")
                }
            }
         })
        */
        
        let game = GameRootController()
        self.present(game, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(segue: UIStoryboardSegue) {
        print("back")
    }


}

