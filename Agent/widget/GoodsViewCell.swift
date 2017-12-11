//
//  GoodsViewCell.swift
//  Agent
//
//  Created by 于劲 on 2017/12/1.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

//class FrameView: UIView {
//    override init(frame: CGRect){
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func draw(_ rect: CGRect) {
////        let pathRect = CGRect
//    }
//}

class GoodsViewCell: UICollectionViewCell {

    @IBOutlet weak var lblCardNum: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblSuperscript: UILabel!
    
    var frColor:UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        let pathRect = self.bounds.insetBy(dx: 1, dy: 1)
        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: 5)
        path.lineWidth = 1
        //UIColor.orange.setStroke()
        frColor?.setStroke()
        //path.fill()
        path.stroke()
    }
}
