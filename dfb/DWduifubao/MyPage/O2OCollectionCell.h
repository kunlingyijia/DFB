//
//  O2OCollectionCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/15.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class O2OModel;
@interface O2OCollectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pay_icon;

@property (weak, nonatomic) IBOutlet UILabel *pay_name;
@property (weak, nonatomic) IBOutlet UILabel *draw_money;
///提现时间
@property (weak, nonatomic) IBOutlet UILabel *withdraw_time;

///单笔限额和
@property (weak, nonatomic) IBOutlet UILabel *limit;


-(void)cellGetData:(O2OModel*)model;
@end
