//
//  CalulatorBtn.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/11/14.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "CalulatorBtn.h"

@implementation CalulatorBtn

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        self.layer.borderColor = [UIColor grayColor].CGColor ;
        self.layer.borderWidth = 0.3;
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        
        
    }
    return self;
}


@end
