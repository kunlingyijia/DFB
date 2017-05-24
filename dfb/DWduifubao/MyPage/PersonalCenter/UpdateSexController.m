//
//  UpdateSexController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/10.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "UpdateSexController.h"
#import "PersonChangeModel.h"
@interface UpdateSexController ()

@end

@implementation UpdateSexController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self showBackBtn];
    self.title = @"修改性别";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    
    [self addtargetAction];
    //初始化赋值
    [self kongjianfuzhi];
    
}
#pragma mark -     //初始化赋值
-(void)kongjianfuzhi{
    if ([_gender isEqualToString:@"男"]) {
        self.chooseManBtn.hidden = NO;
        self.chooseWomanBtn.hidden = YES;
        self.chooseSecrecyBtn.hidden = YES;
    }else if ([_gender isEqualToString:@"女"]){
        self.chooseWomanBtn.hidden = NO;
        self.chooseManBtn.hidden = YES;
        self.chooseSecrecyBtn.hidden = YES;

    }else if ([_gender isEqualToString:@"保密"]){
        self.chooseSecrecyBtn.hidden = NO;
        self.chooseManBtn.hidden = YES;
        self.chooseWomanBtn.hidden = YES;
    }else{
        
    }
    
    
}
//为View添加点击事件
- (void)addtargetAction {
    //选择"男"
    UITapGestureRecognizer *chooseManViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseManViewAction:)];
    [self.chooseManView addGestureRecognizer:chooseManViewTap];
    //选择"女"
    UITapGestureRecognizer *chooseWomanViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseWomanViewAction:)];
    [self.chooseWomanView addGestureRecognizer:chooseWomanViewTap];
    //选择"保密"
    UITapGestureRecognizer *chooseSecrecyViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseSecrecyViewAction:)];
    [self.chooseSecrecyView addGestureRecognizer:chooseSecrecyViewTap];
}

//选择"男"的View事件
- (void)chooseManViewAction:(UITapGestureRecognizer *)sender {
    self.chooseManBtn.hidden = NO;
    self.chooseWomanBtn.hidden = YES;
    self.chooseSecrecyBtn.hidden = YES;
    //网络请求
    [self requestAction:1];
}

//选择"女"的View事件
- (void)chooseWomanViewAction:(UITapGestureRecognizer *)sender {
    self.chooseWomanBtn.hidden = NO;
    self.chooseManBtn.hidden = YES;
    self.chooseSecrecyBtn.hidden = YES;
    //网络请求
    [self requestAction:2];

}

//选择"保密"的View事件
- (void)chooseSecrecyViewAction:(UITapGestureRecognizer *)sender {
    self.chooseSecrecyBtn.hidden = NO;
    self.chooseManBtn.hidden = YES;
    self.chooseWomanBtn.hidden = YES;
    //网络请求
    [self requestAction:3];

}
-(void)requestAction:(int)inter{
    //控件赋值
    PersonChangeModel * model = [[PersonChangeModel alloc ]init ];
    model.gender = inter;
    if (inter == 1) {
        self.gender = @"1" ;
    }else if (inter == 2){
        self.gender = @"2" ;
    }else if (inter == 3){
        self.gender = @"3" ;
    }
    
   NSString *Token =[AuthenticationModel getLoginToken];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[model yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:@"act=Api/User/requestUpdateUserInfo" sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"-------------%@",response);
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1){
                if ([weakself.delegate respondsToSelector:@selector(changesex:)]) {
                    [weakself.delegate changesex:inter];
                }
                [weakself showToast:@"修改成功"];
                [weakself.navigationController popViewControllerAnimated:YES];
            }else {
                [weakself showToast:response[@"msg"]];
            }
  
        } faild:^(id error) {
            NSLog(@"%@", error);
            
        }];
        
    }
   

}




@end
