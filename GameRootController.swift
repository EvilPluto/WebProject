//
//  GameRootViewController.swift
//  WebProject
//
//  Created by mac on 16/11/3.
//  Copyright © 2016年 pluto. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyXMLParser

protocol selectView: class {
    func select(_ delegate: selectedValue)
    func endSelect(_ value: Int)
}

class GameRootController: UIViewController, selectView {
    var submit: UIAlertAction! // 全局储存上传按钮状体
    
    var playerName: String = "Unknown"
    var playerMark: Int = 0
    
    var timerBlock: TimerView?
    var gameBoard: GameBoardView?
    var gameBoardController: GameBoardController?
    var selectBoard: SelectBoardView?
    var selectBoardController: SelectBoardController?
    
    var delegate: selectedValue?
    
    let listPaths = Bundle.main.path(forResource: "listPaths", ofType: "plist")
    var listPathDic: [String: String]?
    var listPath_Easy: String?
    var listPath_Normal: String?
    var listPath_Hard: String?
    var numberListTrue: [[Int]]?
    
    var mark: Parameters?
    var xml: XML.Accessor?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(red: 0xE6/255, green: 0xE2/255, blue: 0xD4/255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func select(_ delegate: selectedValue) {
        self.delegate = delegate
        selectBoard = SelectBoardView()
        var selectFrame = selectBoard!.frame
        selectFrame.origin.x = xPos(selectBoard!)
        selectFrame.origin.y = yPos(selectBoard!)
        selectBoard!.frame = selectFrame
        view.addSubview(selectBoard!)
        
        selectBoardController = SelectBoardController(view: selectBoard!, delegate: self)
        selectBoardController?.insertAllTile()
        
        gameBoard?.isUserInteractionEnabled = false
    }
    
    func endSelect(_ value: Int) {
        delegate?.changeValue(value: value)
        selectBoard?.removeFromSuperview()
        gameBoard?.isUserInteractionEnabled = true
    }
    
    func xPos(_ v: UIView) -> CGFloat {
        let viewWidth = view.bounds.size.width
        return (viewWidth - v.bounds.size.width) / 2
    }
    
    func yPos(_ v: UIView) -> CGFloat {
        let viewHeight = view.bounds.size.height
        return (viewHeight - v.bounds.size.height) / 2
    }
    
    func setupGame() {
        gameBoard = GameBoardView()
        var gameFrame = gameBoard!.frame
        gameFrame.origin.x = xPos(gameBoard!)
        gameFrame.origin.y = yPos(gameBoard!)
        gameBoard!.frame = gameFrame
        view.addSubview(gameBoard!)
        
        gameBoardController = GameBoardController(view: self.gameBoard!, delegate: self)
        gameBoardController!.insertAll()
        
        timerBlock = TimerView(
            bgColor: UIColor(red: 0xA2/255, green: 0x94/255, blue: 0x5E/255, alpha: 1),
            tColor: UIColor(red: 0xF3/255, green: 0xF1/255, blue: 0x1A/255, alpha: 1),
            delegate: gameBoardController!
        )
        
        var timerFrame = timerBlock!.frame
        timerFrame.origin.x = 0
        timerFrame.origin.y = 25
        timerBlock!.frame = timerFrame
        view.addSubview(timerBlock!)
        timerBlock!.startTimer()
        
        let backBtn = UIButton(frame: CGRect(x: view.bounds.size.width - 150, y: 25, width: 150, height: 25))
        backBtn.layer.cornerRadius = 8
        backBtn.addTarget(self, action: #selector(GameRootController.back(_:)), for: .touchUpInside)
        backBtn.setTitleColor(.black, for: .normal)
        backBtn.setTitle("返回", for: .normal)
        backBtn.setTitleColor(.red, for: .highlighted)
        backBtn.backgroundColor = UIColor(red: 0xA2/255, green: 0x94/255, blue: 0x5E/255, alpha: 1)
        view.addSubview(backBtn)
        
        let checkBtn = UIButton(frame: CGRect(x: view.bounds.size.width - 150, y:(view.bounds.size.height - 50), width: 150, height: 25))
        checkBtn.layer.cornerRadius = 8
        checkBtn.addTarget(self, action: #selector(GameRootController.check(_:)), for: .touchUpInside)
        checkBtn.setTitleColor(.black, for: .normal)
        checkBtn.setTitle("确认提交", for: .normal)
        checkBtn.setTitleColor(.red, for: .highlighted)
        checkBtn.backgroundColor = UIColor(red: 0xA2/255, green: 0x94/255, blue: 0x5E/255, alpha: 1)
        view.addSubview(checkBtn)
    }
    
    func back(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
        timerBlock?.endTimer()
        TimerView.setZero()
    }
    
    func check(_ sender: Any?) {
        timerBlock?.endTimer()
        self.listPathDic = NSDictionary(contentsOfFile: self.listPaths!) as? [String: String]
        self.listPath_Easy = listPathDic?["Easy"]
        self.listPath_Normal = listPathDic?["Normal"]
        self.listPath_Hard = listPathDic?["Hard"]
        
        switch ViewController.difficultySel {
        case "Easy":
            self.numberListTrue = (NSArray(contentsOfFile: Bundle.main.path(forResource: self.listPath_Easy!, ofType: "plist")!) as? [[[Int]]])?[0]
        case "Normal":
            self.numberListTrue = (NSArray(contentsOfFile: Bundle.main.path(forResource: self.listPath_Normal!, ofType: "plist")!) as? [[[Int]]])?[0]
        case "Hard":
            self.numberListTrue = (NSArray(contentsOfFile: Bundle.main.path(forResource: self.listPath_Hard!, ofType: "plist")!) as? [[[Int]]])?[0]
        default:
            break
        }
        
        for i in 0 ..< 9 {
            for j in 0 ..< 9 {
                if self.numberListTrue![i][j] != GameBoardController.numberListAnswer[i][j] {
                    let alertController = UIAlertController(title: "游戏结束", message: "You Lost! \n\(TimerView.getTime())", preferredStyle: .alert)
                    let back = UIAlertAction(title: "返回主菜单", style: .default, handler: { (UIAlertAction) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(back)
                    self.present(alertController, animated: true, completion: nil)
                    TimerView.setZero()
                    return
                }
            }
        }
        print("Successful")
        let alertController = UIAlertController(title: "游戏结束", message: "You Win! \n\(TimerView.getTime())", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (title: UITextField) -> Void in
            NotificationCenter.default.addObserver(self, selector: #selector(GameRootController.textChange(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: title)
            title.placeholder = "请输入玩家姓名："
            title.backgroundColor = UIColor.lightGray
            title.textAlignment = .center
        })
        let back = UIAlertAction(title: "返回主菜单", style: .default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        self.submit = UIAlertAction(title: "上传成绩", style: .default, handler: { (UIAlertAction) in
            self.playerName = alertController.textFields![0].text ?? "Unknown"
            self.submitMark()
        })
        alertController.addAction(back)
        alertController.addAction(submit)
        self.playerMark = Int(TimerView.getMark())
        self.submit.isEnabled = false // 禁用提交按钮
        self.present(alertController, animated: true, completion: nil)
        TimerView.setZero()
    }
    
    func submitMark() {
        self.mark = [
            "name": self.playerName,
            "mark": self.playerMark
        ]
        
        Alamofire.request(MarkListViewController.serverPath, method: .post, parameters: self.mark).responseString(completionHandler:  { response in
            print("Request: \(response.request!)")
            print("Success: \(response.result.isSuccess)")
            //print("XML: \(response.result.value!)")
            
            var code = 404
            if response.result.isSuccess {
                if let data = response.data {
                    self.xml = XML.parse(data)
                    code = (self.xml?["root", "server2", "code"].int)!
                    print("Code: \(code)")
                }
            }

            if code == 200 {
                let alertController = UIAlertController(title: "游戏结束", message: "上传成功，返回主菜单...", preferredStyle: .alert)
                let back = UIAlertAction(title: "关闭", style: .cancel, handler: { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(back)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "游戏结束", message: "上传失败，请检查网络！", preferredStyle: .alert)
                let back = UIAlertAction(title: "关闭", style: .cancel, handler: { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(back)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    func textChange(_ notification: Notification) {
        let textField = notification.object as! UITextField
        if let text = textField.text {
            if text != "" {
                self.submit.isEnabled = true
            } else {
                self.submit.isEnabled = false
            }
        } else {
            print("Text None!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGame()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
