//
//  LoadWaitView.m
//  自定义加载等待图
//
//  Created by 席亚坤 on 17/1/18.
//  Copyright © 2017年 席亚坤. All rights reserved.
//

#import "LoadWaitView.h"
#import "UIImage+GIF.h"
@interface LoadWaitView (){
    NSString * _image;
   
}

@end


@implementation LoadWaitView
- (instancetype)initWithimage:(NSString*)image
{  CGRect frame  = CGRectMake(([UIScreen mainScreen].bounds.size.width-bottomViewW)/2, ([UIScreen mainScreen].bounds.size.height-bottomViewH)/2, bottomViewW, bottomViewH);
   
    self = [super initWithFrame:frame];
    if (self) {
        _image = image;
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = bottomViewW/2;
        [self addSubViews];
    }
    return self;
}

-(void)addSubViews{
    self.bottomView = [[UIView alloc]initWithFrame:self.bounds];
    //_bottomView.center = self.center;
    _bottomView.layer.masksToBounds = YES;
    _bottomView.layer.cornerRadius = 5;
    //_bottomView.backgroundColor = [UIColor redColor];
    
    [self addSubview:_bottomView];
    self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    //_imageView.backgroundColor = [UIColor yellowColor];
   _imageView.image =[UIImage  sd_animatedGIFNamed:_image ];
    [_bottomView addSubview:_imageView];
    
}


@end
