//
//  SelectBoardView.swift
//  WebProject
//
//  Created by mac on 16/11/10.
//  Copyright © 2016年 pluto. All rights reserved.
//

import UIKit

class SelectBoardView: UIView {
    let bgColor: UIColor = UIColor.black
    var defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 190, height: 190)
    var selfFrame: CGRect?
    var dragLastPos: CGPoint = CGPoint(x: 0, y: 0)
    
    init() {
        super.init(frame: self.defaultFrame)
        self.backgroundColor = bgColor
        self.layer.cornerRadius = 6
        
        let dragged = UIPanGestureRecognizer(target: self, action: #selector(SelectBoardView.dragged(_:)))
        dragged.minimumNumberOfTouches = 1
        dragged.maximumNumberOfTouches = 2
        self.addGestureRecognizer(dragged)
    }
    
    func dragged(_ r: UIPanGestureRecognizer) {
        let posTran = r.translation(in: self)
        if r.state == .began || r.state == .changed {
            self.center = CGPoint(x: posTran.x + self.center.x, y: posTran.y + self.center.y)
            r.setTranslation(CGPoint.zero, in: self)
        }
        
        /*
        self.selfFrame = self.frame
        selfFrame?.origin.x += (posTran.x - self.dragLastPos.x)
        selfFrame?.origin.y += (posTran.y - self.dragLastPos.y)
        self.frame = selfFrame!
        // print(NSStringFromCGPoint(r.translation(in: self)))
        if r.state == .ended {
            self.dragLastPos = CGPoint(x: 0, y: 0)
        } else {
            self.dragLastPos = posTran
        }
        */
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
