//
//  MarkList.swift
//  WebProject
//
//  Created by mac on 16/11/7.
//  Copyright © 2016年 pluto. All rights reserved.
//

import Foundation
import UIKit

class MarkList: NSObject, NSCoding {
    var ID: String
    var Name: String
    var Mark: String
    
    static let listURLs = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let listUrl = MarkList.listURLs.appendingPathComponent("rank.plist")
    
    init(Id id: String, Name name: String, Mark mark: String) {
        self.ID = id
        self.Name = name
        self.Mark = mark
    }
    
    required init(coder aDecoder: NSCoder) {
        self.ID = aDecoder.decodeObject(forKey: "id") as! String
        self.Name = aDecoder.decodeObject(forKey: "Name") as! String
        self.Mark = aDecoder.decodeObject(forKey: "Mark") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.ID, forKey: "id")
        aCoder.encode(self.Name, forKey: "Name")
        aCoder.encode(self.Mark, forKey: "Mark")
    }
}
