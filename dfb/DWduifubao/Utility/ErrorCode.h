//
//  ErrorCode.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/9/20.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseResponse;

@interface ErrorCode : NSObject
- (void)showErrorCodeWithBaseResponse:(BaseResponse *)baseRes withBaseController:(BaseViewController *)vc;

@end
