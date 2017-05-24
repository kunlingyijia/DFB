//
//  ScoreRecordCell.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScoreRecordModel;
@interface ScoreRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *amount;       //积分
@property (weak, nonatomic) IBOutlet UILabel *remark;       //积分来自哪里
@property (weak, nonatomic) IBOutlet UILabel *create_time;  //时间

-(void)cellGetData:(ScoreRecordModel*)model;

@end
