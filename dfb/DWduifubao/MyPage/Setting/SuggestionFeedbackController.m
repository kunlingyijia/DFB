//
//  SuggestionFeedbackController.m
//  DWduifubao
//
//  Created by 月美 刘 on 16/9/21.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "SuggestionFeedbackController.h"
#import "RequestFeedback.h"

@interface SuggestionFeedbackController ()
@property (nonatomic, strong) EZTextView *contentView;   //意见编辑框
@end

@implementation SuggestionFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
    [self initWithCumstomView];
}

- (void)initWithCumstomView{
    UIView *feedBackView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, Width - 40, 160)];
    feedBackView.layer.borderWidth = 0.3;
    feedBackView.layer.borderColor = [UIColor colorWithHexString:kViewBackgroundColor].CGColor;
    feedBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:feedBackView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView = [[EZTextView alloc] initWithFrame:CGRectMake(0, 0, feedBackView.frame.size.width, 160)];
    self.contentView.font = [UIFont systemFontOfSize:15];
    self.contentView.placeholder = @"请输入小于200个字符反馈内容";
    
    self.contentView.textColor = [UIColor colorWithHexString:kTitleColor];
    self.contentView.font = [UIFont systemFontOfSize:ksecondTitleFont];
    [feedBackView addSubview:self.contentView];
    //设置反馈的按钮
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setBackgroundColor:[UIColor colorWithHexString:kRedColor]];
    sendBtn.frame = CGRectMake(20, 230, Width - 40, 44);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
}
//"发送"的按钮事件
- (void)sendBtnAction:(UIButton *)sender {
    
    if (self.contentView.text.length == 0) {
        
        [self alertWithTitle:@"提示" message:@"反馈内容不能为空" OKWithTitle:@"确定" withOKDefault:^(UIAlertAction *defaultaction) {
            
        }];
        
    }else if(self.contentView.text.length >200){
        
        [self alertWithTitle:@"提示" message:@"反馈内容必须小于200个字符" OKWithTitle:@"确定" withOKDefault:^(UIAlertAction *defaultaction) {
            
        }];
        
    }else{
        //调接口......
        [self requestAction];
    }
}



-(void)requestAction{
    NSString *Token =[AuthenticationModel getLoginToken];
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[@{@"content":self.contentView.text} yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        __weak typeof(self) weakSelf = self;
        self.view.userInteractionEnabled = NO;
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_Feedback sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            BaseResponse *baseRes = [BaseResponse yy_modelWithJSON:response];
            if (baseRes.resultCode == 1) {
                NSLog(@"%@",response);
                [weakSelf showToast:@"发送成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
                
            }else {
                weakSelf.view.userInteractionEnabled = YES;

                [weakSelf showToast:response[@"msg"]];
            }
            
            
            
        } faild:^(id error) {
            weakSelf.view.userInteractionEnabled = YES;
            NSLog(@"%@", error);
        }];
        
    }
    
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}

@end
