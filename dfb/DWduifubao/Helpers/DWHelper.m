//
//  DWHelper.m
//  DWduifubao
//
//  Created by kkk on 16/9/12.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "DWHelper.h"
#import "RequestPayATOrderModel.h"
#import "BackgroundService.h"
#import "LoginController.h"
#import "LoadWaitSingle.h"
#import "UIImage+DWImage.h"
@interface DWHelper (){
    //NSURLSessionDataTask *task;
    //AFHTTPSessionManager *manager;
    UIWebView *callPhoneWebview;
}
@end
@implementation DWHelper
+ (id)shareHelper {
    static DWHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[DWHelper alloc] init];
    });
    return helper;
}
//网络请求
- (void)requestDataWithParm:(id)parm act:(NSString *)actName sign:(id)sign requestMethod:(RequestMethod)method PushVC:(BaseViewController*)VC success:(SuccessCallback)success faild:(FaildCallback)faild {
    
    
    NSBundle *goodBundle;
    goodBundle = [NSBundle bundleWithPath:@"/Users/xiyakun/Desktop/dfb/DWduifubao/ThirdPart/SVProgressHUD/SVProgressHUD.bundle"];
    
    NSString *resourceBundle = [[NSBundle mainBundle] pathForResource:@"SVProgressHUD" ofType:@"bundle"];
    
    NSString *earth = [[NSBundle bundleWithPath:resourceBundle] pathForResource:@"timg.gif"ofType:nil
                                        inDirectory:nil];
    // NSLog(@"earth-----%@",earth);
    ///UIImage *image = [UIImage imageWithContentsOfFile:earth];
     //[SVProgressHUD showImage:image status:@"加载中..."];
    //[SVProgressHUD setInfoImage:image ];
    
    [[LoadWaitSingle shareManager]showLoadWaitViewImage:@"兑富宝加载等待图"];
    NSUserDefaults *defaults=  [NSUserDefaults standardUserDefaults];
    NSString*  lat = [defaults   objectForKey:@"Headerlat"];
    NSString*  lng = [defaults   objectForKey:@"Headerlng"];
    NSString*  address = [defaults   objectForKey:@"HeaderformattedAddress"];
    NSString*  province = [defaults   objectForKey:@"Headerprovince"];
    NSString*  city = [defaults   objectForKey:@"Headercity"];
    NSString*  area = [defaults   objectForKey:@"Headerdistrict"];
    //系统版本
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    //设备类型
    NSString * phoneModel =[[UIDevice currentDevice] model];
    //
    NSString *appVersion =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *deviceNo = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    NSString * str = [actName substringWithRange:NSMakeRange(0, 3)];
    NSString * ACTName = [str isEqualToString:@"act"] ? actName :[NSString stringWithFormat:@"%@%@",ACT_API,actName];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@&sign=%@",kServerUrl,ACTName,sign];
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
  AFHTTPSessionManager*  manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"application/x-www-form-urlencoded", nil];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer
     setValue:lat
     forHTTPHeaderField:@"lat"];
    [manager.requestSerializer
     setValue:lng
     forHTTPHeaderField:@"lng"];
    [manager.requestSerializer
     setValue:province
     forHTTPHeaderField:@"province"];
    [manager.requestSerializer
     setValue:city
     forHTTPHeaderField:@"city"];
    [manager.requestSerializer
     setValue:area
     forHTTPHeaderField:@"area"];
    [manager.requestSerializer
     setValue:address
     forHTTPHeaderField:@"address"];
    [manager.requestSerializer
     setValue:appVersion
     forHTTPHeaderField:@"appVersion"];
    [manager.requestSerializer
     setValue:@"1"
     forHTTPHeaderField:@"clientOS"];
    [manager.requestSerializer
     setValue:deviceNo
     forHTTPHeaderField:@"deviceNo"];
    [manager.requestSerializer
     setValue:systemVersion
     forHTTPHeaderField:@"systemVersion"];
    [manager.requestSerializer
     setValue:phoneModel
     forHTTPHeaderField:@"phoneModel"];
    // manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if (method == GET) {
  [manager GET:url parameters:[NSDictionary dictionaryWithObject:parm forKey:@"request"] progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if([responseObject[@"resultCode"]isEqualToString:@"14"]) {
                if (VC==nil) {
                    
                }else{
                    //设置别名
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"设置别名" object:nil userInfo:[NSDictionary dictionaryWithObject:@"" forKey:@"pushAlias"]];
                    //Push 跳转
                    [AuthenticationModel moveLoginToken];
                    [AuthenticationModel moveindiana_moblie];
                    [AuthenticationModel moveLoginKey];
                    [AuthenticationModel moveCarNumber];
                    
                    LoginController * LoginVC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
                    [LoginVC LoginRefreshAction:^{
                    }];
                    [VC.navigationController  pushViewController:LoginVC animated:YES];
                }
            }
            success(responseObject);
            [SVProgressHUD dismiss];
            [[LoadWaitSingle shareManager] hideLoadWaitView];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error.localizedDescription--%@",error.localizedDescription);
            NSLog(@"error.localizedDescription--%ld",error.code);
            faild(error);
            
            NSString * errorStr =error.localizedDescription;
            if (errorStr.length>1) {
                 [SVProgressHUD showErrorWithStatus:  [error.localizedDescription   substringToIndex:error.localizedDescription.length-1]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"网络连接失败"];

            }
         
           // [SVProgressHUD showErrorWithStatus:error.localizedDescription];
           
            [[LoadWaitSingle shareManager] hideLoadWaitView];
        }];
       
    }else if(method == POST) {
                   //缓存策略
        //manager.requestSerializer.cachePolicy = 0;
   [manager POST:url parameters:[NSDictionary dictionaryWithObject:parm forKey:@"request"] progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"resultCode"]isEqualToString:@"14"]) {
                if (VC==nil) {
                }else{
                    //Push 跳转
                    [AuthenticationModel moveLoginToken];
                    [AuthenticationModel moveLoginKey];
                    //设置别名
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"设置别名" object:nil userInfo:[NSDictionary dictionaryWithObject:@"" forKey:@"pushAlias"]];
                    LoginController * LoginVC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
                    [LoginVC LoginRefreshAction:^{
                    }];
                    [VC.navigationController  pushViewController:LoginVC animated:YES];
                }
                
                
            }
            success(responseObject);
            [SVProgressHUD dismiss];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            faild(error);
        }];
   
    }
}

