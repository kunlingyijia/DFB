//
//  MerchantOrderListCell.h
//  自定义弹窗
//
//  Created by 席亚坤 on 17/3/16.
//  Copyright © 2017年 席亚坤. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface MerchantOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UILabel *create_time;

@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *ChaKan;


-(void)cellGetData:(OrderModel*)model;
@end
