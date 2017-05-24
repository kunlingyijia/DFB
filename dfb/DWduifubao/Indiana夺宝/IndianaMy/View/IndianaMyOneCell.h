//
//  IndianaMyOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/28.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndianaUserSunModel;
@interface IndianaMyOneCell : UITableViewCell
@property (nonatomic, copy) void(^IndianaMyOneCellBlock)(NSInteger tag);
@property (weak, nonatomic) IBOutlet PublicBtn *OneBtn;
@property (weak, nonatomic) IBOutlet PublicBtn *Two;
///model
@property (nonatomic, strong) IndianaUserSunModel *model ;
@property (weak, nonatomic) IBOutlet UIImageView *goods_image;

@property (weak, nonatomic) IBOutlet UILabel *goods_name;

@property (weak, nonatomic) IBOutlet UILabel *countsAndtimes_no;

@property (weak, nonatomic) IBOutlet UILabel *nick_nameAndluck_no;
@property (weak, nonatomic) IBOutlet UILabel *numberAndopen_time;

@property (weak, nonatomic) IBOutlet UILabel *stadus;

@end
