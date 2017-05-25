//
//  APIConst.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/10.
//  Copyright © 2017年 bianming. All rights reserved.
//


///act+api

NSString * const ACT_API = @"act=Api";
///请求验证码
NSString * const  Request_Code = @"/VerifyCode/requestVerifyCode";
///注册
NSString * const  Request_Register  = @"/User/requestRegister";
///登录
NSString * const  Request_Login = @"/User/requestLogin";
///修改密码
NSString * const  Request_Pwd  = @"/User/requestForgottenPassword";
///设置支付密码
NSString * const  Request_SetPayPassword = @"/User/requestSetPayPassword";
///获取个人信息
NSString * const  Request_UserInfo = @"/User/requestUserInfo";
///关注/取消商品
NSString * const  Request_CollectGoods = @"/User/requestCollectGoods";
///商品图文介绍
NSString * const  Request_GoodsContent = @"/Mall/requestGoodsContent";
///商品详情
NSString * const  Request_GoodsInfo = @"/Mall/requestGoodsInfo";

///请求最新的版本号
NSString * const  Request_VersionUpdate = @"/Version/requestVersionUpdate";
/// 生成支付订单
NSString * const  Request_RechargeDfbao = @"/User/requestRechargeDfbao";
///18.2 兑富币充值
NSString * const  Request_RechargeVirtualGlod = @"/User/requestRechargeVirtualGlod";

///意见反馈
NSString * const  Request_Feedback = @"/Feedback/requestFeedback";
///获取收货地址列表
NSString * const  Request_AddressList = @"/Address/requestAddressList";
///添加收货地址
NSString * const  Request_AddAddress = @"/Address/requestAddAddress";
/// 删除收货地址
NSString * const  Request_DelAddress = @"/Address/requestDelAddress";
/// 修改收货地址
NSString * const  Request_UpdateAddress = @"/Address/requestUpdateAddress";
/// 设置默认收货地址
NSString * const  Request_SetDefaultAddress = @"/Address/requesSetDefaultAddress";
/// 创业会员在线购买(兑富金币)
NSString * const  Request_PayEntrepreneurship = @"/Entrepreneurship/requestPayEntrepreneurship";
/// 18.1 升级创业会员（现金+兑富币）
NSString * const  Request_Upgrade = @"/Entrepreneurship/requestUpgrade";
/// 创业会员实名认证
NSString * const  Request_Certification = @"/Entrepreneurship/requestCertification";
///修改个人信息
NSString * const  Request_UpdateUserInfo = @"/User/requestUpdateUserInfo";
///获取增票资质列表
NSString * const  Request_BillList = @"/Bill/requestBillList";
///实名认证资料
NSString * const  Request_CertificationInfo = @"/Entrepreneurship/requestCertificationInfo";
///获取开店资料
NSString * const  Request_GetShopInfo  = @"/Entrepreneurship/requestShopInfo";
///实名认证资料
NSString * const  Request_ScoreList = @"/Score/requestScoreList";
///  积分兑换兑富币/兑富币+兑富宝
NSString * const  Request_ScoreExchange = @"/Score/requestScoreExchange";
///  兑富宝列表
NSString * const  Request_VirtualGlodList = @"/Score/requestVirtualGlodList";
///现金列表
NSString * const  Request_CashList  = @"/Score/requestCashList";
///  获取银行卡信息
NSString * const  Request_BankInfo = @"/Finance/requestBankInfo";
///   提现申请
NSString * const  Request_ApplyDraw = @"/Finance/requestApplyDraw";
///   修改银行卡
NSString * const  Request_UpdateBank = @"/Finance/requestUpdateBank";
///获取用户注册会员详情
NSString * const  Request_getUserMerberInfo = @"/User/getUserMerberInfo";
///  更换手机号码
NSString * const  Request_ChangePhone = @"/User/requestChangePhone";
/// 配置信息
NSString * const  Request_Config = @"/System/config";
/// 其他配置
NSString * const  Request_otherConfig = @"/System/otherConfig";
///  完善开店资料
NSString * const  Request_CompleteShopInfo = @"/Entrepreneurship/requestCompleteShopInfo";
///   开屏广告
NSString * const  Request_Ad = @"/Ad/requestAd";
///   获取首页店铺列表
NSString * const  Request_MerchantList = @"/Merchant/requestMerchantList";
///申请区域代理
NSString * const  Request_ApplyAreaAgency = @"/Agency/requestApplyAreaAgency";
///区域代理列表
NSString * const  Request_AreaAgencyList = @"/Agency/requestAreaAgencyList";
///获取行业分类
NSString * const  Request_IndustryList = @"/Industry/requestIndustryList";
///获取分类
NSString * const  Request_C2cCategoryList = @"/C2CCategory/requestC2cCategoryList";
/// 获取我的店铺
NSString * const  Request_MerchantInfo = @"/Merchant/requestMerchantInfo";;
/// 商品评价列表
NSString * const  Request_CommentList = @"/Mall/requestCommentList";
/// 14.18 添加购物车
NSString * const  Request_AddCart = @"/Cart/requestAddCart";
///14.24 订单支付
NSString * const  Request_PayGoodsOrder = @"/Mall/requestPayGoodsOrder";
/// 14.31 确认收货
NSString * const  Request_ConfirmReceive = @"/Mall/requestConfirmReceive";
/// 14.22 新建订单
NSString * const  Request_GoodsOrder = @"/Mall/requestGoodsOrder";
/// 14.32 请求订单运费
NSString * const  Request_OrderFreight = @"/Mall/requestOrderFreight" ;
///14.26 订单详情
NSString * const  Request_OrderInfo = @"/Mall/requestOrderInfo";
///14.28 添加评价
NSString * const  Request_Comment = @"/Mall/requestComment";
/// 14.27 查看物流
NSString * const  Request_Logistics = @"/Mall/requestLogistics";
/// 14.25 我的订单列表
NSString * const  Request_MyOrderList = @"/Mall/requestMyOrderList";
/// 获取店铺信息
NSString * const  Request_MyMerchantInfo = @"/Merchant/requestMyMerchantInfo";
///  消息列表
NSString * const  Request_MessageList  = @"/Message/requestMessageList";
/// 关注/取消关注店铺
NSString * const  Request_CollectMerchant = @"/User/requestCollectMerchant";
///关注的店铺
NSString * const  Request_MerchantCollectList = @"/User/requestMerchantCollectList";
///14.17 关注的商品列表
NSString * const  Request_GoodsCollectList = @"/User/requestGoodsCollectList";
///获取金额
NSString * const  Request_Money = @"/O2O/requestMoney";
/// 获取收款列表
NSString * const  Request_PayOrderList = @"/O2O/requestPayOrderList";
/// 获取收款 方式列表
NSString * const  Request_PayConfigList = @"/O2O/requestPayConfigList";
/// 获取提现方式列表
NSString * const  Request_DrawConfigList = @"/O2O/requestDrawConfigList";
/// O2O收款
NSString * const  Request_PayOrder = @"/O2O/requestPayOrder";
/// 资道登录验证
NSString * const  Request_CkZidaoGathering = @"/O2O/requestCkZidaoGathering";
/// 已做登录验证，返回结果参照19.6
NSString * const  Request_ZidaoDraw = @"/O2O/requestZidaoDraw";
/// 资道实名认证
NSString * const  Request_ZidaoCertification  = @"/O2O/requestZidaoCertification";
///  获取资道实名认证资料
NSString * const  Request_ZidaoCertificationInfo  = @"/O2O/requestZidaoCertificationInfo";
///   设置手势密码/验证
NSString * const  Request_HandlePassword = @"/User/requestHandlePassword";
///   设置手势密码/验证
NSString * const  Request_CheckVerifyCode  = @"/VerifyCode/requestCheckVerifyCode";
///  商品列表
NSString * const  Request_GoodsList = @"/Mall/requestGoodsList" ;
///  获取首页
NSString * const  Request_Homepage  = @"/Homepage/requestHomepage";
///   获取购物车商品
NSString * const  Request_CartList  = @"/Cart/requestCartList";
///   修改购物车商品
NSString * const  Request_ChangeCart  = @"/Cart/requestChangeCart";
///   删除购物车商品
NSString * const  Request_UpdateCartList = @"/Cart/requestUpdateCartList";
///   我的服务
NSString * const  Request_MyService = @"/Article/requestTypeList";
///   我的服务->文章列表
NSString * const  Request_MyArticle = @"/Article/requestArticleListByType";
///   文章详情
NSString * const  Request_Detail = @"/Article/requestDetail";
///   文章详情-按类型（注册协议/权益说明）
NSString * const  Request_DetailByType = @"/Article/requestDetailByType";
///   问题与帮助/我要开店文章标题列表
NSString * const  Request_ListByType = @"/Article/requestListByType";
///   配置信息
NSString * const  Request_config = @"/System/config";
///   我要办卡/我要贷款列表
NSString * const  Request_ApplyInfoList = @"/Service/requestApplyInfoList";
///   现金兑换兑富币
NSString * const  Request_CashExchange  = @"/Cash/requestCashExchange";
///  14.23 取消订单
NSString * const  Request_CancelOrder = @"/Mall/requestCancelOrder";



