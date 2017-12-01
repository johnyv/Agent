//
//  NetworkManager.swift
//  Agent
//
//  Created by 于劲 on 2017/11/16.
//  Copyright © 2017年 xianlai. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

enum NetworkManager{
    //------------------
    //用户中心
    case login(String, String) //用户账户密码登录接口
    case loginByMobile(String, String, String) //用户手机号登录接口
    case sms(String, String, Int) //获取手机短信验证码
    case refresh //刷新token接口
    //------------------
    //基础&核心服务
    case gameInfo(serverCode:String)
    case banner //查询banner
    case agreement //查询协议
    case affirm(agreementId:Int) //确认协议
    case noticeScroll //查询首页公告区域公告
    case noticeList(page:Int, pageSize:Int) //查询公告列表
    case noticeDetail(noticeId:Int) //查询公告详情
    case myagent(agentType:Int, page:Int, pageSize:Int) //查询我的代理列表
    case myagentInfo(subAgentId:Int) //查询我的代理详情
    case updateRemark(subAgentId:Int, remark:String) //修改我的代理备注
    case myagentNew(name:String, userId:Int, tel:String, roleIde:Int, vipAgentOpenLimit:Int, normalAgentOpenLimit:Int, subAgentOpenLimit:Int, validityPeriod:String) //开通代理
    case agentSwitch(agentId:Int, enable:String) //启用，禁用代理
    case pwdChange(pwd:String, rpwd:String) //修改密码
    case myInfo //查询当前代理信息
    case editHI(headerImgSrc:String) //修改头像
    case editNick(nickName:String) //修改昵称
    case typeInfo //查询特权信息
    case bind(tel:String, verificationCode:String) //绑定安全手机
    //编辑安全手机
    case inviteGet //邀请玩家
    case inviteList(page:Int, pageSize:Int) //查询邀请玩家列表
    //------------------
    //购卡服务
    case goodList //查询房卡列表接口
    case goodDetail(time:String, page:Int) //查询购卡明细
    case goodDetailCollect(time:String) //查询购卡张数／次数接口
    case check //点击房卡校验接口
    case good(payTypeInchannel:Int, channel:Int, paySource:Int, goodId:Int, activityId:Int) //支付接口
    case unpaidTopay(orderNo:String) //待支付订单支付接口
    //------------------
    //售卡服务
    case sellcardToPlayer(playerID:Int, number:Int) //1给玩家售卡接口
    case sellcardToAgent(agentID:Int, number:Int) //2给下级代理售卡接口
    case statisticAllNum(time:String) //3查询售卡张数
    case statisticList(time:String, sortType:Int, pageIndex:Int, pageNum:Int) //4查询售卡明细
    case customerAllNum(searchId:Int, startDate:Int, endDate:Int) //5售卡人数/人次统计
    case customerRecently(searchId:Int, startDate:Int, endDate:Int, sortType:Int, pageIndex:Int, pageNum:Int) //6最近售卡/某玩家明细
    case customerTotallist(searchId:Int, startDate:Int, endDate:Int, sortType:Int, pageIndex:Int, pageNum:Int) //7售卡次数/张数
    case recentlyPlayer(searchId:Int, startDate:Int, endDate:Int, sortType:Int, pageIndex:Int, pageNum:Int) //8最近售卡的玩家
    case recentlyAgent(searchId:Int, startDate:Int, endDate:Int, sortType:Int, pageIndex:Int, pageNum:Int) //9最近售卡的代理
    case playerSearch(searchId:Int) //10查询玩家信息
    case agentSearch(searchId:Int) //11查询代理信息
    case agentCheck(searchId:Int) //12查询代理信息
    //------------------
    //支付中心
    case cancel(orderNo:String) //取消待支付订单接口
    case orderlist(year:String, month:String, page:String, type:String) //订单查询接口
}

class TokenSource{
    var token:String?
    init(){}
}

protocol AuthorizedTargetType: TargetType {
    var needsAuth: Bool { get }
}

struct AuthPlugin: PluginType {
    let tokenClosure: () -> String?
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard
            let token = tokenClosure(),
            let target = target as? AuthorizedTargetType,
            target.needsAuth
            else {
                return request
        }
        
        var request = request
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
}

extension NetworkManager: AuthorizedTargetType{
    var baseURL:URL{
        return URL(string: "https://gatewaytest.xianlaigame.com")!
    }

