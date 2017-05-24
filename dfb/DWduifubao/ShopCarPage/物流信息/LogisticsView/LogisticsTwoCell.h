//
//  LogisticsTwoCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/12/29.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LogisticsModel;
@interface LogisticsTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *LogisticsImageview;
@property (weak, nonatomic) IBOutlet UILabel *context;

@property (weak, nonatomic) IBOutlet UILabel *time;
-(void)cellGetData:(LogisticsModel*)model;
@end
