//
//  OrderHeaderView.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/5.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PublicBtn;
@class OrderModel;
@interface OrderHeaderView : UITableViewHeaderFooterView
///店名
@property (strong, nonatomic)  UILabel *merchant_name;
///状态
@property (strong, nonatomic)  UILabel *status;
-(void)cellGetData:(OrderModel*)model;
@end
