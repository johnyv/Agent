//
//  PaymentSelection.swift
//  Agent
//
//  Created by 于劲 on 2017/12/13.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import PopupController
import SwiftyJSON
import SVProgressHUD

protocol PaymentDelegate {
    func dataForPay(data:[String:Any])
}

class PaymentSelection: UIViewController, PopupContentViewController, PaymentDelegate  {

    var closeHandler:(()->Void)?
    var finishHandler:((_ result:JSON)->Void)?
    
    var payData = [String:Any]()
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var btnWeixin: UIButton!
    @IBOutlet weak var btnAlipay: UIButton!
    
    let width:CGFloat = UIScreen.main.bounds.width * 0.95
    let height:CGFloat = 425
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size = CGSize(width: width,height: height)

        // Do any additional setup after loading the view.
        btnClose.addTarget(self, action: #selector(pay(_:)), for: .touchUpInside)
        btnWeixin.addTarget(self, action: #selector(pay(_:)), for: .touchUpInside)
        btnWeixin.layer.cornerRadius = 5
        btnAlipay.addTarget(self, action: #selector(pay(_:)), for: .touchUpInside)
        btnAlipay.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instance() -> PaymentSelection {
        let storyboard = UIStoryboard(name: "PaymentSelection", bundle: nil)
        return storyboard.instantiateInitialViewController() as! PaymentSelection
    }

    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: width,height: height)

    }
    
    func handlePay(json:JSON)->(){
        let result = json["result"]
        finishHandler!(result)
    }
    
    func pay(_ sender: UIButton){
        let goodsId = payData["goodsId"] as! Int
        let activityId = payData["activityId"] as! Int
        
        switch sender {
        case btnWeixin:
            request(.buycardGood(payTypeInchannel: 4, channel: 2, paySource: 4, goodId: goodsId, activityId: activityId), success: handlePay)
            UserDefaults.standard.set(1, forKey: "PAYWAY")
            closeHandler!()
            
        case btnAlipay:
            request(.buycardGood(payTypeInchannel: 1, channel: 1, paySource: 9, goodId: goodsId, activityId: activityId), success: handlePay)
            UserDefaults.standard.set(2, forKey: "PAYWAY")
            closeHandler!()
            
        case btnClose:
            closeHandler!()
            
        default:
            break
        }
    }
    
    func dataForPay(data: [String:Any]) {
        self.payData = data
        let agent = AgentSession.shared.agentModel
        let goodsName = agent?.gameName
        let goodsId = String.init(format: "ID:%d ", data["goodsId"] as! Int)
        let cardNum = String.init(format: "%d张", data["cardNum"] as! Int)
        lblOrderNo.text = goodsId + goodsName! + cardNum
        lblAmount.text = String.init(format: "¥%.2f", data["price"] as! Float)
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
