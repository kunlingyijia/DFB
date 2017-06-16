//
//  AppDelegate.m
//  DWduifubao
//
//  Created by kkk on 16/9/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AppDelegate.h"
#import "UserGuideViewController.h"
#import "AdViewController.h"
#import "VerisonModel.h"
#import "GesturePasswordView.h"
#import "UPNembersViewController.h"
#import "LoginController.h"
#import "GestureLoginViewController.h"
#import "RequestFindPassword.h"
#import "GestureFindPasswordViewController.h"
#import "MessageViewController.h"
#import "HomePageVC.h"
@interface AppDelegate ()<WXApiDelegate,UIAlertViewDelegate,JPUSHRegisterDelegate>
///忘记手势密码
@property(nonatomic,strong)UIAlertView *findPasswordalertv;
///重置手势密码
@property(nonatomic,strong)UIAlertView *resetPasswordalertv;
///其他设备登录
@property(nonatomic,strong)UIAlertView *ohteralertv;
@property(nonatomic,strong)NSDictionary *userInfo;
///推送别名（新增）
@property (nonatomic, strong) NSString  *pushAlias;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //使用NSUserDefaults记录当前的加载是否是第一次加载
    //创建用于持久化存储数据的对象
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //判断程序是否是第一次加载
    NSNumber *havelanch = [userDefaults objectForKey:@"haveLanch"];
    if ([havelanch boolValue] == YES) {
        AdViewController  *lanc = [[AdViewController alloc] initWithNibName:@"AdViewController" bundle:nil];
        self.window.rootViewController = lanc;
        
    }else{
        UserGuideViewController  *lanc = [[UserGuideViewController alloc] initWithNibName:@"UserGuideViewController" bundle:nil];
        self.window.rootViewController = lanc;
        //将本次加载记录一下
        [userDefaults setValue:@(YES) forKey:@"haveLanch"];
        [[NSUserDefaults standardUserDefaults]setObject:@"IsWifi" forKey:@"IsWifi"];
    }
    
   
    //存储开关的状态
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{@"switchType":@NO}];
    //设置第三方
    [self SetUpThirdParty:launchOptions];
//    //其他配置信息网络请求
//    [self requestSystemotherConfigAction];
    //添加手势密码
    [self addgestureView];
    
    return YES;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //            NSLog(@"result = %@",resultDic);
            //             [[NSNotificationCenter defaultCenter]postNotificationName:@"aliPayReslut" object:nil userInfo:resultDic];
        }];
        //
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        [self removeGestureViewFromSuperView];
        
    }
    return YES;
}

//微信回调的方法
//-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
//    return [WXApi handleOpenURL:url delegate:self];
//}
#pragma WXApiDelegate
-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response = (PayResp*)resp;
        //创建通知中心
        [[NSNotificationCenter defaultCenter]postNotificationName:@"weixinPay" object:response];
        
        
        
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (self.gestureView !=nil) {
        [self removeGestureViewFromSuperView];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //添加手势密码锁
    [self addgestureView];
    NSLog(@"%@",self.window.rootViewController
          );

   
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    
}

