//
//  OrderDetailFourCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/7.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface OrderDetailFourCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *AllPrice;
@property (weak, nonatomic) IBOutlet UILabel *amount;
///运费状态
@property (weak, nonatomic) IBOutlet UILabel *freightStatusLabel;
///运费
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;

@property (weak, nonatomic) IBOutlet UILabel *remark;
-(void)cellGetData:(OrderModel*)model;

@end
