//
//  IndianaShopDetailsTwoCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/2.
//  Copyright © 2017年 bianming. All rights reserved.
//
#import <UIKit/UIKit.h>
@class last_timeModel;
@interface IndianaShopDetailsTwoCell : UITableViewCell
@property (nonatomic, copy) void(^IndianaShopDetailsTwoCellBlock)(NSInteger tag);
///model
@property (nonatomic, strong) last_timeModel *model ;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *win_name;
@property (weak, nonatomic) IBOutlet UILabel *luck_no;
@property (weak, nonatomic) IBOutlet UILabel *times_no;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *open_time;
@property (weak, nonatomic) IBOutlet UIImageView *avatar_url;




@end
