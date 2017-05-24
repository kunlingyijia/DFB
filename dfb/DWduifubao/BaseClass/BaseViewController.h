//
//  BaseViewController.h
//  DWduifubao
//
//  Created by kkk on 16/9/8.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OKDefault)(UIAlertAction*defaultaction);
typedef void(^Cancel)(UIAlertAction *cancelaction);
typedef void(^ObjectBack)();

@interface BaseViewController : UIViewController
///ObjectBack
@property (nonatomic, copy) ObjectBack  Back ;
@property(nonatomic,strong)UIView * baseBottomView;

- (void)showBackBtn;
- (void)showBackBtn:(ObjectBack)Back;
- (void)popRootshowBackBtn;

#pragma mark - 右侧
-(void)ShowRightBtnTitle:(NSString*)tilte Back:(ObjectBack)Back;

-(void)ShowNodataView;
-(void)HiddenNodataView;
//回收键盘
- (void)endEditingAction:(UIView *)endView;
- (void)showSuccessWith:(NSString *)str;
- (void)showProgress;
- (void)showProgressWithText:(NSString *)text;
- (void)showSucessProgress;
- (void)showSucessProgressWithText:(NSString *)text;
- (void)showErrorProgress;
- (void)showErrorProgressWithText:(NSString *)text;
- (void)hideProgress;
- (void)showToast:(NSString *)text;
///取消确定 --居中
-(void)alertWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle  CancelWithTitle:(NSString*)Canceltitle withOKDefault:(OKDefault)defaultaction withCancel:(Cancel)cancelaction;
///单个确定
-(void)alertWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle   withOKDefault:(OKDefault)defaultaction;
///取消确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitle:(NSString*)OKtitle  CancelWithTitle:(NSString*)Canceltitle withOKDefault:(OKDefault)defaultaction withCancel:(Cancel)cancelaction;

///取消-确定-确定 --居下
-(void)alertActionSheetWithTitle:(NSString*)title message:(NSString*)message OKWithTitleOne:(NSString*)OKtitleOne OKWithTitleTwo:(NSString*)OKtitleTwo  CancelWithTitle:(NSString*)Canceltitle withOKDefaultOne:(OKDefault)defaultactionOne withOKDefaultTwo:(OKDefault)defaultactionTwo withCancel:(Cancel)cancelaction;
@end
