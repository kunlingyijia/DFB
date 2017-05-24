//
//  ImproveTicketCell.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/17.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImproveTicketCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *balance;      //金额
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;  //订单状态
@property (weak, nonatomic) IBOutlet UILabel *buyTime;      //购买时间
@property (weak, nonatomic) IBOutlet UILabel *content;      //内容
@property (weak, nonatomic) IBOutlet UILabel *name;         //抬头

@end
