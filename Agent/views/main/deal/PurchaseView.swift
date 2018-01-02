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
import PopupController
import TXScrollLabelView

class PurchaseView: UIViewController {
    var goodsData = [[String:Any]]()
    var descArr = [String]()
    
    let cellGoodsIdentifier = "GoodsCell"

    let crDefault = UIColor(hex: "ff532a")
    
    let crCell = [
        "1st":UIColor(hex: "1aad19"),
        "NEW":UIColor(hex: "ff532a"),
        "HOT":UIColor(hex: "ff9100"),
        "活动":UIColor(hex: "008ce6")
    ]
    
    let tagCell = [
        "1st":UIImage(named: "tag_1st"),
        "NEW":UIImage(named: "tag_period"),
        "HOT":UIImage(named: "tag_special"),
        "活动":UIImage(named: "tag_activity")
    ]
    
    var collectionView: UICollectionView!
    
    var payDelegate:PaymentDelegate?
    
    var scrollLabel:TXScrollLabelView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.title = "房卡商城"
        
        let rightButton = UIBarButtonItem(title: "购卡订单", style: .plain, target: self, action: #selector(ordersList(_:)))
        self.navigationItem.rightBarButtonItem = rightButton
        
        request(.goodList, success: handleData)
        
        //autoFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ordersList(_ sender: Any) {
        let vc = OrdersView()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            let dataArr = result["data"].array
            for(_, element) in (dataArr?.enumerated())!{
                var item:[String:Any] = [:]
                item["goodsId"] = element["goodsId"].intValue
                item["activityId"] = element["activityId"].intValue
                item["cardNum"] = element["cardNum"].intValue
                item["extraNum"] = element["extraNum"].intValue
                item["activityExtraNum"] = element["activityExtraNum"].intValue
                item["price"] = element["price"].floatValue
                item["superscript"] = element["superscript"].stringValue
                item["description"] = element["description"].stringValue
                item["discount"] = element["discount"].doubleValue
                item["discountFee"] = element["discountFee"].doubleValue
                item["userGoodSuperscript"] = element["userGoodSuperscript"].intValue
                item["createTime"] = element["createTime"].stringValue
                
                goodsData.append(item)
            }
            
            for(_, data) in goodsData.enumerated(){
                let desc = data["description"] as? String
                if desc != "" {
                    descArr.append(desc!)
                }
            }
            
            arrangeUI()
            
            collectionView.reloadData()
        }
    }

    func arrangeUI(){
        let lbl1 = addLabel(title: "待充值账号")
        lbl1.frame.origin.y = 5
        
        let line1 = addUnderLine(v: lbl1)
        
        let imgHeadIco = addImageView()
        imgHeadIco.frame.origin.y = line1.frame.origin.y + line1.frame.height + 5
        
        let agent = AgentSession.shared.agentModel
        
        let strURL = agent?.headImg
        if strURL != nil {
            let icoURL = URL(string: strURL!)
            imgHeadIco.sd_setImage(with: icoURL, completed: nil)
        } else {
            imgHeadIco.image = UIImage(named: "headsmall")
        }
        let lblNickName = addLabel(title: "")
        lblNickName.frame.origin.x = imgHeadIco.frame.origin.x + imgHeadIco.frame.width + 5
        lblNickName.frame.origin.y = imgHeadIco.frame.origin.y
        let nickName = agent?.nickName
        lblNickName.text = nickName
        
        let lblAccountID = addLabel(title: "")
        lblAccountID.frame.origin.x = imgHeadIco.frame.origin.x + imgHeadIco.frame.width + 5
        lblAccountID.frame.origin.y = lblNickName.frame.origin.y + lblNickName.frame.height
        
        let accountID = agent?.agentId
        lblAccountID.text = String.init(format: "ID:%d", accountID!)
        
        let div1 = addDivLine(y: imgHeadIco.frame.origin.y + imgHeadIco.frame.height + 5)
        
        let lblGoodsName = addLabel(title: "")

        if descArr.count > 0 {
            let lbl2 = addLabel(title: "促销")
            lbl2.textColor = UIColor(hex: "008ce6")
            lbl2.frame.size = CGSize(width: 35, height: 35)
            lbl2.frame.origin.y =  div1.frame.origin.y + 10
            
            let img1 = addImageView()
            img1.frame.size = CGSize(width: 15, height: 35)
            img1.frame.origin.y =  lbl2.frame.origin.y
            img1.frame.origin.x = lbl2.frame.origin.x + lbl2.frame.width
            img1.image = UIImage(named: "ico_notice")
            img1.contentMode = .center
            scrollLabel = TXScrollLabelView(textArray: descArr, type: .flipNoRepeat, velocity: 2, options: .curveEaseInOut, inset: .zero)
            scrollLabel.frame = CGRect(x: img1.frame.origin.x + img1.frame.width + 5, y: div1.frame.origin.y + 10, width: 100, height: 35)
            scrollLabel.backgroundColor = .white
            scrollLabel.textAlignment = .left
            view.addSubview(scrollLabel)
            scrollLabel.beginScrolling()
            let div2 = addDivLine(y: scrollLabel.frame.origin.y + scrollLabel.frame.height)
            lblGoodsName.frame.origin.y = div2.frame.origin.y + div2.frame.height + 5
        } else {
            lblGoodsName.frame.origin.y = div1.frame.origin.y + div1.frame.height + 5
        }
        
        lblGoodsName.frame.size.width = line1.frame.width
        let gameName = agent?.gameName
        let goodsName = NSMutableAttributedString(string: gameName! + ",请选择充值张数：")
        let range = gameName?.characters.count
        
        goodsName.addAttribute(NSForegroundColorAttributeName, value: UIColor(hex: "008ce6"), range: NSMakeRange(0, range!))
        lblGoodsName.attributedText = goodsName
        
        let line2 = addUnderLine(v: lblGoodsName)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 90)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset.left = 10
        layout.sectionInset.right = 10
        
        let frame = CGRect(x: 0, y: line2.frame.origin.y + 15, width: view.bounds.width, height: view.bounds.height - line2.frame.origin.y - 16)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        let xib = UINib(nibName: "GoodsViewCell", bundle: nil)
        collectionView.register(xib, forCellWithReuseIdentifier: cellGoodsIdentifier)
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

