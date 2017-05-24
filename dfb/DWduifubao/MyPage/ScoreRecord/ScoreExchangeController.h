//
//  ScoreExchangeController.h
//  DWduifubao
//
//  Created by 月美 刘 on 16/10/26.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface ScoreExchangeController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *exchangeDFGlodView;   //"兑换兑富金币"的View
@property (weak, nonatomic) IBOutlet UIView *exchangeDFBaoView;    //"兑换兑富金币+兑富宝"的View
///总积分
@property (nonatomic, assign) NSInteger scoreAll;


@end