#pragma mark - 设置所有第三方
-(void)SetUpThirdParty:(NSDictionary *)launchOptions{
    //设置友盟
    [self UMManager];
    //设置微信支付
    [self WXApy];
    //高的地图
    [self AMap];
    //极光推送
    [self JGPush:launchOptions];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    
}
#pragma mark - 设置微信支付
-(void)WXApy{
    //向微信注册wxd930ea5d5a258f4f
    //参数一  注册微信支付后给的appid
    //参数二 为了区别业务 给开发者坐出一个解释的作用(解释作用)
    [WXApi registerApp:@"wxb9bbefcbd98453bd" withDescription:@"demo 2.0"];
    
    
}
#pragma mark - 设置友盟
-(void)UMManager{
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57fb592b67e58ead9b000826"];
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxb9bbefcbd98453bd" appSecret:@"3efe957a7146e5249a421791e54ef779" redirectURL:@"http://mobile.umeng.com/social"];
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105708203"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    UMConfigInstance.appKey = @"57fb592b67e58ead9b000826";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    
}
#pragma mark - 高的地图配置
-(void)AMap{
    //gd //1d86e5860559ec6cbb1391ce853bd3f2
    //test //9fad225d5991e4b6399bb5e80fc67e79
    //[AMapLocationServices sharedServices].apiKey = GDKey;
    [AMapServices sharedServices].apiKey =GDKey;
    [[AMapServices sharedServices] setEnableHTTPS:YES];
}
#pragma mark - 极光推送
-(void)JGPush:(NSDictionary *)launchOptions{
    /*=======
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //      NSSet<UNNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        //    else {
        //      NSSet<UIUserNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    ===========*/
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
//            [USER setObject:registrationID forKey:@"deviceToken"];
//            [USER synchronize];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    //设置别名
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SetUpAlias:) name:@"设置别名" object:nil];
    
    
}

#pragma mark -  设置别名
-(void)SetUpAlias:(NSNotification*)sender{
    NSDictionary * dic = sender.userInfo;
    self.pushAlias =dic[@"pushAlias"];
    __weak typeof(self) weakSelf = self;
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [JPUSHService setAlias:weakSelf.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:weakSelf];
         
     });
    
}
#pragma mark - 推送别名
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    if (iResCode == 0) {
        
    }
    if (iResCode == 6002) {
        [JPUSHService setAlias:self.pushAlias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
    else{
        
    }
    NSLog(@"push set alias success alisa = %@", alias);
}



#pragma mark - 注册通知

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    //    [USER setObject:token forKey:@"deviceToken"];
    //    [USER synchronize];
    //
    //[UMessage registerDeviceToken:deviceToken];
    [JPUSHService registerDeviceToken:deviceToken];
    
}
/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //    [SVProgressHUD showInfoWithStatus:@"注册推送失败"];
    NSLog(@"注册推送失败------------------");
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@",userInfo);
    
    self.userInfo = userInfo;
    [self receivePushMessage];
}
//前台收到通知
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        self.userInfo = userInfo;
        //        [self receivePushMessage];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
//后台收到推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        self.userInfo = userInfo;
        [self receivePushMessage];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif


#pragma mark - APP运行中接收到通知(推送)处理

///** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台)  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        [self receiveRemoteNotificationReset:userInfo];
    }else{
        self.userInfo = userInfo;
        [self receivePushMessage];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark------------------收到通知的页面处理
-(void)receivePushMessage {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        //手势
        [self.window bringSubviewToFront:self.gestureView];
    }
    //Push 跳转
    DWTabBarController * VC = [[DWTabBarController alloc]init];
    VC.selectedIndex = 0;
    self.window.rootViewController = VC;
    NSLog(@"%@",VC.viewControllers);
    BaseNavigationController *naVC = VC.viewControllers.firstObject;
    NSLog(@"%@",naVC.viewControllers);
    for (BaseViewController*tempVC in naVC.viewControllers) {
        if ([tempVC isKindOfClass:[HomePageVC class]]) {
            HomePageVC *home = (HomePageVC *)tempVC;
            NSString *Token =[AuthenticationModel getLoginToken];
            if (Token.length!= 0) {
                //Push 跳转
                MessageViewController * VC = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
                [home.navigationController  pushViewController:VC animated:YES];
                
            }
            
        }
    }

    
   
    
    
//    DWTabBarController *tabBarController = ( DWTabBarController*)self.window.rootViewController;
//    // 取到navigationcontroller
//    BaseNavigationController * nav = (BaseNavigationController *)tabBarController.selectedViewController;
//    //取到nav控制器当前显示的控制器
//    UIViewController * baseVC = (UIViewController *)nav.visibleViewController;
    //type字段后台返回，使用极光测试需在『附加字段』处添加
    NSDictionary *dic =self.userInfo;
    NSLog(@"%@",dic);
    
//    if([dic[@"type"] integerValue]==1){
//        
//    }else  if([dic[@"type"] integerValue]==2){
//        
//    }else if([dic[@"type"] integerValue]==3){
//        
//    }else if([dic[@"type"] integerValue]==4){
//        
//    }else if ([dic[@"type"] integerValue]==5){
//        WebToolViewController *vc=[[WebToolViewController alloc]init];
//        vc.isChange=YES;
//        vc.hidesBottomBarWhenPushed=YES;
//        vc.urlStr = dic[@"custom"];
//        [baseVC.navigationController pushViewController:vc animated:YES];
//        return;
//        
//    }else{
//        [self showReceiveMessage:dic[@"title"]];
//        return;
//    }
//    
//    
//    //如果是当前控制器是我的消息控制器的话，刷新数据即可
//    MyMessageViewController *message = [[MyMessageViewController alloc]init];
//    if([baseVC isKindOfClass:[MyMessageViewController class]])
//    {
//        MyMessageViewController * vc = (MyMessageViewController *)baseVC;
//        [vc headerRereshing];
//        return;
//    }
//    message.hidesBottomBarWhenPushed = YES;
//    [nav pushViewController:message animated:YES];
    // 否则，跳转到我的消息
    
    
}
#pragma mark - 运行在前台时的提示框提醒
-(void)receiveRemoteNotificationReset:(NSDictionary *)userInfo{
    
    
    
    if (userInfo) {
        self.userInfo = userInfo;
    }
    NSString *typeStirng=userInfo[@"type"];
    if(typeStirng==nil||[typeStirng integerValue]==0){
        
        [self showReceiveMessage:userInfo[@"title"]];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:userInfo[@"title"] message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"稍后"
                                                  otherButtonTitles:@"立即前往", nil];
        [alertView show];
    }
    
}
#pragma mark-------------------------------推送处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [self receivePushMessage];
    }
}
#pragma mark - 设置推送内容的展示
-(void)showReceiveMessage:(NSString *)message{
//    [JDStatusBarNotification showWithStatus:message
//                               dismissAfter:2.0
//                                  styleName:@"SBStyle"];
    
}

/*
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
    
    
    
    
    
    
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
    
    
    
}
#endif
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
    NSLog(@"收到通知:%@", userInfo);
    [application cancelAllLocalNotifications];
    [JPUSHService handleRemoteNotification:userInfo];
    
    //    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"p_foot3" ofType:@"m4a"];
    //    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    //    self.player = [[AVPlayer alloc] initWithURL:audioUrl];
    //    [_player setVolume:1];
    //    [_player play];
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送消息" message:[userInfo yy_modelToJSONString] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    //    [alert show];
    
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    
    [application setApplicationIconBadgeNumber:application.applicationIconBadgeNumber + 1];
    
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
    //    [self performSelector:@selector(playMusic) withObject:nil afterDelay:1];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"刷新订单" object:@"刷新订单" userInfo:@{}];
    completionHandler(UIBackgroundFetchResultNewData);
}
//请在AppDelegate.m实现该回调方法并添加回调方法中的代码
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//添加处理APNs通知回调方法

//请在AppDelegate.m实现该回调方法并添加回调方法中的代码
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


////下面的这个方法也很重要，这里主要处理推送过来的消息
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
//    NSLog(@"尼玛的推送消息呢===%@",userInfo);
//    // 取得 APNs 标准信息内容，如果没需要可以不取
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
//    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
//    // 取得自定义字段内容，userInfo就是后台返回的JSON数据，是一个字典
//    [APService handleRemoteNotification:userInfo];
//    application.applicationIconBadgeNumber = 0;
//    [self goToMssageViewControllerWith:userInfo];
//}
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [application setApplicationIconBadgeNumber:0];   //清除角标
//    [application cancelAllLocalNotifications];
//}
//- (void)goToMssageViewControllerWith:(NSDictionary*)msgDic{
//    //将字段存入本地，因为要在你要跳转的页面用它来判断,这里我只介绍跳转一个页面，
//    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
//    [pushJudge setObject:@"push"forKey:@"push"];
//    [pushJudge synchronize];
//    NSString * targetStr = [msgDic objectForKey:@"target"];
//    if ([targetStr isEqualToString:@"notice"]) {
//        MessageVC * VC = [[MessageVC alloc]init];
//        UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:VC];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
//        [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
//        
//    }
//}

*/

