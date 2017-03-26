//
//  SelectTileView.swift
//  WebProject
//
//  Created by mac on 16/11/10.
//  Copyright © 2016年 pluto. All rights reserved.
//

import UIKit

class SelectTileView: UIView {
    let bgColor: UIColor = UIColor.white
    let fontColor: UIColor = UIColor.red
    let font: UIFont = UIFont(name: "HelveticaNeue-Blod", size: 20) ?? UIFont.systemFont(ofSize: 20)
    
    var label: UILabel
    
    unowned var delegate: selectView
    
    var labelValue: Int = 0 {
        didSet {
            self.label.text = "\(self.labelValue)"
        }
    }

    init(pos position: CGPoint, width: Int, value: Int, delegate: selectView) {
        self.delegate = delegate
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: width))
        self.label.font = self.font
        self.label.textColor = self.fontColor
        self.label.textAlignment = .center
        super.init(frame: CGRect(origin: position, size: CGSize(width: width, height: width)))
        self.addSubview(self.label)
        self.layer.cornerRadius = 8
        self.backgroundColor = self.bgColor
        self.labelValue = value
        self.label.text = "\(self.labelValue)"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SelectTileView.tapCommand(_:)))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    func tapCommand(_ v: UIGestureRecognizer) {
        delegate.endSelect(self.labelValue)
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
