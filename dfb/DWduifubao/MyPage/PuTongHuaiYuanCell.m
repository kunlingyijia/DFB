//
//  PuTongHuaiYuanCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/1.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "PuTongHuaiYuanCell.h"

@implementation PuTongHuaiYuanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.Views.layer.borderWidth = 1;
    self.Views.layer.borderColor = [UIColor grayColor].CGColor;
    self.oneBtn.layer.borderWidth = 0.5;
    self.oneBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.twoBtn.layer.borderWidth = 0.5;
    self.twoBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.threeBtn.layer.borderWidth = 0.5;
    self.threeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.fourBtn.layer.borderWidth = 0.5;
    self.fourBtn.layer.borderColor = [UIColor grayColor].CGColor;

}

@end