    var path:String{
        switch self{
        case .login(_,_):
            return "/api/auth/login"
        case .loginByMobile(_, _, _):
            return "/api/auth/loginByMobile"
        case .sms(_, _, _):
            return "/api/auth/sms"
        case .refresh:
            return "/api/auth/refresh"
            
        case .banner:
            return "/api/agent/core/banner/list"
        case.agreement:
            return "/api/agent/core/agreement/get"
        case .affirm(_):
            return "/api/agent/core/agreement/affirm"
        case .noticeScroll:
            return "/api/agent/core/notice/scroll"
        case .noticeList(_, _):
            return "/api/agent/core/notice/list"
        case .noticeDetail(_):
            return "/api/agent/core/notice/detail"
            
        case .goodList:
            return "/api/agent/buycard/goodList"
        case .goodDetail(_, _):
            return "/api/agent/buycard/goodDetail"
        case .goodDetailCollect(_):
            return "/api/agent/buycard/goodDetailCollect"
        //------------------
        //售卡服务
        case .customerAllNum(_, _, _):
            return "/api/agent/sellcard/customer/allNum"
        case .customerRecently(_, _, _, _, _, _):
            return "/api/agent/sellcard/recently/player"
        case .customerTotallist(_, _, _, _, _, _):
            return "/api/agent/sellcard/customer/totallist"
        //------------------
        //支付中心
        case.cancel:
            return "/api/agent/pay/processing/cancel"
        case .orderlist:
            return "/api/agent/pay/processing/orderlist"
        default:
            return ""
        }
    }
    
    var method:Moya.Method{
        switch self {
        case .refresh:
            return .get
        default:
            return .post
        }
    }
    
    public var task:Task{
        switch self {
        case .login(let usr, let pwd):
            var params:[String:Any] = [:]
            params["username"] = usr//"18500206220"
            params["password"] = pwd//"Assassin1"
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .cancel(let orderNo):
            var params:[String:Any] = [:]
            params["orderNo"] = orderNo
            return .requestParameters(parameters: params, encoding: DataEncoding.default)
        case .orderlist(let year, let month, let page, let type):
            var params:[String:Any] = [:]
            params["year"] = year
            params["month"] = month
            params["page"] = page
            params["type"] = type
            return .requestParameters(parameters: params, encoding: DataEncoding.default)
        // 售卡服务
        case .customerAllNum(let searchId, let startDate, let endDate):
            var data:[String:Any] = [:]
            if searchId != 0{
                data["searchId"] = searchId
            }
            if startDate != 0 {
                data["startDate"] = startDate
            }
            if endDate != 0 {
                data["endDate"] = endDate
            }
            
            return .requestParameters(parameters: data, encoding: DataEncoding.default)
        case .customerRecently(let searchId, let startDate, let endDate, let sortType, let pageIndex, let pageNum),
             .customerTotallist(let searchId, let startDate, let endDate, let sortType, let pageIndex, let pageNum):
            
            var data:[String:Any] = [:]
            if searchId != 0{
                data["searchId"] = searchId
            }
            if startDate != 0 {
                data["startDate"] = startDate
            }
            if endDate != 0 {
                data["endDate"] = endDate
            }
            if searchId != 0{
                data["sortType"] = sortType
            }
            if startDate != 0 {
                data["pageIndex"] = pageIndex
            }
            if endDate != 0 {
                data["pageNum"] = pageNum
            }

            return .requestParameters(parameters: data, encoding: DataEncoding.default)
            
        case .refresh:
            return .requestPlain
            
        default:
            let params:[String:Any] = [:]
            return .requestParameters(parameters: params, encoding: DataEncoding.default)
        }
    }
    
    public var validate:Bool{
        return false
    }
    
    public var sampleData: Data{
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var headers:[String:String]?{
//        switch self{
//        case .login, .refresh:
            return ["Content-Type" : "application/json"]
//        default:
//            return ["Content-Type" : "application/octet-stream"]
//        }
    }
    
    public var needsAuth: Bool {
        switch self {
        case .login:
            return false
        default:
            return true
        }
    }
}

func handleError(statusCode: Int) -> () {
    //服务器报错等问题
    print("请求错误！错误码：\(statusCode)")
}

func handleFailure(error: MoyaError) -> () {
    //没有网络等问题
    print("请求失败！错误信息：\(error.errorDescription ?? "")")
}

struct Network {
    
    static func request(_ target:NetworkManager,
                        success successCallback: @escaping(JSON) -> Void,
//                        error errorCallback: @escaping(Int) -> Void,
//                        failure failureCallback: @escaping(MoyaError) -> Void,
                        provider:MoyaProvider<NetworkManager>){
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    //如果数据返回成功则直接将结果转为JSON
                    try response.filterSuccessfulStatusCodes()
                    let json = try JSON(response.mapJSON())
                    successCallback(json)
                }
                catch let error {
                    //如果数据获取失败，则返回错误状态码
                    handleError(statusCode: (error as! MoyaError).response!.statusCode)
                }
            case let .failure(error):
                //如果连接异常，则返沪错误信息（必要时还可以将尝试重新发起请求）
                handleFailure(error: error)
            }
        }
    }
}
