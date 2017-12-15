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
    func dataForPay(data:PurchaseCellModel)
}

class PaymentSelection: UIViewController, PopupContentViewController, PaymentDelegate  {

    var closeHandler:(()->Void)?
    var finishHandler:((_ result:JSON)->Void)?
    
    var payData:PurchaseCellModel?
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var btnWeixin: UIButton!
    @IBOutlet weak var btnAlipay: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size = CGSize(width: 365,height: 375)

        // Do any additional setup after loading the view.
        btnClose.addTarget(self, action: #selector(pay(_:)), for: .touchUpInside)
        btnWeixin.addTarget(self, action: #selector(pay(_:)), for: .touchUpInside)
        btnAlipay.addTarget(self, action: #selector(pay(_:)), for: .touchUpInside)
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
        return CGSize(width: 365,height: 375)

    }
    
    func handlePay(json:JSON)->(){
        let result = json["result"]
        finishHandler!(result)
    }
    
    func pay(_ sender: UIButton){
        let goodsId = payData?.goodsId
        let activityId = payData?.activityId
        
        switch sender {
        case btnWeixin:
            request(.buycardGood(payTypeInchannel: 4, channel: 2, paySource: 4, goodId: goodsId!, activityId: activityId!), success: handlePay)
            closeHandler!()
            
        case btnAlipay:
            request(.buycardGood(payTypeInchannel: 1, channel: 2, paySource: 9, goodId: goodsId!, activityId: activityId!), success: handlePay)
            closeHandler!()
            
        case btnClose:
            closeHandler!()
            
        default:
            break
        }
    }
    
    func dataForPay(data: PurchaseCellModel) {
        self.payData = data
        let agent = getAgent()
        let goodsName = agent["gameName"] as! String
        let goodsId = String.init(format: "ID:%d ", data.goodsId!)
        let cardNum = String.init(format: "%d张", data.cardNum!)
        lblOrderNo.text = goodsId + goodsName + cardNum
        lblAmount.text = String.init(format: "¥%.2f", data.price!)
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
