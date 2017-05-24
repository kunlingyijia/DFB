//
//  O2OMainOneCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class O2OModel;
@interface O2OMainOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *last_o2o_money;
@property (weak, nonatomic) IBOutlet UILabel *current_o2o_money;
@property (weak, nonatomic) IBOutlet UIButton *ShouKuanBtn;
@property (weak, nonatomic) IBOutlet UILabel *draw_money;

@property (weak, nonatomic) IBOutlet UIButton *TiXianBtn;
-(void)cellGetdata:(O2OModel*)model;
@end
