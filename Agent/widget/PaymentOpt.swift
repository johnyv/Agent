//
//  PaymentOpt.swift
//  Agent
//
//  Created by 于劲 on 2017/12/15.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import PopupController
import SwiftyJSON

protocol PayOrderDelegate {
    func orderToPay(orderNo:String)
}

class PaymentOpt: UIViewController, PopupContentViewController, PayOrderDelegate {
    
    var closeHandler:(()->Void)?
    var cancelHandler:((_ result:JSON)->Void)?
    var payHandler:((_ result:JSON)->Void)?

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnPay: UIButton!
    
    var orderNo:String?
    
    let width:CGFloat = UIScreen.main.bounds.width * 0.8
    let height:CGFloat = 185
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size = CGSize(width: width,height: height)

        // Do any additional setup after loading the view.
        btnCancel.addTarget(self, action: #selector(opt(_:)), for: .touchUpInside)
        btnPay.addTarget(self, action: #selector(opt(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instance() -> PaymentOpt {
        let storyboard = UIStoryboard(name: "PaymentOpt", bundle: nil)
        return storyboard.instantiateInitialViewController() as! PaymentOpt
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: width,height: height)
        
    }

    func handleCancel(json:JSON)->(){
        let result = json["result"]
        cancelHandler!(result)
    }

    func handlePay(json:JSON)->(){
        let result = json["result"]
        payHandler!(result)
    }

    func opt(_ sender: UIButton){
        
        switch sender {
        case btnCancel:
            request(.cancel(orderNo: self.orderNo!), success: handleCancel)
            closeHandler!()
            
        case btnPay:
            request(.unpaidToPay(orderNo: self.orderNo!), success: handlePay)
            closeHandler!()
        default:
            break
        }
    }
    
    func orderToPay(orderNo: String) {
        self.orderNo = orderNo
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
