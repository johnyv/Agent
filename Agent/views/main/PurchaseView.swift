//
//  PurchaseView.swift
//  Agent
//
//  Created by 于劲 on 2017/11/29.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya
import SVProgressHUD
import PopupController

class PurchaseView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var goodsData = [PurchaseCellModel]()
    let cellGoodsIdentifier = "GoodsCell"

    let crDefault = UIColor(red: 1.0, green: 43.0/255.0, blue: 83.0/255.0, alpha: 1.0)
    var dictTag = [String:Any]()
    
    let crCell = [
//        "":[UIColor(red: 1.0, green: 43.0/255.0, blue: 83.0/255.0, alpha: 1.0),],
        "1st":UIColor(red: 26.0/255.0, green: 173.0/255.0, blue: 25.0/255.0, alpha: 1.0),
        "NEW":UIColor(red: 1.0, green: 83.0/255.0, blue: 42, alpha: 1.0),
        "HOT":UIColor(red: 1.0, green: 145.0/255.0, blue: 0.0, alpha: 1.0),
        "活动":UIColor(red: 0.0, green: 140.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    ]
    
    let tagCell = [
        "1st":UIImage(named: "tag_1st"),
        "NEW":UIImage(named: "tag_period"),
        "HOT":UIImage(named: "tag_special"),
        "活动":UIImage(named: "tag_activity")
    ]
    
    @IBOutlet weak var imgHeadIco: UIImageView!
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var lblAccountID: UILabel!
    @IBOutlet weak var lblGameName: UILabel!
    @IBOutlet weak var clvGoods: UICollectionView!
    
    var payDelegate:PaymentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dictTag["1st"] = [UIColor(red: 26.0/255.0, green: 173.0/255.0, blue: 25.0/255.0, alpha: 1.0),UIImage(named: "tag_1st")]
        dictTag["NEW"] = [UIColor(red: 1.0, green: 83.0/255.0, blue: 42, alpha: 1.0), UIImage(named: "tag_period")]
        dictTag["HOT"] = [UIColor(red: 1.0, green: 145.0/255.0, blue: 0.0, alpha: 1.0), UIImage(named: "tag_special")]
        dictTag["活动"] = [UIColor(red: 0.0, green: 140.0/255.0, blue: 230.0/255.0, alpha: 1.0), UIImage(named: "tag_activity")]
        
        // Do any additional setup after loading the view.
        clvGoods.delegate = self
        clvGoods.dataSource = self
        
        let xib = UINib(nibName: "GoodsViewCell", bundle: nil)
        clvGoods.register(xib, forCellWithReuseIdentifier: cellGoodsIdentifier)
        
        let layOut = UICollectionViewFlowLayout()
        layOut.itemSize = CGSize(width: UIScreen.main.bounds.width/3-10, height: 90)
        layOut.minimumLineSpacing = 5
        layOut.minimumInteritemSpacing = 0
        layOut.sectionInset.left = 10
        layOut.sectionInset.right = 10
        layOut.sectionInset.bottom = 10
        clvGoods.setCollectionViewLayout(layOut, animated: false)
//        let source = TokenSource()
//        source.token = getSavedToken()
//        let provider = MoyaProvider<NetworkManager>(plugins:[
//            AuthPlugin(tokenClosure: {return source.token})])
//        
//        Network.request(.goodList, success: handleData, provider: provider)
        request(.goodList, success: handleData)
        
        let agent = getAgent()
        
        let strURL = agent["headImg"] as? String
        let icoURL = URL(string: strURL!)
        imgHeadIco.sd_setImage(with: icoURL, completed: nil)

        let nickName = agent["nickName"] as? String
        lblNickName.text = nickName
        
        let gameName = agent["gameName"] as? String
        lblGameName.text = gameName

        let accountID = agent["agentId"] as? Int
        lblAccountID.text = String.init(format: "ID:%d", accountID!)

        autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func listOrders(_ sender: UIBarButtonItem) {
        let vc = loadVCfromMain(identifier: "ordersView") as? OrdersView
        present(vc!, animated: true, completion: nil)
    }
    
    fileprivate func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            let dataArr = result["data"].array
            for(_, data) in (dataArr?.enumerated())!{
                goodsData.append(PurchaseCellModel(goodsId: data["goodsId"].intValue, activityId: data["activityId"].intValue, cardNum: data["cardNum"].intValue, extraNum: data["extraNum"].intValue, activityExtraNum: data["activityExtraNum"].intValue, price: data["price"].floatValue, superscript: data["superscript"].stringValue, desc: data["desc"].stringValue, discount: data["discount"].doubleValue, discountFee: data["discountFee"].doubleValue, userGoodSuperscript: data["userGoodSuperscript"].intValue,createTime: data["createTime"].stringValue))
            }
            clvGoods.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellGoodsIdentifier, for: indexPath) as! GoodsViewCell

        let tag = tagCell[goodsData[indexPath.item].superscript!]
        let cr = crCell[goodsData[indexPath.item].superscript!]
        if cr != nil {
            cell.frColor = cr
        }else{
            cell.frColor = crDefault
        }
        cell.lblCardNum.text = String.init(format: "%d张",goodsData[indexPath.item].cardNum!)
        cell.lblPrice.text = String.init(format: "¥%.2f", goodsData[indexPath.item].discountFee!)
        let oldStr:String = String.init(format: "¥%.2f", goodsData[indexPath.item].price!)
