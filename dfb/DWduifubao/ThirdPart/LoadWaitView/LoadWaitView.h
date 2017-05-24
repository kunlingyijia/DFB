//
//  LoadWaitView.h
//  自定义加载等待图
//
//  Created by 席亚坤 on 17/1/18.
//  Copyright © 2017年 席亚坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#define bottomViewW bottomViewH
#define bottomViewH 30
@interface LoadWaitView : UIView


///底图
@property (nonatomic, strong) UIView * bottomView;
///imageView
@property (nonatomic, strong) UIImageView * imageView;
- (instancetype)initWithimage:(NSString*)image;
@end
