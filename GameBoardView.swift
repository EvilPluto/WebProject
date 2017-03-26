//
//  GameBoardView.swift
//  WebProject
//
//  Created by mac on 16/11/3.
//  Copyright © 2016年 pluto. All rights reserved.
//

import UIKit

class GameBoardView: UIView {
    let bgColor: UIColor = UIColor(red: 0x90/255, green: 0x8D/255, blue: 0x80/255, alpha: 1)
    let defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 398, height: 398)
    
    init() {
        super.init(frame: self.defaultFrame)
        self.backgroundColor = bgColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
