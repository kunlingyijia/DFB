//
//  OrderFooterView.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/5.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PublicBtn;
@class OrderModel;
@interface OrderFooterView : UITableViewHeaderFooterView
///oneBtn
@property (nonatomic, strong) PublicBtn  *oneBtn ;
///twoBtn
@property (nonatomic, strong) PublicBtn  *twoBtn ;

@property (strong, nonatomic)  UILabel *number;
@property (strong, nonatomic)  UILabel *allPrice;
-(void)cellGetData:(OrderModel*)model;
@end
