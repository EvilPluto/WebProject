//
//  GameBoardModel.swift
//  WebProject
//
//  Created by mac on 16/11/10.
//  Copyright © 2016年 pluto. All rights reserved.
//

import Foundation
import UIKit

protocol GameBoardDelegate : class {
    func createAllAnswers()
}

class GameBoardController : GameBoardDelegate {

    let boardsNum: Int = 9 // 每一行的块数
    let tileLittlePadding: Int = 3
    let tileLargePadding: Int = 5
    let tileBlockWidth: Int = 126 // 三个组成的块宽度
    let gameWidth: Int = 398
    let tileWidth: Int = 40 // 单个块宽度
    
    //static var tiles: Dictionary<IndexPath, Int> = Dictionary()
    
    var gameBoard: GameBoardView?
    unowned var delegate: selectView
    
    let listPaths = Bundle.main.path(forResource: "listPaths", ofType: "plist")
    var listPathDic: [String: String]?
    var listPath_Easy: String?
    var listPath_Normal: String?
    var listPath_Hard: String?
    var numberListTrue: [[Int]]?
    static var numberListAnswer: [[Int]] = [[]]
    
    init(view gameBoard: GameBoardView, delegate: selectView) {
        self.gameBoard = gameBoard
        self.delegate = delegate
    }
    
    func positionIsValid(_ pos: (Int, Int)) -> Bool {
        let (x, y) = pos
        return x >= 0 && y >= 0 && x < boardsNum && y < boardsNum
    }
    
    func insertTiles(_ pos: (Int, Int), value: Int) {
        assert(self.positionIsValid(pos), "Position(\(pos)) is not valid!")
        let (x, y) = pos
        
        let lengthX = x / 3 * (tileBlockWidth + tileLargePadding) + tileLargePadding + x % 3 * (tileWidth + tileLittlePadding)
        let lengthY = y / 3 * (tileBlockWidth + tileLargePadding) + tileLargePadding + y % 3 * (tileWidth + tileLittlePadding)
        let gameTile = GameTileView(CGPoint(x: lengthX, y: lengthY), posXY: (x, y), width: self.tileWidth, value: value, delegate: self.delegate)
        //let gameTileController = GameTileController(pos: CGPoint(x: lengthX, y:lengthY), width: self.tileWidth, value: value)
        //gameBoard?.addSubview(gameTileController.getTileView())
        //gameBoard?.bringSubview(toFront: gameTileController.getTileView())
        gameBoard?.addSubview(gameTile)
        gameBoard?.bringSubview(toFront: gameTile)
        //gameTileController.setGesture()
        /*
        let tap = UITapGestureRecognizer(target: gameTile, action: #selector(GameBoardController.tapCommand(_:)))
        tap.numberOfTapsRequired = 1
        gameTile.addGestureRecognizer(tap)
        */
    }
    
    func insertAll() {
        self.initNum()
        for i in 0 ..< boardsNum {
            for j in 0 ..< boardsNum {
                self.insertTiles((i, j), value: GameBoardController.numberListAnswer[i][j])
            }
        }
    }
    
    func initNum() {
        self.listPathDic = NSDictionary(contentsOfFile: listPaths!) as? [String: String]
        self.listPath_Easy = listPathDic?["Easy"]
        self.listPath_Normal = listPathDic?["Normal"]
        self.listPath_Hard = listPathDic?["Hard"]
        
        switch ViewController.difficultySel {
        case "Easy":
            self.numberListTrue = (NSArray(contentsOfFile: Bundle.main.path(forResource: self.listPath_Easy!, ofType: "plist")!) as? [[[Int]]])?[0]
            GameBoardController.numberListAnswer = ((NSArray(contentsOfFile: Bundle.main.path(forResource: self.listPath_Easy!, ofType: "plist")!) as? [[[Int]]])?[1])!
        case "Normal":
            self.numberListTrue = (NSArray(contentsOfFile: Bundle.main.path(forResource: self.listPath_Normal!, ofType: "plist")!) as? [[[Int]]])?[0]
            GameBoardController.numberListAnswer = ((NSArray(contentsOfFile: Bundle.main.path(forResource: self.listPath_Normal!, ofType: "plist")!) as? [[[Int]]])?[1])!
        case "Hard":
            self.numberListTrue = (NSArray(contentsOfFile: Bundle.main.path(forResource: self.listPath_Hard!, ofType: "plist")!) as? [[[Int]]])?[0]
            GameBoardController.numberListAnswer = ((NSArray(contentsOfFile: Bundle.main.path(forResource: self.listPath_Hard!, ofType: "plist")!) as? [[[Int]]])?[1])!
        default:
            break
        }

        /*
        var count = 0
        while count <= 5 {
            count += 1
            let randomPosX = Int(arc4random_uniform(UInt32(9)))
            let randomPosY = Int(arc4random_uniform(UInt32(9)))
            GameBoardController.numberListAnswer[randomPosX][randomPosY] = 0
        }
         */
    }
    
    func createAllAnswers() {
        for i in 0 ..< boardsNum {
            for j in 0 ..< boardsNum {
                GameBoardController.numberListAnswer[i][j] = (self.numberListTrue?[i][j])!
                self.insertTiles((i, j), value: (self.numberListTrue?[i][j])!)
            }
        }
    }
}
