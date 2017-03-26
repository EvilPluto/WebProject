//
//  SelectBoardController.swift
//  WebProject
//
//  Created by mac on 16/11/14.
//  Copyright © 2016年 pluto. All rights reserved.
//

import Foundation
import UIKit

class SelectBoardController {
    let tileNum: Int = 3
    let tileWidth: Int = 50
    let tilePadding: Int = 10
    
    weak var selectBoard: SelectBoardView?
    unowned var delegate: selectView
    
    init(view selectBoard: SelectBoardView, delegate: selectView) {
        self.delegate = delegate
        self.selectBoard = selectBoard
    }
    
    func positionIsValid(_ pos: (Int, Int)) -> Bool {
        let (x, y) = pos
        return x >= 0 && y >= 0 && x < tileNum && y < tileNum
    }
    
    func insertTile(_ pos: (Int, Int), value: Int) {
        assert(self.positionIsValid(pos), "Position(\(pos)) is not valid!")
        let (x, y) = pos
        
        let lengthX = x * (tileWidth + tilePadding) + tilePadding
        let lengthY = y * (tileWidth + tilePadding) + tilePadding
        let selectTile = SelectTileView(pos: CGPoint(x: lengthX, y:lengthY), width: tileWidth, value: value, delegate: delegate)
        
        selectBoard?.addSubview(selectTile)
        selectBoard?.bringSubview(toFront: selectTile)
    }
    
    func insertAllTile() {
        for i in 0 ..< tileNum {
            for j in 0 ..< tileNum {
                self.insertTile((i, j), value: (j * 3 + i + 1))
            }
        }
    }
}