-(void)error:(NSError * )error{
    NSLog(@"%@",error.userInfo);
    NSString * _kCFStreamErrorCodeKey =error.userInfo[@"_kCFStreamErrorCodeKey"];
    if ([_kCFStreamErrorCodeKey isEqualToString:@"-2102"]) {
         [SVProgressHUD showErrorWithStatus:@"网络无法连接"];
    }
    if ([_kCFStreamErrorCodeKey isEqualToString:@"-1003"]) {
        [SVProgressHUD showErrorWithStatus:@"网络无法连接"];
    }
}


//取消网络请求
-(void)cancelRequest{
    
    //[manager.operationQueue cancelAllOperations];
}
///上传图片
-(void)UPImageToServer:(NSArray*)imageArr toKb:(NSInteger)kb success:(SuccessImageArr)success faild:(FaildCallback)faild{
    NSString *password = [NSString stringWithFormat:@"%@%@%@",[AuthenticationModel getimage_account],[AuthenticationModel getimage_hostname],[AuthenticationModel getimage_password]];
    NSDictionary * dic = @{@"image_account":[AuthenticationModel getimage_account],@"image_password":[password MD5Hash]};
    AFHTTPSessionManager *UPmanager = [AFHTTPSessionManager manager];
    UPmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [[LoadWaitSingle shareManager]showLoadWaitViewImage:@"兑富宝加载等待图"];
    [UPmanager POST:[AuthenticationModel getimage_hostname] parameters:[dic yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i= 0; i< imageArr.count; i++) {
           UIImage * image =  [UIImage scaleImageAtPixel:imageArr [i] pixel:1024];
            //1.把图片转换成二进制流
            NSData *imageData= [ UIImage scaleImage:image toKb:kb];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            //2.上传图片
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d",i]fileName:[NSString stringWithFormat:@"%@%d.jpg",fileName, i] mimeType:@"image/jpeg"];
        }
      
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //[SVProgressHUD showProgress:uploadProgress.fractionCompleted status:@"上传中"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          success(responseObject[@"data"]);
         [[LoadWaitSingle shareManager] hideLoadWaitView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faild(error);
         [[LoadWaitSingle shareManager] hideLoadWaitView];
//         [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
        NSString * errorStr =error.localizedDescription;
        if (errorStr.length>1) {
            [SVProgressHUD showErrorWithStatus:  [error.localizedDescription   substringToIndex:error.localizedDescription.length-1]];
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
            
        }
    }];

}

