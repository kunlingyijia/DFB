//
//  AdViewController.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "AdViewController.h"
#import "AdModel.h"
#import "DWTabBarController.h"

@interface AdViewController (){
   int secondsCountDown; //倒计时总时长
   NSTimer *countDownTimer;
}
@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.label.layer.masksToBounds = YES;
    self.label.layer.cornerRadius = 15;
    //数据请求
    [self requestAction];
    //倒计时
    [self daojishi];
    
   
}
-(void)requestAction{
    if (((NSString*)[[NSUserDefaults standardUserDefaults]objectForKey:@"ADimage_url"]).length != 0) {
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"ADimage_url"]] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    AdModel *model = [[AdModel alloc]init];
    model.region_id = 1;
    model.position = 1;
    BaseRequest *baseReq = [[BaseRequest alloc] init];
    baseReq.token = [AuthenticationModel getLoginToken];
    baseReq.encryptionType = RequestMD5;
    baseReq.data = model;
    __weak typeof(self) weakself = self;
    [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/Ad/requestAd" sign:[[baseReq.data yy_modelToJSONString] MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
        BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
         NSLog(@"%@", response);
        if (baseRes.resultCode == 1) {
           
            NSArray * arr = response[@"data"];
            NSString * image_url = arr[0][@"image_url"];
            NSLog(@"%@", [[NSUserDefaults standardUserDefaults]objectForKey:@"ADimage_url"]);
            
            if (((NSString*)[[NSUserDefaults standardUserDefaults]objectForKey:@"ADimage_url"]).length==0) {
                 [[NSUserDefaults standardUserDefaults]setObject:image_url forKey:@"ADimage_url"];
                [weakself.imageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"ADimage_url"]] placeholderImage:[UIImage imageNamed:@""]];
            }else{
               [[NSUserDefaults standardUserDefaults]setObject:image_url forKey:@"ADimage_url"];
            }
            
            
           
            
            
            
        }else {
            [self showToast:response[@"msg"]];
            
        }
    } faild:^(id error) {
        NSLog(@"%@", error);
    }];


}

-(void)daojishi{
    //设置倒计时总时长
    secondsCountDown = 3;//60秒倒计时
    //开始倒计时
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    
    //设置倒计时显示的时间
    self.label.text=[NSString stringWithFormat:@"%d秒",secondsCountDown];
}
-(void)timeFireMethod{
    //倒计时-1
    secondsCountDown--;
    //修改倒计时标签现实内容
    self.label.text=[NSString stringWithFormat:@"%d秒",secondsCountDown];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [countDownTimer invalidate];
        DWTabBarController* tabbar = [[DWTabBarController alloc]init];
        [self presentViewController:tabbar animated:NO completion:NULL];
    
    }
}
- (IBAction)BtnAction:(UIButton *)sender {
     [countDownTimer invalidate];
     DWTabBarController* tabbar = [[DWTabBarController alloc]init];
     [self presentViewController:tabbar animated:NO completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
