//
//  DWHelper.h
//  DWduifubao
//
//  Created by kkk on 16/9/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RequestPayATOrderModel;
@protocol DWHelperDelegate <NSObject>

-(void)SuccessPay;

@end
@interface DWHelper : NSObject
///支付完成代理
@property (nonatomic, assign)  id<DWHelperDelegate> delegate;
//判断网络
typedef void (^YESInternet)();
typedef void (^NOInternet)();
//设置网络请求成功 失败的bolck
typedef void(^SuccessCallback)(NSDictionary* response);
typedef void(^FaildCallback)(id error);
typedef void(^SuccessImageArr)(NSArray* urlArr);
//枚举 请求类型
typedef enum : NSUInteger {
    POST,
    GET,
    PUT,
}RequestMethod;

+ (id)shareHelper;
//网络请求
- (void)requestDataWithParm:(id)parm act:(NSString *)actName sign:(id)sign requestMethod:(RequestMethod)method PushVC:(BaseViewController*)VC success:(SuccessCallback)success faild:(FaildCallback)faild;
//取消网络请求
-(void)cancelRequest;
//上传图片
-(void)UPImageToServer:(NSArray*)imageArr toKb:(NSInteger)kb success:(SuccessImageArr)success faild:(FaildCallback)faild;
#warning ---这是带请求头的
/*
///设置网络请求成功、失败的bolck
typedef void(^SuccessCallback)(id response, NSDictionary *taskSuccessResponse);
typedef void(^FaildCallback)(id error, NSDictionary *taskFaildResponse);


///网络请求
- (void)requestDataWithParm:(id)parm act:(NSString *)actName sign:(id)sign requestMethod:(RequestMethod)method success:(SuccessCallback)success faild:(FaildCallback)faild;
*/
+ (NSMutableArray *)getCityData;

///图片展示
+(void)SD_WebImage:(UIImageView*)imageView imageUrlStr:(NSString*)urlStr placeholderImage:(NSString*)placeholder;
//检测网络
+(void)NetWorksSateYESInter:(YESInternet)yesInter NOInter:(YESInternet)NOInter;
//支付宝
+(void)AliPayActionWithModel:(RequestPayATOrderModel *)model;
//微信支付
//+ (void)WXPayActionWithModel:(RequestPayATOrderModel *)model;
//拨打电话
- (void)CallPhoneNumber:(NSString *)phoneNumber inView:(UIView *)selfView;
@end
