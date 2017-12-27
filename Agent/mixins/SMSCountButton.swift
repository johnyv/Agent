//
//  SMSCountButton.swift
//  Agent
//
//  Created by 于劲 on 2017/12/12.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

@IBDesignable class SMSCountButton: UIButton {
    var countdownTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var remainingSeconds: Int = 0 {
        willSet {
            setTitle("(\(newValue))", for: .normal)
            
            if newValue <= 0 {
                setTitle("重新获取", for: .normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime(_:)), userInfo: nil, repeats: true)
                
                remainingSeconds = 10
                
                //self.backgroundColor = UIColor.gray
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                //self.backgroundColor = UIColor.red
            }
            
            self.isEnabled = !newValue
        }
    }
    
    func updateTime(_ timer: Timer) {
        remainingSeconds -= 1
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
