//
//  BaseWebViewController.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface BaseWebViewController : BaseViewController
//定义一个属性，方便外接调用
@property (nonatomic, strong) UIWebView *webView;
//声明一个方法，外接调用时，只需要传递一个URL即可
- (void)loadHTML:(NSString *)htmlString;
@end
