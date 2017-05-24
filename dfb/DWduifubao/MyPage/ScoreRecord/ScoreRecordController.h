//
//  ScoreRecordController.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface ScoreRecordController : BaseViewController
///总积分score
@property (nonatomic, assign) NSInteger scoreAll;


@property (weak, nonatomic) IBOutlet UILabel *score;  //总积分
@end
