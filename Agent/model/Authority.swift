//
//  Authority.swift
//  Agent
//
//  Created by 于劲 on 2017/12/8.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import UIKit

class Authority: NSObject {
    let authorityLv1 = [
        ["buy","购卡"],
        ["sell","售卡"],
        ["create","代理开通"],
        ["tool","工具"],
        ["other","其他"]
    ]

    let authorityLv2 = [
        ["buy_online","线上购卡"],
        ["sell_player","给玩家售卡"],
        ["sell_subagent","给下级代理"],
        ["sell_gameagent","给同游戏内代理"],
        ["create_normalagent","开通普通代理"],
        ["create_subagent","开通下级代理"],
        ["create_vipagent",""],
        ["tool_club","俱乐部"],
        ["tool_playground","代理比赛场"],
        ["tool_data","数据权限"],
        ["other_privilege","特权明细"]
    ]
    func getToolsByAuthority()->([[String]]){
        var tools = [[String]]()
        
        let authority = AgentSession.shared.agentModel?.authorityList
        print(authority)
        if (authority?.contains("tool_club"))! {
            tools.append(["ico_club","俱乐部管理","即将上线"])
        }
        if (authority?.contains("tool_playground"))! {
            tools.append(["ico_match","比赛场管理","即将上线"])
        }

        tools.append(["ico_bounus","积分商城","即将上线"])
        tools.append(["ico_notice_list","公告列表","最新消息都在这"])
        tools.append(["ico_data_center","数据中心","即将上线"])
        if (authority?.contains("create_normalagent"))! || (authority?.contains("create_subagent"))! || (authority?.contains("create_vipagent"))!{
            tools.append(["ico_agent_manager","下级代理管理","开通/禁用"])
        }
        
        return tools
    }
}

let authorityList = Authority()