#pragma mark - 带请求头的 task
/*
 - (void)requestDataWithParm:(id)parm act:(NSString *)actName sign:(id)sign requestMethod:(RequestMethod)method success:(SuccessCallback)success faild:(FaildCallback)faild {
 //     [SVProgressHUD dismiss];
 //
 //[SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
 //[SVProgressHUD showWithStatus:@"加载中..."];
 if (method == GET) {
 NSString *url = [NSString stringWithFormat:@"%@%@&sign=%@",kServerUrl,actName,sign];
 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"application/x-www-form-urlencoded", nil];
 // manager.requestSerializer = [AFJSONRequestSerializer serializer];
 
 
 [manager GET:url parameters:[NSDictionary dictionaryWithObject:parm forKey:@"request"] progress:^(NSProgress * _Nonnull downloadProgress) {
 
 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;            success(responseObject ,response);
 [SVProgressHUD dismiss];
 
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
 faild(error,response);
 }];
 
 
 }else if(method == POST) {
 NSString *url = [NSString stringWithFormat:@"%@%@&sign=%@",kServerUrl, actName,sign];
 AFHTTPSessionManager *Session = [AFHTTPSessionManager manager];
 //缓存策略
 Session.requestSerializer.cachePolicy = 0;
 Session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
 [Session POST:url parameters:[NSDictionary dictionaryWithObject:parm forKey:@"request"] progress:^(NSProgress * _Nonnull downloadProgress) {
 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
 success(responseObject,response);
 [SVProgressHUD dismiss];
 
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
 faild(error,response);
 }];
 }
 }
 */
+ (NSMutableArray *)getCityData
{
    NSArray *jsonArray = [[NSArray alloc]init];
    NSData *fileData = [[NSData alloc]init];
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    if ([UD objectForKey:@"city"] == nil) {
        NSString *path;
        path = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"json"];
        fileData = [NSData dataWithContentsOfFile:path];
        [UD setObject:fileData forKey:@"city"];
        [UD synchronize];
    }else {
        fileData = [UD objectForKey:@"city"];
    }
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    jsonArray = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
    for (NSDictionary *dict in jsonArray) {
        [array addObject:dict];
    }
    
    return array;
}
///图片展示
+(void)SD_WebImage:(UIImageView*)imageView imageUrlStr:(NSString*)urlStr placeholderImage:(NSString*)placeholder{
    
    if (placeholder==nil) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"敬请期待"]];
    }else{
        if (![urlStr isKindOfClass:[NSNull class]]) {
             [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",placeholder]]];
        }
       
    }
    
}

///网络检测
+(void)NetWorksSateYESInter:(YESInternet)yesInter NOInter:(YESInternet)NOInter{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            
            //yesInter();
            //NSLog(@"有网");
        }else{
            //NSLog(@"没有网");
            
            //NOInter();
        }
        
        switch (status) {
            case -1:
                //NSLog(@"未知网络");
                NOInter();
                break;
            case 0:
                //NSLog(@"网络不可达");
                NOInter();
                break;
            case 1:
                // NSLog(@"GPRS网络");
                yesInter();
               
                break;
            case 2:
                // NSLog(@"wifi网络");
                yesInter();
                
                break;
            default:
                break;
        }
    }];
    
    
    
}

