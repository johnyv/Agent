//
//  AgentSession.swift
//  Agent
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation

class AgentSession:NSObject {
    
    static let instance = AgentSession.init()
    private override init(){}
    
    var agentModel:AgentInfo?
    var profileModel:ProfileModel?
    
    public static var shared: AgentSession {
        return self.instance
    }
    
    public func isLogin() -> Bool {
        let agentToken = UserDefaults.standard.string(forKey: "agentToken")
        if agentToken == nil {
            return false
        } else {
            return true
        }
    }
    // 其他方法
    
    
}