extension PurchaseView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellGoodsIdentifier, for: indexPath) as! GoodsViewCell
        
        let cellData = goodsData[indexPath.item]
        let key = cellData["superscript"] as! String

        let tag = tagCell[key]
        let cr = crCell[key]
        
        if cr != nil {
            cell.frColor = cr
        }else{
            cell.frColor = crDefault
        }
        
        let cardNum:Int = cellData["cardNum"] as! Int
        let extraNum:Int = cellData["extraNum"] as! Int
        let activityExtraNum:Int = cellData["activityExtraNum"] as! Int
        let count = cardNum + extraNum + activityExtraNum
        
        cell.lblCardNum.text = String.init(format: "%d张", count)
        cell.lblPrice.text = String.init(format: "¥%.2f", cellData["discountFee"] as! Double)
        let oldStr:String = String.init(format: "¥%.2f", cellData["price"] as! Float)
        
        let aStr = NSMutableAttributedString(string: oldStr)
        let propertys:[String:Any] = [NSForegroundColorAttributeName:UIColor.red,NSStrikethroughStyleAttributeName: NSNumber.init(value:Int32(NSUnderlineStyle.styleSingle.rawValue)),NSBaselineOffsetAttributeName:Int(0)]
        aStr.addAttributes(propertys, range: NSMakeRange(0, oldStr.characters.count))
        
        cell.lblDiscount.attributedText = aStr
        
        let script = cellData["userGoodSuperscript"] as! Int
        
        if script == 1{
            cell.lblSuperscript.isHidden = false
            cell.lblSuperscript.text = "新手专属"
            cell.lblSuperscript.textColor = UIColor(hex: "1aad19")
        } else if script == 2{
            cell.lblSuperscript.isHidden = false
            cell.lblSuperscript.text = String.init(format: "VIP享%.1f折", cellData["discount"] as! Double)
            cell.lblSuperscript.textColor = UIColor(hex: "ff532a")
        } else {
            cell.lblSuperscript.isHidden = true
        }
        
        if tag != nil {
            let imgTag = UIImageView(image: tag!)
            cell.addSubview(imgTag)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = goodsData[indexPath.item]
        
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
                let vc = DoPayView()
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.toastMSG(result: result)
            }
        }
        _ = payPopup.show(payContainer)
        payDelegate = payContainer.self
        payDelegate?.dataForPay(data: data)
    }
}
