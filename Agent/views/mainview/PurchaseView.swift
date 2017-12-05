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

class PurchaseView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var goodsData = [PurchaseCellModel]()
    let cellGoodsIdentifier = "GoodsCell"
    @IBOutlet weak var clvGoods: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clvGoods.delegate = self
        clvGoods.dataSource = self
        
        let xib = UINib(nibName: "GoodsViewCell", bundle: nil)
        clvGoods.register(xib, forCellWithReuseIdentifier: cellGoodsIdentifier)
        
        let source = TokenSource()
        source.token = getSavedToken()
        let provider = MoyaProvider<NetworkManager>(plugins:[
            AuthPlugin(tokenClosure: {return source.token})])
        
        Network.request(.goodList, success: handleData, provider: provider)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPrev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func listOrders(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ordersView") as? OrdersView
        present(vc!, animated: true, completion: nil)
    }
    
    fileprivate func handleData(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            let dataArr = result["data"].array
            for(_, data) in (dataArr?.enumerated())!{
                goodsData.append(PurchaseCellModel(goodsId: data["goodsId"].stringValue, activityId: data["activityId"].intValue, cardNum: data["cardNum"].stringValue, extraNum: data["extraNum"].intValue, activityExtraNum: data["activityExtraNum"].intValue, price: data["price"].stringValue, superscript: data["superscript"].stringValue, desc: data["desc"].stringValue, createTime: data["createTime"].stringValue))
            }
            clvGoods.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellGoodsIdentifier, for: indexPath) as! GoodsViewCell
        cell.lblCardNum.text = goodsData[indexPath.item].cardNum
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath) as! GoodsViewCell

        let source = TokenSource()
        source.token = getSavedToken()
        let provider = MoyaProvider<NetworkManager>(plugins:[
            AuthPlugin(tokenClosure: {return source.token})])

        let data = goodsData[indexPath.item]
        print(data.desc)
        let alertPay = UIAlertController(title: "确认付款", message: "¥"+data.price!,
                                                preferredStyle: .actionSheet)
        
        alertPay.view.layer.cornerRadius = 0;
        let wxPayAction = UIAlertAction(title: "微信支付", style: .default, handler: {
        action in
            Network.request(.buycardGood(payTypeInchannel: 4, channel: 2, paySource: 4, goodId: Int(data.goodsId!)!, activityId: data.activityId!), success: self.handlePay, provider: provider)
        })
        let aliPayAction = UIAlertAction(title: "支付宝支付", style: .default, handler: {
        action in
            Network.request(.buycardGood(payTypeInchannel: 1, channel: 1, paySource: 9, goodId: Int(data.goodsId!)!, activityId: data.activityId!), success: self.handlePay, provider: provider)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertPay.addAction(wxPayAction)
        alertPay.addAction(aliPayAction)
        alertPay.addAction(cancelAction)
        self.present(alertPay, animated: true, completion: nil)
        
    }
    
    func handlePay(json:JSON)->(){
        let result = json["result"]
        let code = result["code"].intValue
        if code == 200 {
            print(result)
            let data = result["data"].stringValue
            let url = URL(string: data)
            print(url)
            UserDefaults.standard.set(data, forKey: "payURL")

            let payVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "externalPayView") as! ExternalPayView
            
            payVC.urlData = data
            present(payVC, animated: true, completion: nil)
        }else{
            print(result)
            SVProgressHUD.showInfo(withStatus: errMsg.desc(key: code))
        }
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
