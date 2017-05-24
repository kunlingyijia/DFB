//
//  HistoryRevealedOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndianaUserSunModel;
@interface HistoryRevealedOneCell : UITableViewCell
///model
@property (nonatomic, strong) IndianaUserSunModel *model ;
@property (weak, nonatomic) IBOutlet UILabel *times_no;
@property (weak, nonatomic) IBOutlet UILabel *open_time;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *luck_no;
@property (weak, nonatomic) IBOutlet UILabel *number;







@end
