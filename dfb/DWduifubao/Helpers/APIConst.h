//
//  APIConst.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/10.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

///act+api
extern  NSString * const ACT_API;
///请求验证码
extern NSString * const  Request_Code ;
///注册
extern NSString * const  Request_Register;
///登录
extern NSString * const  Request_Login ;
///修改密码
extern NSString * const  Request_Pwd ;
///设置支付密码
extern NSString * const  Request_SetPayPassword ;
///获取个人信息
extern NSString * const  Request_UserInfo ;
///关注/取消商品
extern NSString * const  Request_CollectGoods ;
///商品图文介绍
extern NSString * const  Request_GoodsContent ;
///商品详情
extern NSString * const  Request_GoodsInfo ;
///请求最新的版本号
extern NSString * const  Request_VersionUpdate ;

/// 生成支付订单
extern NSString * const  Request_RechargeDfbao ;
///18.2 兑富币充值
extern NSString * const  Request_RechargeVirtualGlod ;

///意见反馈
extern NSString * const  Request_Feedback ;
///获取收货地址列表
extern NSString * const  Request_AddressList ;
///添加收货地址
extern NSString * const  Request_AddAddress ;
/// 删除收货地址
extern NSString * const  Request_DelAddress;
/// 修改收货地址
extern NSString * const  Request_UpdateAddress ;
/// 设置默认收货地址
extern NSString * const  Request_SetDefaultAddress ;
/// 创业会员在线购买(兑富金币)
extern NSString * const  Request_PayEntrepreneurship ;
/// 18.1 升级创业会员（现金+兑富币）
extern NSString * const  Request_Upgrade ;
/// 创业会员实名认证
extern NSString * const  Request_Certification ;
///修改个人信息
extern NSString * const  Request_UpdateUserInfo;
///获取增票资质列表
extern NSString * const  Request_BillList;
///实名认证资料
extern NSString * const  Request_CertificationInfo ;
///获取开店资料
extern NSString * const  Request_GetShopInfo;
///实名认证资料
extern NSString * const  Request_ScoreList;
///  积分兑换兑富币/兑富币+兑富宝
extern NSString * const  Request_ScoreExchange ;
///  兑富宝列表
extern NSString * const  Request_VirtualGlodList ;
///现金列表
extern NSString * const  Request_CashList ;
///  获取银行卡信息
extern NSString * const  Request_BankInfo;
///   提现申请
extern NSString * const  Request_ApplyDraw ;
///   修改银行卡
extern NSString * const  Request_UpdateBank;
///获取用户注册会员详情
extern NSString * const  Request_getUserMerberInfo ;
///  更换手机号码
extern NSString * const  Request_ChangePhone ;
/// 配置信息
extern NSString * const  Request_Config;
 /// 其他配置
extern NSString * const  Request_otherConfig ;
///  完善开店资料
extern NSString * const  Request_CompleteShopInfo;
///   开屏广告
extern NSString * const  Request_Ad ;
///   获取首页店铺列表
extern NSString * const  Request_MerchantList ;
///申请区域代理
extern NSString * const  Request_ApplyAreaAgency;
///区域代理列表
extern NSString * const  Request_AreaAgencyList ;
///获取行业分类
extern NSString * const  Request_IndustryList ;
///获取分类
extern NSString * const  Request_C2cCategoryList;
/// 获取我的店铺
extern NSString * const  Request_MerchantInfo ;
/// 商品评价列表
extern NSString * const  Request_CommentList ;
/// 14.18 添加购物车
extern NSString * const  Request_AddCart;
///14.24 订单支付
extern NSString * const  Request_PayGoodsOrder;
/// 14.31 确认收货
extern NSString * const  Request_ConfirmReceive;
/// 14.22 新建订单
extern NSString * const  Request_GoodsOrder;
/// 14.32 请求订单运费
extern NSString * const  Request_OrderFreight ;
///14.26 订单详情
extern NSString * const  Request_OrderInfo ;
///14.28 添加评价
extern NSString * const  Request_Comment ;
/// 14.27 查看物流
extern NSString * const  Request_Logistics ;
/// 14.25 我的订单列表
extern NSString * const  Request_MyOrderList;
/// 获取店铺信息
extern NSString * const  Request_MyMerchantInfo;
///  消息列表
extern NSString * const  Request_MessageList ;
/// 关注/取消关注店铺
extern NSString * const  Request_CollectMerchant ;
///关注的店铺
extern NSString * const  Request_MerchantCollectList ;
///14.17 关注的商品列表
extern NSString * const  Request_GoodsCollectList ;
///获取金额
extern NSString * const  Request_Money ;
/// 获取收款列表
extern NSString * const  Request_PayOrderList ;
/// 获取收款 方式列表
extern NSString * const  Request_PayConfigList ;
/// 获取提现方式列表
extern NSString * const  Request_DrawConfigList ;
/// O2O收款
extern NSString * const  Request_PayOrder ;
/// 资道登录验证
extern NSString * const  Request_CkZidaoGathering ;
/// 已做登录验证，返回结果参照19.6
extern NSString * const  Request_ZidaoDraw ;
/// 资道实名认证
extern NSString * const  Request_ZidaoCertification  ;
///  获取资道实名认证资料
extern NSString * const  Request_ZidaoCertificationInfo  ;
///   设置手势密码/验证
extern NSString * const  Request_HandlePassword;
///   设置手势密码/验证
extern NSString * const  Request_CheckVerifyCode  ;
///  商品列表
extern NSString * const  Request_GoodsList  ;
///  获取首页
extern NSString * const  Request_Homepage  ;
///   获取购物车商品
extern NSString * const  Request_CartList  ;
///   修改购物车商品
extern NSString * const  Request_ChangeCart  ;
///   删除购物车商品
extern NSString * const  Request_UpdateCartList ;
///   我的服务
extern NSString * const  Request_MyService ;
///   我的服务->文章列表
extern NSString * const  Request_MyArticle ;
///   文章详情
extern NSString * const  Request_Detail;
///   文章详情-按类型（注册协议/权益说明）
extern NSString * const  Request_DetailByType ;
///   问题与帮助/我要开店文章标题列表
extern NSString * const  Request_ListByType ;
///   配置信息
extern NSString * const  Request_config ;
///   我要办卡/我要贷款列表
extern NSString * const  Request_ApplyInfoList ;
///   现金兑换兑富币
extern NSString * const  Request_CashExchange  ;
///  14.23 取消订单
extern NSString * const  Request_CancelOrder;


///8.1  首页轮播图片+喇叭中奖消息(最新10条)
extern NSString * const  Request_DbBannerBornList;
/// 8.2 一元购获取分类
extern NSString * const  Request_DbCategoryList;
///8.5 一元购获取筛选商品
extern NSString * const  Request_DbGoodsList;
/// 8.6 一元购获取商品详情
extern NSString * const  Request_DbGoodsInfo;
///8.7  获取往期揭晓记录
extern NSString * const  Request_TimesRecord;

///8.8获取本期所有参与记录
extern NSString * const  Request_DbJoinList;


///8.9 晒单分享
extern NSString * const  Request_DbCommentList;
///8.10 支付
extern NSString * const  Request_DbPayOrder;

///8.11 我的夺宝记录
extern NSString * const  Request_DbMyOrderList;
///8.12 获奖者发表评价
extern NSString * const  Request_DbAddComment;
///8.13 我的晒单记录
extern NSString * const  Request_DbMyCommentList;

///8.14 幸运号码列表
extern NSString * const  Request_DbLuckNoList;
///8.15 当期订单列表（计算结果）
extern NSString * const  Request_DbOrderCalList;