#pragma mark -其他配置信息
-(void)requestSystemotherConfigAction{
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = @[];
    // NSLog(@"%@",[baseReq yy_modelToJSONString]);
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/System/otherConfig" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:nil  success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        // NSLog(@"这配置及%@",response);
        if (baseRes.resultCode == 1) {
            //其他配置--数据存储
            [weakself SaveDataWithSystemotherConfigAction:baseRes];
        }else{
            
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
    
}

#pragma mark - 其他配置保存数据
-(void)SaveDataWithSystemotherConfigAction:(BaseResponse*)baseRes{
    NSDictionary *dic = baseRes.data;
    NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
    
    if (![dic[@"register_url"] isKindOfClass:[NSNull class]]) {
        [userDefau setObject:dic[@"register_url"] forKey:@"register_url"];
    }
    
    
    if (![dic[@"help_url"] isKindOfClass:[NSNull class]]) {
       [userDefau setObject:dic[@"help_url"] forKey:@"help_url"];
    }
    
    if (![dic[@"auth_url"] isKindOfClass:[NSNull class]]) {
        [userDefau setObject:dic[@"auth_url"] forKey:@"auth_url"];
    }
//

    
    
}
#pragma mark -//添加手势密码锁
-(void)addgestureView{
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        [BackgroundService requestPushVC:nil MyselfAction:^{
            
        }];
        self.gestureView = [NIBHelper instanceFromNib:@"GesturePasswordView"];
        
        _gestureView.frame = CGRectMake(0, 0, Width, Height);
        [self.window addSubview:_gestureView];
        [self bringgestureViewToFront];
        __weak typeof(self) weakSelf = self;
        [_gestureView GestureReturnStr:^(NSString *password) {
            // NSLog(@"%@",password);
            //        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            //        [SVProgressHUD showWithStatus:@"加载中..."];
            [weakSelf requestAction:password];
            
        }];
        //忘记手势密码
        [_gestureView GestureForgetPassword:^() {
            [weakSelf removeGestureViewFromSuperView]
            ;
            //Push 跳转
            [weakSelf FindPasswordPushViewController];
        }];
        //退出登录
        [_gestureView GestureLogOut:^() {
            [weakSelf removeGestureViewFromSuperView];
            [AuthenticationModel moveLoginToken];
            [AuthenticationModel moveindiana_moblie];
            [AuthenticationModel moveCarNumber];
            //设置别名
            [[NSNotificationCenter defaultCenter]postNotificationName:@"设置别名" object:nil userInfo:[NSDictionary dictionaryWithObject:@"" forKey:@"pushAlias"]];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_password"];
            [AuthenticationModel moveLoginKey];
            DWTabBarController * tabar = [[DWTabBarController alloc]init];
            tabar.selectedIndex = 3;
            self.window.rootViewController = tabar;
            //        //Push 跳转
            //        GestureLoginViewController * VC = [[GestureLoginViewController alloc]initWithNibName:@"GestureLoginViewController" bundle:nil];
            //        BaseNavigationController * NAVc = [[BaseNavigationController alloc]initWithRootViewController:VC];
            //        self.window.rootViewController = NAVc;
            
        }];
    }
    
}

