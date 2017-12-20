//
//  Construct.swift
//  Agent
//
//  Created by 于劲 on 2017/12/19.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

enum ConstructType {
    case navigation
    case label
    case button
    case text
    case image
}

class Construct {
    
    class func defaultFrame() -> CGRect
    {
        let defaultFrame = CGRect(x: 10, y: 0, width: 100, height: 25)
        return defaultFrame
    }
    
    class func create(type:ConstructType, title:[String], action:Selector, sender:AnyObject) ->UIView{
        switch type {
        case .label:
            return Construct.createLabel(title: title[0])
        default:
            return Construct.createLabel(title: title[0])
        }
    }
    
    class func createLabel(title:String) -> UILabel
    {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.white
        label.text = title
        label.frame = Construct.defaultFrame()
        label.font =  UIFont(name: "System", size: 14)
        return label
    }
    
    class func createTextField(value:String, action:Selector, sender:UITextFieldDelegate) -> UITextField
    {
        let textField = UITextField(frame:Construct.defaultFrame())
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIColor.black
        textField.text = value
        textField.borderStyle = .none
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = sender
        return textField
    }
    
    class func createButton(title:String, action:Selector, sender:UIViewController) -> UIButton {
        let button = UIButton(frame:Construct.defaultFrame())
        button.backgroundColor = UIColor.cyan
        button.setTitle(title, for:.normal)
        button.titleLabel!.textColor = UIColor.white
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(sender, action:action, for:.touchUpInside)
        return button
    }
    
//    class func createNavigationBar(title:String, action:Selector, sender:UIViewController) -> UIButton {
//        let navigationBar = UINavigationBar(frame:Construct.defaultFrame())
//        
//        navigationBar.backgroundColor = UIColor.cyan
//        navigationBar.setTitle(title, for:.normal)
//        navigationBar.titleLabel!.textColor = UIColor.white
//        navigationBar.titleLabel!.font = UIFont.systemFont(ofSize: 14)
//        navigationBar.addTarget(sender, action:action, for:.touchUpInside)
//        return navigationBar
//    }
    
}
