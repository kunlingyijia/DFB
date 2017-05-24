//
//  OrderDetailOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/7.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface OrderDetailOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *order_no;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
///地址
@property (weak, nonatomic) IBOutlet UILabel *address;
-(void)cellGetData:(OrderModel*)model;
@end
