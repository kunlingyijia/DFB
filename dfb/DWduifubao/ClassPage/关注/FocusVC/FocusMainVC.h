//
//  FocusMainVC.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/1/2.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "BaseViewController.h"

@interface FocusMainVC : BaseViewController
<UIScrollViewDelegate>

@property (strong, nonatomic)  UIScrollView *mainScrollView;
///红色View
@property (nonatomic, strong) UIView  *RedView ;
///titleView
@property (nonatomic, strong) UIView  *titleView ;


///属性传值
@property (nonatomic, strong) NSString  *titlestr ;


@end
