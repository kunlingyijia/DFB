//
//  IndianaHeaderView.h
//  DWduifubao
//
//  Created by kkk on 16/9/9.
//  Copyright © 2016年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IndianaHeaderViewDelegate <NSObject>
//点击分类
- (void)selectedClassKindWithIndex:(NSInteger)index;

@end




@interface IndianaHeaderView : UICollectionReusableView

@property (nonatomic, weak)id<IndianaHeaderViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)createView;



@end
