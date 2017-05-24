//
//  JHCoverView.h
//  支付
//
//  Created by zhou on 16/10/14.
//  Copyright © 2016年 zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTextField.h"
@class JHCoverView;

@protocol JHCoverViewDelegate <NSObject>

@optional

/**
 忘记密码
 */
- (void)forgetPassWordCoverView:(JHCoverView *)control;

/**
 重新输入密码
 */
- (void)inputCorrectCoverView:(JHCoverView *)control password:(NSString*)passWord;

/**
 密码错误
 */
- (void)coverView:(JHCoverView *)control;


@end

@interface JHCoverView : UIView

@property (nonatomic, strong) NewTextField *payTextField;

@property (nonatomic,weak) id<JHCoverViewDelegate> delegate;
///密码
@property (nonatomic, strong) NSString *Password ;


@end
