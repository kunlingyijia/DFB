//
//  SubmitOrderHeaderView.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/6.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeaderModel;
@interface SubmitOrderHeaderView : UITableViewHeaderFooterView
///店名
@property (strong, nonatomic)  UILabel *merchant_name;
-(void)cellGetData:(HeaderModel*)model;
@end
