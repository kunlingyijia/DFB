//
//  SelectHomeCell.h
//  DWduifubao
//
//  Created by 席亚坤 on 17/3/17.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectHomeCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
///HotHomeCellBlock
@property (nonatomic, copy) void(^SelectHomeCellBlock)(NSInteger tag) ;
///
@property (nonatomic, strong) UICollectionView  *collectionView ;
-(void)CellGetData:(NSMutableArray*)Arr;
///
@property (nonatomic, assign) NSInteger count;
@end
