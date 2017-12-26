//
//  CatchCrash.swift
//  Agent
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

private let catchCrash = CatchCrash()
private var UncaughtExceptionCount: Int32 = 0
private var UncaughtExceptionMaximum: Int32 = 10
class CatchCrash: NSObject {
    private let UncaughtExceptionMaximum: Int32 = 10
    
    private let SignalHandler: Darwin.sig_t? = { (signal) in
        let exceptionInfo = HandleCrash.crash(signal)
        try! exceptionInfo?.write(toFile: NSHomeDirectory() + "/Documents/error1.log", atomically: true, encoding: .utf8)
    }
    
    class func share() -> CatchCrash {
        return catchCrash
    }
    
    func installUncaughtExceptionHandler() {
        
        NSSetUncaughtExceptionHandler { (exception) in
            // 异常的堆栈信息
            let stackArray = exception.callStackSymbols
            
            // 出现异常的原因
            let reason = exception.reason
            
            // 异常名称
            let name = exception.name
            
            let exceptionInfo = "Eqqqqqxception reason：\(String(describing: reason))\n"
                + "Exception name：\(name)\n"
                + "Exception stack：\(stackArray.description)"
            
            print("------exceptionInfo" + exceptionInfo)
            
            var tmpArr = stackArray
            tmpArr.insert(reason!, at: 0)
            
            //保存到本地
            try! exceptionInfo.write(toFile: NSHomeDirectory() + "/Documents/error1.log", atomically: true, encoding: .utf8)
            abort()
        }
        
        signal(SIGABRT, SignalHandler)
        signal(SIGILL, SignalHandler)
        signal(SIGSEGV, SignalHandler)
        signal(SIGFPE, SignalHandler)
        signal(SIGBUS, SignalHandler)
        signal(SIGPIPE, SignalHandler)
    }
}
