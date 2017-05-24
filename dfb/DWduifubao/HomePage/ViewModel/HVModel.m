//
//  HVModel.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/25.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "HVModel.h"
#import "VerisonModel.h"
#import "VersionUpViewController.h"
#import "AppDelegate.h"
@interface HVModel ()<AMapLocationManagerDelegate>
@property(nonatomic,strong)AMapLocationManager *locationManager;
//网络判断view
@property(nonatomic,strong)UIView * interView;
@end
@implementation HVModel
#pragma mark - 版本更新
-(void)updateVerison{ //获得build号：
    NSString *build =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
    NSLog(@"build=====%@",build);
    //代码实现获得应用的Verison号：
    NSString *oldVerison =    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    int oldOne=  [[oldVerison substringWithRange:NSMakeRange(0,1)]intValue];
    int oldTwo = [[oldVerison substringWithRange:NSMakeRange(2,1)]intValue];
    int oldThree = [[oldVerison  substringWithRange:NSMakeRange(4,1)]intValue];
    
    
    VerisonModel *model = [[VerisonModel alloc]init];
    model.os = 1;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data  = model;
   __weak  typeof(self)   weakself = self;
    
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_VersionUpdate sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:_HomeVC success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
        // NSLog(@"检测----%@",response);
        if (baseRes.resultCode == 1) {
            NSDictionary * dic = response[@"data"];
            VerisonModel *model = [VerisonModel yy_modelWithJSON:dic];
            int newOne=  [[model.version substringWithRange:NSMakeRange(0,1)]intValue];
            int newTwo = [[model.version  substringWithRange:NSMakeRange(2,1)]intValue];
            int newThree = [[model.version  substringWithRange:NSMakeRange(4,1)]intValue];
            NSString *newbuild;
            if (model.version.length>6) {
                newbuild =[model.version substringFromIndex:6];
                
            }
            NSLog(@"NewOne----%d\nNewTwo----%d\nNewThree----%d\nnewbuild----%@ ",newOne ,newTwo,newThree,newbuild);
            if ([model.is_update isEqualToString:@"1"]) {
                if (oldOne<newOne) {
                    //强制跟新
                    [weakself addMandatoryAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo<newTwo){
                    [weakself addMandatoryAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo==newTwo&&oldThree<newThree){
                    [weakself addMandatoryAlertAction:model];
                    return ;
                }
                else if(oldOne==newOne&&oldTwo==newTwo&&oldThree==newThree&&![build isEqualToString:newbuild]){
                    [weakself addMandatoryAlertAction:model];
                    return;
                }
                else{
                    
                }
                
            }else{
                
                if (oldOne<newOne) {
                    [weakself addAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo<newTwo){
                    [weakself addAlertAction:model];
                    return ;
                }else if (oldOne==newOne&&oldTwo==newTwo&&oldThree<newThree){
                    [weakself addAlertAction:model];
                    return ;
                }
                else
                    if(oldOne==newOne&&oldTwo==newTwo&&oldThree==newThree &&![build isEqualToString:newbuild]){
                        [weakself addAlertAction:model];
                        return;
                    }
                    else
                    {
                        
                    }
                
                NSLog(@"不用强制更新");
            }
        }else{
            [_HomeVC showToast:response[@"msg"]];
            
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];
}


#pragma mark - 强制更新
-(void)addMandatoryAlertAction:(VerisonModel*)model {
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"发现新版本\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(30, 65, 210, 180)];
    textView.font = [UIFont systemFontOfSize:15];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.text = model.content;
    [alertC.view addSubview:textView];

    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"我要去升级" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //Push 跳转
        VersionUpViewController * VC = [[VersionUpViewController alloc]init];
        VC.url = model.url;
        // NSLog(@"我要去升级--%@",VC.url);
        [_HomeVC presentViewController:VC animated:YES completion:nil];
        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fir.im/l874"]];
        
    }];
    [alertC addAction:OK];
    [_HomeVC presentViewController:alertC animated:YES completion:nil];
}
#pragma mark - 不强制更新
-(void)addAlertAction:(VerisonModel*)model{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"发现新版本\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(30, 65, 210, 180)];
    textView.font = [UIFont systemFontOfSize:15];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.text = model.content;
    [alertC.view addSubview:textView];
    __weak typeof(_HomeVC) weakSelf = _HomeVC;
    UIAlertAction * cancel= [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"我要去升级" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //Push 跳转
        VersionUpViewController * VC = [[VersionUpViewController alloc]init];
        VC.url = model.url;
        // NSLog(@"我要去升级--%@",VC.url);
        [weakSelf presentViewController:VC animated:YES completion:nil];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fir.im/l874"]];
        
    }];
    [alertC addAction:cancel];
    [alertC addAction:OK];
    [_HomeVC presentViewController:alertC animated:YES completion:nil];
}




#pragma mark - 高德地图定位配置
-(void)AMap{
    if ([CLLocationManager locationServicesEnabled]  //确定用户的位置服务启用
        &&[CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        //位置服务是在设置中禁用
    {       UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:@"你的定位功能是禁用的请在设置中打开" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [_HomeVC presentViewController:alertView animated:YES completion:nil];
    }else {
        
    }
    self.locationManager = [AMapLocationManager new];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setLocationTimeout:6];
    [self.locationManager setReGeocodeTimeout:3];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        if (error)
        {
            //NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        if (location) {
            
            [defaults setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"Headerlat" ] ;
            [defaults setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"Headerlng" ] ;
            NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
            
            //业务处理
        }
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode.formattedAddress);
            [defaults setObject:regeocode.formattedAddress forKey:@"HeaderformattedAddress"];
            [defaults setObject:regeocode.province forKey:@"Headerprovince"];
            [defaults setObject:regeocode.city forKey:@"Headercity"];
            [defaults setObject:regeocode.district forKey:@"Headerdistrict"];
            
        }else{
            [defaults setObject:@"福建省福州市晋安区" forKey:@"HeaderformattedAddress"];
            [defaults setObject:@"福建省"forKey:@"Headerprovince"];
            [defaults setObject:@"福州市" forKey:@"Headercity"];
            [defaults setObject:@"晋安区" forKey:@"Headerdistrict"];
        }
        
    }];
    
}

#pragma mark - 关于手势和网络判断
-(void)gestrueViewAndInterView{
    NSString *Token =[AuthenticationModel getLoginToken];
    AppDelegate *del = (AppDelegate*)  [[UIApplication sharedApplication]delegate];
    if (Token.length!= 0) {
        //手势
        [del.window bringSubviewToFront:(UIView*)del.gestureView];
    }
    self.interView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, Width, 40)];
    self.interView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, Width-20, 20)];
    label.textColor = [UIColor whiteColor];
    label.text = @"网络请求失败,请检查您的网络设置";
    label.font = [UIFont systemFontOfSize:12];
    [_interView addSubview:label];
    _interView.alpha = 0;
    
    [del.window addSubview:_interView];
    [DWHelper NetWorksSateYESInter:^{
        [del.window sendSubviewToBack:_interView];
        _interView.alpha = 0;
    } NOInter:^{
        [del.window bringSubviewToFront:_interView];
        _interView.alpha = 1;
    }];
    
    
    
}

@end
