//
//  GameTileView.swift
//  WebProject
//
//  Created by mac on 16/11/9.
//  Copyright © 2016年 pluto. All rights reserved.
//

import UIKit

protocol selectedValue: class {
    func changeValue(value: Int)
}

class GameTileView: UIView, selectedValue {
    let posX: Int
    let posY: Int
    let fontColor: UIColor = UIColor(red: 119.0/255.0, green: 110.0/255.0, blue: 101.0/255.0, alpha: 1.0)
    let bgColor: UIColor = UIColor(red: 238.0/255.0, green: 228.0/255.0, blue: 218.0/255.0, alpha: 1.0)
    let bgColorBlock: UIColor = UIColor.brown
    let font: UIFont = UIFont(name: "HelveticaNeue-Blod", size: 15) ?? UIFont.systemFont(ofSize: 15)
    let fontColorBlock: UIColor = UIColor.white
    
    let boardWidth: Int!
    
    let label: UILabel!
    var labelValue: Int = 0 {
        willSet {
            if newValue == 0 {
                self.label.text = ""
            } else {
                self.label.text = "\(newValue)"
            }
        }
    }
    
    unowned var delegate: selectView

    init(_ position: CGPoint, posXY: (Int, Int), width: Int, value: Int, delegate: selectView) {
        (self.posX, self.posY) = posXY
        self.delegate = delegate
        self.boardWidth = width
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: width))
        self.label.textAlignment = .center
        self.label.font = self.font
        super.init(frame: CGRect(origin: position, size: CGSize(width: width, height: width)))
        self.addSubview(self.label)
        self.layer.cornerRadius = 6
        self.labelValue = value
        if value == 0 {
            self.label.text = ""
            self.backgroundColor = self.bgColorBlock
            self.label.textColor = self.fontColorBlock
            let tap = UITapGestureRecognizer(target: self, action: #selector(GameTileView.tapCommand(_:)))
            tap.numberOfTapsRequired = 1
            self.addGestureRecognizer(tap)
        } else {
            self.label.text = "\(labelValue)"
            self.backgroundColor = self.bgColor
            self.label.textColor = self.fontColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapCommand(_ r: UIGestureRecognizer) {
        self.backgroundColor = UIColor.red
        delegate.select(self)
    }
    
    func changeValue(value: Int) {
        self.labelValue = value
        GameBoardController.numberListAnswer[posX][posY] = value
        self.backgroundColor = self.bgColorBlock
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
