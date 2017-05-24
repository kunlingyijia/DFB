//
//  O2OMainTwoCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class O2OModel;
@interface O2OMainTwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pay_iconImg;
@property (weak, nonatomic) IBOutlet UILabel *pay_title;


@property (weak, nonatomic) IBOutlet UILabel *order_no;
@property (weak, nonatomic) IBOutlet UILabel *amount;


@property (weak, nonatomic) IBOutlet UILabel *pay_time;
@property (weak, nonatomic) IBOutlet UILabel *status;
-(void)cellGetData:(O2OModel*)model;
@end
