//
//  LogisticsOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface LogisticsOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *logistics_name;
@property (weak, nonatomic) IBOutlet UILabel *logistics_no;
-(void)cellGetData:(OrderModel*)model;
@end
