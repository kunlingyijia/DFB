//
//  CalculationDetailsOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/5/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndianaUserSunModel;
@interface CalculationDetailsOneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *create_time;
@property (weak, nonatomic) IBOutlet UILabel *luck_no;

@property (weak, nonatomic) IBOutlet UILabel *nick_name;


///model
@property (nonatomic, strong) IndianaUserSunModel *model ;
@end