+ (void)AliPayActionWithModel:(RequestPayATOrderModel *)model{
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    //表示商户id 支付宝签订协议后分配的id 需要公司营业执照(公司弄)
    // NSString *partner = @"2088321000596152";
    //邮箱地址 绑定总账号(公司弄) 绑定公司账号, 用于客户交易资金转账
    //NSString *seller = model.seller_id;
    //私钥:是用来加密用的 公钥:是用来解密用的(我们用不上)  (后台弄的)
    //NSString *privateKey = model.prealipay; ;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    //    if ([partner length] == 0 ||
    //        [seller length] == 0 ||
    //        [privateKey length] == 0)
    //    {
    //        NSLog(@"缺少partner或者seller或者私钥");
    //        return;
    //    }
    
    //    /*
    //     *生成订单信息及签名
    //     */
    //    //将商品信息赋予AlixPayOrder的成员变量 ( 以下网络请求来的数据)
    //    Order *order = [[Order alloc] init];
    //    //order.partner = partner;
    //    //order.seller = seller;
    //    order.tradeNO = model.order_no; //订单ID（由商家自行制定）
    //    order.productName = model.goodsName; //商品标题
    //    //order.productDescription = model.body; //商品描述
    //    order.amount = [NSString stringWithFormat:@"%.2f",model.pay_amount]; //商品价格.2f 其他值不行 会失败
    //    order.notifyURL =  model.notify_url; //回调URL
    //
    //
    //    //以下信息是默认信息 不需要更改
    //    order.service = @"mobile.securitypay.pay";
    //    order.paymentType = @"1";
    //    order.inputCharset = @"utf-8";
    //    order.itBPay = @"30m";
    //    order.showUrl = @"m.alipay.com";
    //
    //    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    //    //标识 支付后根据这个值跳转到这个App (要在info中设置 见图片http://blog.sina.com.cn/s/blog_6f72ff900102v4vp.html)
    //    NSString *appScheme = @"yunke";
    //
    //    //将商品信息拼接成字符串
    //    NSString *orderSpec = [order description];
    //
    //    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode    (拼接成的字符串 加密)
    //    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    //    NSString *signedString = [signer signString:orderSpec];
    //    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    //    NSString *orderString = nil;
    //    if (signedString != nil) {
    //        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
    //                       orderSpec, signedString, @"RSA"];
    //调用支付宝的api
    [[AlipaySDK defaultService] payOrder:model.prealipay fromScheme:@"DUIFUBAO" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        NSString *resultStatus = resultDic[@"resultStatus"];
        if ([resultStatus isEqualToString:@"9000"]) {
            //创建通知通知中心
            [[NSNotificationCenter defaultCenter]postNotificationName:@"zhifuwancheng" object:self userInfo:nil];
        }
    }];
    //}
    
}
//微信支付
//+ (void)WXPayActionWithModel:(RequestPayATOrderModel *)model {
//
//    PayReq *request = [[PayReq alloc] init];
//    //商家向财付通申请的商家id
//    request.partnerId = model.partnerid;
//    //预支付订单:绑定了我的商品的基本信息 (后台生成的id)
//    request.prepayId= model.prepayid;
//    //商家根据财付通文档填写的数据和签名 : 微信的标识 意味着是微信支付 不是别的服务
//    request.package = model.package;
//    //随机串，防重发
//    request.nonceStr= model.noncestr;
//    //时间戳，防重发
//    request.timeStamp= model.timestamp;
//    //商家根据微信开放平台文档对数据做的签名: 是一种加密方式 所有的支付都需要加密
//    request.sign= model.sign;
//    [WXApi sendReq:request];
//}
/**
 *  拨打电话
 *
 *  @param phoneNumber 要拨打的号码
 *  @param view        拨号所在的页面
 */
- (void)CallPhoneNumber:(NSString *)phoneNumber inView:(UIView *)selfView
{
    
    if (!callPhoneWebview) {
        callPhoneWebview = [[UIWebView alloc] init];
    }
    if (![callPhoneWebview isDescendantOfView:selfView]) {
        [selfView addSubview:callPhoneWebview];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"tel://%@", phoneNumber];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [callPhoneWebview loadRequest:request];
}

@end