-(void)removeGestureViewFromSuperView{
    [self.gestureView removeFromSuperview];
    self.gestureView = nil;
}
-(void)sendgestureViewToBack{
    [self.window sendSubviewToBack:self.gestureView];
}
-(void)bringgestureViewToFront{
    [self.window bringSubviewToFront:self.gestureView];
}
#pragma mark - 请求验证手势密码
-(void)requestAction:(NSString * )password{
    NSString *Token =[AuthenticationModel getLoginToken];
    RequestFindPassword *model = [[RequestFindPassword alloc]init];
    model.handle_password = password;
    model.type = @"1";
    __weak typeof(self) weakSelf = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[[model yy_modelToJSONObject ] yy_modelToJSONString ]password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestHandlePassword" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:nil  success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            NSLog(@"-手势密码-%@",response);
            if (baseRes.resultCode == 1) {
                //保存手势密码
                [weakSelf removeGestureViewFromSuperView];
                [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"myPassword"];
            }else if(baseRes.resultCode == 3){
                //                self.ohteralertv = [[UIAlertView alloc]initWithTitle:@"" message:response[@"msg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
                //                [self.ohteralertv show];
                //                [BackgroundService loginWhileTokeInvalid];
                //                [self removeGestureViewFromSuperView];
                
                
            }else if(baseRes.resultCode == 14){
                //                self.ohteralertv = [[UIAlertView alloc]initWithTitle:@"" message:response[@"msg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
                //                [self.ohteralertv show];
                [BackgroundService loginWhileTokeInvalid];
                [self removeGestureViewFromSuperView];
                
                
            }else if(baseRes.resultCode == 35){
                _gestureView.gestureLabel.textColor= [UIColor redColor];
                _gestureView.gestureLabel.text =response[@"msg"];
            }else if(baseRes.resultCode == 36){
                self. resetPasswordalertv = [[UIAlertView alloc]initWithTitle:@"" message:response[@"msg"] delegate:self cancelButtonTitle:@"重置手势密码" otherButtonTitles:nil, nil];
                [_resetPasswordalertv show];
                //手势密码输入次数已达上限 --跳转到找回密码
            }else if(baseRes.resultCode == 37){
                self.findPasswordalertv = [[UIAlertView alloc]initWithTitle:@"" message:response[@"msg"] delegate:self cancelButtonTitle:@"设置手势密码" otherButtonTitles:nil, nil];
                [_findPasswordalertv show];
                //手势密码输入次数已达上限 --跳转到找回密码
            }else{
                
            }
            
        } faild:^(id error) {
            NSLog(@"%@", error);
        }];
        
    }
}
//alertView即将消失执行事件
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    //    if (alertView == self.ohteralertv) {
    //        //其他设备登录
    //        if (buttonIndex==0) {
    //
    //        }else{
    //        [BackgroundService loginWhileTokeInvalid];
    //        [AuthenticationModel moveLoginToken];
    //        [AuthenticationModel moveLoginKey];
    //        DWTabBarController * tabar = [[DWTabBarController alloc]init];
    //        tabar.selectedIndex = 3;
    //        self.window.rootViewController = tabar;
    //        [self removeGestureViewFromSuperView];
    //        }
    //    }
    // else
    if (alertView == self.findPasswordalertv){
        //找回实时密码
        [self removeGestureViewFromSuperView];
        [self FindPasswordPushViewController];
    }else if (alertView == self.resetPasswordalertv){
        //重置手势密码
        [self removeGestureViewFromSuperView];
        [self FindPasswordPushViewController];
    }
}
#pragma mark - 跳转到找回密码
-(void)FindPasswordPushViewController{
    GestureFindPasswordViewController * VC = [[GestureFindPasswordViewController alloc]initWithNibName:@"GestureFindPasswordViewController" bundle:nil];
    VC.pushSource = @"窗口";
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:VC];
    self.window.rootViewController = naVC;
    
}


#pragma mark - 注意：收到内存警告时调用，
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 1. 停止所有下载
    [[SDWebImageManager sharedManager] cancelAll];
    
    // 2. 清除缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}



@end
