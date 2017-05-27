//
//  BaseViewController.m
//  DWduifubao
//
//  Created by kkk on 16/9/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"
#import "UIView+Toast.h"
#import "LoadWaitSingle.h"
@interface BaseViewController ()


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];

}
- (void)showBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"夺宝-箭头-左.png"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
#pragma mark ----- 屏幕边缘平移手势
    
    //屏幕边缘移动手势
    //创建屏幕边缘平移手势
        UIScreenEdgePanGestureRecognizer *screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(doBack:)];
        
        //设置平移的屏幕边界
        
        screenEdgePanGesture.edges = UIRectEdgeLeft;
        //添加到视图
        
        [self.view addGestureRecognizer:screenEdgePanGesture];
  
}


- (void)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)showBackBtn:(ObjectBack)Back{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"夺宝-箭头-左.png"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(doBlockBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
#pragma mark ----- 屏幕边缘平移手势
    
    //屏幕边缘移动手势
    //创建屏幕边缘平移手势
    UIScreenEdgePanGestureRecognizer *screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(doBlockBack:)];
    
    //设置平移的屏幕边界
    
    screenEdgePanGesture.edges = UIRectEdgeLeft;
    //添加到视图
    
    [self.view addGestureRecognizer:screenEdgePanGesture];
    self.Back = Back;
}


- (void)doBlockBack:(id)sender{
    self.Back();
}



#pragma mark - 右侧
-(void)ShowRightBtnTitle:(NSString*)tilte Back:(ObjectBack)Back{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 80, 40);
    
    [backBtn setTitle:tilte forState:(UIControlStateNormal)];
    [backBtn setTitleColor:[UIColor colorWithHexString:ksubTitleColor] forState:(UIControlStateNormal)];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backBtn addTarget:self action:@selector(RightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = backItem;
    
    self.Back = Back;
}
#pragma mark - popRootdoBack点击事件
-(void)RightBtn:(UIButton*)sender{
    
     self.Back();
}




-(void)ShowNodataView{
    if (!_baseBottomView) {
        __weak typeof(self) weakSelf = self;
        self.baseBottomView = [[UIView alloc]initWithFrame:CGRectZero];
        [UIView animateWithDuration:0.0000001 animations:^{
            weakSelf.baseBottomView.frame =  CGRectMake(0, 0, Width, Height);
            self.baseBottomView.backgroundColor = [UIColor colorWithHexString:kViewBackgroundColor];
            [self.view addSubview:_baseBottomView];
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
            imageView.image = [UIImage imageNamed:@"暂无数据"];
            imageView.contentMode =  UIViewContentModeCenter;
            imageView.clipsToBounds  = YES;
            [_baseBottomView addSubview:imageView];
        } ];
       
        
    }
}
-(void)HiddenNodataView{
    
    if (_baseBottomView) {
 __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.1 animations:^{
            [_baseBottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            weakSelf.baseBottomView.alpha = 0.0;
        } completion:^(BOOL finished) {
             [weakSelf.baseBottomView removeFromSuperview];
            weakSelf.baseBottomView = nil;
        }];
       
    }
    
}

- (void)popRootshowBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.backgroundColor = [UIColor redColor];
    [backBtn setImage:[UIImage imageNamed:@"夺宝-箭头-左"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(popRootdoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationController.navigationBar.translucent = NO;
   
}

- (void)popRootdoBack:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//回收键盘
- (void)endEditingAction:(UIView *)endView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endtapAction:)];
    [endView addGestureRecognizer:tap];
}

- (void)endtapAction:(UITapGestureRecognizer *)sender {
    UIView *endV = sender.view;
    [endV endEditing:YES];
}

- (void)showSuccessWith:(NSString *)str {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showToast:str];
    });
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];//("PageOne"为页面名称，可自定义)
    self.view.userInteractionEnabled = YES;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [MobClick endLogPageView:@"PageOne"];
    [SVProgressHUD dismiss];
    [[LoadWaitSingle shareManager] hideLoadWaitView];
    [self HiddenNodataView];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWithDefaultProgressHub{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

- (void)showProgress{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"加载中..."];
}

- (void)showProgressWithText:(NSString *)text{
    [SVProgressHUD showWithStatus:text];
}

- (void)hideProgress{
    [SVProgressHUD dismiss];
}

- (void)showSucessProgress{
    [SVProgressHUD showInfoWithStatus:@"成功！"];
}

- (void)showSucessProgressWithText:(NSString *)text{
    [SVProgressHUD showInfoWithStatus:text];
}

- (void)showErrorProgress{
    [SVProgressHUD showErrorWithStatus:@"失败"];
}

- (void)showErrorProgressWithText:(NSString *)text{
    [SVProgressHUD showErrorWithStatus:text];
}

- (void)showToast:(NSString *)text{
    [self.view hideToastActivity];
    [self.view makeToast:text duration:2 position:CSToastPositionCenter];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - 取消确定 --居中
-(void)alertWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle  CancelWithTitle:(NSString*)Canceltitle withOKDefault:(OKDefault)defaultaction withCancel:(Cancel)cancelaction{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:OKtitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultaction (action);
        
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Canceltitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        cancelaction (action);
    }];
    [alertC addAction:OK];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
    
}
#pragma mark - 单个确定
-(void)alertWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle   withOKDefault:(OKDefault)defaultaction{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:OKtitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        defaultaction (action);
    }];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];

}

#pragma mark - 取消确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle  CancelWithTitle:(NSString*)Canceltitle withOKDefault:(OKDefault)defaultaction withCancel:(Cancel)cancelaction{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:OKtitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultaction (action);
        
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Canceltitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        cancelaction (action);
    }];
    [alertC addAction:OK];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
#pragma mark - 取消-确定-确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitleOne:(NSString*)OKtitleOne OKWithTitleTwo:(NSString*)OKtitleTwo  CancelWithTitle:(NSString*)Canceltitle withOKDefaultOne:(OKDefault)defaultactionOne withOKDefaultTwo:(OKDefault)defaultactionTwo withCancel:(Cancel)cancelaction{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction * OKOne = [UIAlertAction actionWithTitle:OKtitleOne style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultactionOne (action);
        
        
    }];
    //[OKOne setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    UIAlertAction * OKTwo = [UIAlertAction actionWithTitle:OKtitleTwo style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        defaultactionTwo (action);
        
        
    }];
    //[OKTwo setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Canceltitle style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        cancelaction (action);
    }];
    //[cancel setValue:[UIColor colorWithHexString:kNavigationBgColor] forKey:@"_titleTextColor"];
    
    [alertC addAction:OKOne];
    [alertC addAction:OKTwo];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}

@end