//        let aStr = NSAttributedString(string: oldStr, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15),NSStrikethroughStyleAttributeName:NSUnderlineStyle.patternSolid])
        cell.lblDiscount.text = String.init(format: "¥%.2f", goodsData[indexPath.item].price!)
//        cell.lblDiscount.attributedText = aStr
        cell.lblSuperscript.text = goodsData[indexPath.item].superscript
        
        if tag != nil {
            let imgTag = UIImageView(image: tag!)
            cell.addSubview(imgTag)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath) as! GoodsViewCell

//        let source = TokenSource()
//        source.token = getSavedToken()
//        let provider = MoyaProvider<NetworkManager>(plugins:[
//            AuthPlugin(tokenClosure: {return source.token})])

        let data = goodsData[indexPath.item]
        print(data.desc)
        
        let payPopup = PopupController
            .create(self)
            .customize([.layout(.bottom)])
        
        let payContainer = PaymentSelection.instance()
        payContainer.closeHandler = { _ in
            payPopup.dismiss()
        }
        payContainer.finishHandler = { result in
            payPopup.dismiss()
            let code = result["code"].intValue
            if code == 200 {
                let dataStr = result["data"].stringValue
                UserDefaults.standard.set(dataStr, forKey: "payURL")
                let payVC = loadVCfromMain(identifier: "doPayView") as! DoPayView
//            let vc = WKWebViewController()
                let str = UserDefaults.standard.string(forKey: "payURL")
            print(str)
            //let urlStr = str?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//            vc.addReferer("https://gatewaytest.xianlaigame.com")
//
//            vc.postWebURLSring(str, postData: nil)

            //vc.loadWebURLSring(urlStr)

            //            payVC.urlData = data
                self.present(payVC, animated: true, completion: nil)
            }else{
                self.toastMSG(result: result)
            }
        }
        payPopup.show(payContainer)
        payDelegate = payContainer.self
        payDelegate?.dataForPay(data: data)
        
        func handlePay(json:JSON)->(){
            let result = json["result"]
            let code = result["code"].intValue
            if code == 200 {
                print(result)
                let dataStr = result["data"].stringValue
                let urlStr = dataStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: urlStr!)
                //            UIApplication.shared.openURL(url!)
                print(url)
                UserDefaults.standard.set(dataStr, forKey: "payURL")
                
                let payVC = loadVCfromMain(identifier: "doPayView") as! DoPayView
                
                //            payVC.urlData = data
                present(payVC, animated: true, completion: nil)
            }else{
                print(result)
                SVProgressHUD.showInfo(withStatus: errMsg.desc(key: code))
            }
        }

        
        func doPayWx(){
            request(.buycardGood(payTypeInchannel: 4, channel: 2, paySource: 4, goodId: data.goodsId!, activityId: data.activityId!), success: handlePay)
        }
        
        func doPayAli(){
            request(.buycardGood(payTypeInchannel: 1, channel: 1, paySource: 9, goodId: data.goodsId!, activityId: data.activityId!), success: handlePay)
        }
        
        let alertPay = UIAlertController(title: "确认付款", message: String.init(format: "¥%.2f", data.price!),
                                                preferredStyle: .actionSheet)
        
        alertPay.view.layer.cornerRadius = 0;
        let wxPayAction = UIAlertAction(title: "微信支付", style: .default, handler: {
        action in
            doPayWx()
//            Network.request(.buycardGood(payTypeInchannel: 4, channel: 2, paySource: 4, goodId: Int(data.goodsId!)!, activityId: data.activityId!), success: self.handlePay, provider: provider)
//            request(.buycardGood(payTypeInchannel: 4, channel: 2, paySource: 4, goodId: Int(data.goodsId!)!, activityId: data.activityId!), success: handlePay)
        })
        let aliPayAction = UIAlertAction(title: "支付宝支付", style: .default, handler: {
        action in
            doPayAli()
//            Network.request(.buycardGood(payTypeInchannel: 1, channel: 1, paySource: 9, goodId: Int(data.goodsId!)!, activityId: data.activityId!), success: self.handlePay, provider: provider)
//            request(.buycardGood(payTypeInchannel: 1, channel: 1, paySource: 9, goodId: Int(data.goodsId!)!, activityId: data.activityId!), success: handlePay)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertPay.addAction(wxPayAction)
        alertPay.addAction(aliPayAction)
        alertPay.addAction(cancelAction)
        //self.present(alertPay, animated: true, completion: nil)
        
    }
    
//    func handlePay(json:JSON)->(){
//        let result = json["result"]
//        let code = result["code"].intValue
//        if code == 200 {
//            print(result)
//            let dataStr = result["data"].stringValue
//            let urlStr = dataStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//            let url = URL(string: urlStr!)
////            UIApplication.shared.openURL(url!)
//            print(url)
//            UserDefaults.standard.set(dataStr, forKey: "payURL")
//
//            let payVC = loadVCfromMain(identifier: "doPayView") as! DoPayView
//            
////            payVC.urlData = data
//            present(payVC, animated: true, completion: nil)
//        }else{
//            print(result)
//            SVProgressHUD.showInfo(withStatus: errMsg.desc(key: code))
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