///  首页轮播图片+喇叭中奖消息(最新10条)
NSString * const  Request_DbBannerBornList =@"/Db/requestBannerBornList";

///  一元购获取分类
NSString * const  Request_DbCategoryList = @"/Db/requestCategoryList";
///  一元购获取筛选商品
NSString * const  Request_DbGoodsList = @"/Db/requestGoodsList";
///  一元购获取商品详情
NSString * const  Request_DbGoodsInfo = @"/Db/requestGoodsInfo";
///  获取往期揭晓记录
NSString * const  Request_TimesRecord = @"/Db/requestTimesRecord";


///8.8获取本期所有参与记录
 NSString * const  Request_DbJoinList = @"/Db/requestJoinList";


///8.9 晒单分享
 NSString * const  Request_DbCommentList = @"/Db/requestCommentList";
///8.10 支付
 NSString * const  Request_DbPayOrder = @"/Db/requestPayOrder";

///8.11 我的夺宝记录
 NSString * const  Request_DbMyOrderList   =@"/Db/requestMyOrderList";
///8.12 获奖者发表评价
 NSString * const  Request_DbAddComment  =@"/Db/requestAddComment";
///8.13 我的晒单记录
 NSString * const  Request_DbMyCommentList =@"/Db/requestMyCommentList";


///8.14 幸运号码列表
NSString * const  Request_DbLuckNoList = @"/Db/requestLuckNoList";
///8.15 当期订单列表（计算结果）
NSString * const  Request_DbOrderCalList = @"/Db/requestOrderCalList";
