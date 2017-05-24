//
//  NavigationView.m
//  DWduifubao
//
//  Created by 席亚坤 on 16/10/27.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import "NavigationView.h"

@implementation NavigationView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
-(void)layoutSubviews{
    CGRect  Frame = self.frame;
    Frame.size.width = Width;
    Frame.size.height = 64;
    self.frame = Frame;
}
- (IBAction)SaoYiSaoAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(NavErWeiMaPush)]) {
        [self.delegate NavErWeiMaPush];
    }
}
- (IBAction)SouSuoKuangAction:(UIButton *)sender {   if ([self.delegate respondsToSelector:@selector(NavSouSuoPush)]) {
    [self.delegate NavSouSuoPush];
    }
   
}
- (IBAction)XiaoXiAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(NavMassagePush)]) {
        [self.delegate NavMassagePush];
    }

}
@end
