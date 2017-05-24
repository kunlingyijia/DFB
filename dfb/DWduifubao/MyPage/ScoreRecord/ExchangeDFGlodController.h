//
//  ExchangeDFGlodController.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface ExchangeDFGlodController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *score;              //总积分
@property (weak, nonatomic) IBOutlet UITextField *exchangeScore;  //兑换积分
@property (weak, nonatomic) IBOutlet UILabel *to_dfglod;          //获得兑富金币

- (IBAction)exchangeBtnAction:(id)sender;  //"兑换"的按钮事件
///总积分
@property (nonatomic, assign) NSInteger scoreAll;
@end
