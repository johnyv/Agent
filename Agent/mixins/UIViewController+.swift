//
//  UIViewController+Alert.swift
//  Agent
//
//  Created by 于劲 on 2017/12/7.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Toast_Swift
import SVProgressHUD

extension UIViewController{
    func alertResult(code:Int) -> Void {
        let alertController = UIAlertController(title: "系统提示",message: errMsg.desc(key: code), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func toastMSG(result:JSON) -> Void {
        let msg = result["message"].stringValue
        self.view.makeToast(msg, duration: 2, position: .center)
    }
    
    func showToast(string:String) -> Void {
        UIApplication.shared.windows.first?.makeToast(string, duration: 2, position: .center)
    }

    func request(_ target:NetworkManager,
                                       success successCallback: @escaping(JSON) -> Void
        //error errorCallback: @escaping(Int) -> Void,
        //failure failureCallback: @escaping(MoyaError) -> Void
        ){

        SVProgressHUD.show()
        
        let source = TokenSource()
        source.token = getSavedToken()
        let provider = MoyaProvider<NetworkManager>(plugins:[AuthPlugin(tokenClosure: {return source.token})])

        func handleError(statusCode: Int) -> () {
            //服务器报错等问题
            print("请求错误！错误码：\(statusCode)")
            
            let alertController = UIAlertController(title: "网络错误",message: "请求错误！错误码：\(statusCode)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

        }
        
        func handleFailure(error: MoyaError) -> () {
            //没有网络等问题
            print("请求失败！错误信息：\(error.errorDescription ?? "")")
            let alertController = UIAlertController(title: "网络错误",message: "请求失败！错误信息：\(error.errorDescription ?? "")", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }

        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    //如果数据返回成功则直接将结果转为JSON
                    try response.filterSuccessfulStatusCodes()
                    let json = try JSON(response.mapJSON())
                    SVProgressHUD.dismiss()
                    successCallback(json)
                }
                catch let error {
                    //如果数据获取失败，则返回错误状态码
                    SVProgressHUD.dismiss()
                    handleError(statusCode: (error as! MoyaError).response!.statusCode)
                }
            case let .failure(error):
                //如果连接异常，则返沪错误信息（必要时还可以将尝试重新发起请求）
                //服务器报错等问题
                SVProgressHUD.dismiss()
                handleFailure(error: error)
            }
        }
    }
    
//    func autoFit(v:UIView){
//        let radio:CGFloat = UIScreen.main.bounds.width / 375.0
//
//        fitRadio(v: v, radio: radio)
//        for(_, view) in v.subviews.enumerated(){
//            if view.subviews.count > 0 {
//                let subviews = view.subviews
//                for(_, view) in subviews.enumerated(){
//                    fitRadio(v: view, radio: radio)
//                }
//            }
//            fitRadio(v: view, radio: radio)
//        }
//    }
//    
//    private func fitRadio(v:UIView, radio:CGFloat){
//        if v.isKind(of: UINavigationBar.self) {
//            return
//        }
//        v.autoresizesSubviews = true
//        v.frame.origin.x *= radio
//        v.frame.origin.y *= radio
//        v.frame.size.width *= radio
//        v.frame.size.height *= radio
//    }

    private func defaultX() ->CGFloat {
        let width = UIScreen.main.bounds.width * 0.9
        let x = (UIScreen.main.bounds.width - width) / 2
        return x
    }
    
    private func defaultFrame() -> CGRect
    {
        let width = UIScreen.main.bounds.width * 0.9
        let x = (UIScreen.main.bounds.width - width) / 2
        let defaultFrame = CGRect(x: x, y: 0, width: 150, height: 25)
        return defaultFrame
    }

    func addUnderLine(v:UIView) -> UIView{
        let width = UIScreen.main.bounds.width * 0.9
        let x = (UIScreen.main.bounds.width - width) / 2
        let y = v.frame.origin.y + v.frame.height + 5
        let line = UIView(frame: CGRect(x: x, y: y, width: width, height: 0.5))
        line.backgroundColor = UIColor(hex: "cccccc")
        view.addSubview(line)
        return line
    }
    
    func addDivLine(y:CGFloat) -> UIView{
        let width = UIScreen.main.bounds.width
        let line = UIView(frame: CGRect(x: 0, y: y, width: width, height: 5))
        line.backgroundColor = UIColor.init(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1)
        view.addSubview(line)
        return line
    }

    func addNavigationBar(title:String) -> UINavigationBar{
        var navigationBar:UINavigationBar?
        
        let width = UIScreen.main.bounds.width
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 64))
        
        let navigationItem = UINavigationItem()
        navigationItem.title = title
        let leftButton = UIBarButtonItem(image: UIImage(named: "ico_back"), style: .plain, target: self, action: #selector(onBack(_:)))
        navigationItem.setLeftBarButton(leftButton, animated: true)
        navigationBar?.pushItem(navigationItem, animated: true)
        
        view.addSubview(navigationBar!)
        
        return navigationBar!
    }
    
    func addBackButtonToNavBar(){
        let leftButton = UIBarButtonItem(image: UIImage(named: "ico_back"), style: .plain, target: self, action: #selector(onBack(_:)))
        navigationItem.setLeftBarButton(leftButton, animated: true)
    }
    
    func addLabel(title:String) -> UILabel
    {
        let label = UILabel()
        label.textColor = UIColor(hex: "565656")
        label.backgroundColor = UIColor.clear
        label.text = title
        label.frame = defaultFrame()
        label.font = .systemFont(ofSize: 16)
        view.addSubview(label)
        return label
    }
    
    func addTextField(placeholder:String) -> UITextField
    {
        let textField = UITextField(frame:defaultFrame())
        textField.frame.size.width = 155
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.textAlignment = .center
        view.addSubview(textField)
        return textField
    }
    
    func addButton(title:String, action:Selector) -> UIButton {
        let button = UIButton(frame:defaultFrame())
        button.backgroundColor = UIColor.lightGray
        button.setTitle(title, for:.normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action:action, for:.touchUpInside)
        view.addSubview(button)
        return button
    }

    func addSmsButton(title:String, action:Selector) -> SMSCountButton {
        let button = SMSCountButton(frame:defaultFrame())
        button.backgroundColor = UIColor.clear
        button.setTitle(title, for:.normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor(hex: "008ce6"), for: .normal)
        button.addTarget(self, action:action, for:.touchUpInside)
        view.addSubview(button)
        return button 
    }

    func addImageView() -> UIImageView {
        let frame = CGRect(x: defaultX(), y: 0, width: 56, height: 56)
        let imageView = UIImageView(frame: frame)
        view.addSubview(imageView)
        return imageView
    }
    
    func alignUIView(v:UIView, position:UIViewContentMode){
        let screenW = UIScreen.main.bounds.width
        let viewWidth = v.frame.width
        switch position {
        case .center:
            v.frame.origin.x = (screenW - viewWidth)/2
        case .right:
            v.frame.origin.x = screenW * 0.9 - viewWidth
        default:
            break
        }
    }
    
    func onBack(_ sender:Any){
        dismiss(animated: true, completion: nil)
    }
    
}
