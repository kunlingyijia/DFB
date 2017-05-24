//
//  OrderDetailFiveCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/7.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface OrderDetailFiveCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeDetails;
-(void)cellGetData:(OrderModel*)model;
@end
