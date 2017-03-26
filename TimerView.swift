//
//  TimerView.swift
//  WebProject
//
//  Created by mac on 16/11/3.
//  Copyright © 2016年 pluto. All rights reserved.
//

import UIKit

class TimerView: UIView, GameBoardDelegate {
    var timer = Timer()
    var isPlaying = false
    var timeLabel: UILabel
    var minuteValue: Int = 0
    var secondValue: Int = 0 {
        willSet {
            self.minuteValue = newValue == 60 ? self.minuteValue + 1 : self.minuteValue;
        }
        
        didSet {
            self.secondValue = oldValue == 59 ? 0 : self.secondValue;
        }
    }
    var counter: Int = 0 {
        willSet {
            if newValue == 100 {
                self.secondValue += 1
            }
        }
        
        didSet {
            if oldValue == 99 {
                self.counter = 0
            }
            
            if counter < 10 && secondValue < 10 {
                self.timeLabel.text = " Timer: \(minuteValue):0\(secondValue):0\(counter)"
            } else if counter >= 10 && secondValue < 10 {
                self.timeLabel.text = " Timer: \(minuteValue):0\(secondValue):\(counter)"
            } else if counter < 10 && secondValue >= 10 {
                self.timeLabel.text = " Timer: \(minuteValue):\(secondValue):0\(counter)"
            } else {
                self.timeLabel.text = " Timer: \(minuteValue):\(secondValue):\(counter)"
            }
        }
    }
    
    static var timeString: String = ""
    static var mark: Double = 100 {
        willSet {
            if newValue <= 0 {
                TimerView.mark = 0
            }
        }
    }
    
    unowned var gameBoardDelegate: GameBoardDelegate
    
    init(bgColor: UIColor, tColor: UIColor, delegate: GameBoardDelegate) {
        timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
        self.timeLabel.textColor = tColor
        self.timeLabel.textAlignment = .left
        self.gameBoardDelegate = delegate
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
        self.backgroundColor = bgColor
        self.addSubview(timeLabel)
        
        let tapFive = UITapGestureRecognizer(target: self, action: #selector(TimerView.tapFiveTimes(_:)))
        tapFive.numberOfTapsRequired = 5
        self.addGestureRecognizer(tapFive)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapFiveTimes(_ r: UIGestureRecognizer) {
        self.createAllAnswers()
    }
    
    func createAllAnswers() {
        self.gameBoardDelegate.createAllAnswers()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1 / 100, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    func endTimer() {
        timer.invalidate()
    }
    
    func updateTimer() {
        self.counter += 1
        TimerView.timeString = self.timeLabel.text!
        TimerView.mark -= 1 / 600
    }
    
    static func getTime() -> String {
        return TimerView.timeString
    }
    
    static func getMark() -> Double {
        var markEnd = TimerView.mark
        switch ViewController.difficultySel {
        case "Easy":
            markEnd = TimerView.mark * 1.0
        case "Normal":
            markEnd = TimerView.mark * 2.0
        case "Hard":
            markEnd = TimerView.mark * 3.0
        default:
            break
        }
        
        return markEnd
    }
    
    static func setZero() {
        TimerView.mark = 100
    }
    
}
