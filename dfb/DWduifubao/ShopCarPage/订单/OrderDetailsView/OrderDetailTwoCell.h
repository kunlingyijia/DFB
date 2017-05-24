//
//  OrderDetailTwoCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/7.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface OrderDetailTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *merchant_name;
-(void)cellGetData:(OrderModel*)model;
@end
