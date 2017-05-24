//
//  IndianaMyTwoCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/28.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndianaUserSunModel;
@interface IndianaMyTwoCell : UITableViewCell
///model
@property (nonatomic, strong) IndianaUserSunModel *model ;
@property (weak, nonatomic) IBOutlet UIImageView *avatar_url;
@property (weak, nonatomic) IBOutlet UILabel *nick_name;
@property (weak, nonatomic) IBOutlet UILabel *create_time;

@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *times_no;
@property (weak, nonatomic) IBOutlet UILabel *content;


@end
