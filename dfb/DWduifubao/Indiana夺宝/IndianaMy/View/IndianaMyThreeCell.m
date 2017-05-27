//
//  IndianaMyThreeCell.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/30.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaMyThreeCell.h"
#import "HotSubCell.h"


@interface IndianaMyThreeCell ()
///数据
@property (nonatomic,strong)NSMutableArray * dataArray;
@end
@implementation IndianaMyThreeCell
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }return _dataArray;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //[self addSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self addSubViews];
        
    }
    return self;
}
-(void)addSubViews{
    self.count = 0;
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //配置布局对象的属性
        //设置cell的大小 ------ item
        flowLayout.itemSize = CGSizeMake((Width-50)/4, (Width-50)/4);
        // CGFloat xx = ([UIScreen mainScreen].bounds.size.width-240)/5;
        //NSLog(@"%f",xx);
        //设置分区的边界
        flowLayout.sectionInset = UIEdgeInsetsMake(10 , 10, 10, 10);
        //设置行间距
        flowLayout.minimumLineSpacing = 10;
        //设置两个item之间的距离
        flowLayout.minimumInteritemSpacing =0;
        //设置滚动的方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (Width-50)/4+20) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //_collectionView.pagingEnabled = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        //注册
        
        [self.collectionView collectionViewregisterNibArray:@[@"HotSubCell"]];
        [self.contentView addSubview: _collectionView];
    }
    
    
    
}

#pragma mark --集合视图代理方法
//集合视图分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//集合视图分区内item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.count;
}
//item 配置
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotSubCell" forIndexPath:indexPath];
//    GoodsModel * model    = self.dataArray[indexPath.row];
//    [DWHelper SD_WebImage:cell.activity_img imageUrlStr:model.activity_img placeholderImage:nil];
    NSString * st =self.dataArray[indexPath.row];
    cell.activity_img .backgroundColor = [UIColor redColor];
   
    [DWHelper SD_WebImage:cell.activity_img  imageUrlStr:st placeholderImage:nil];
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"++++%ld",indexPath.row);
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//    browser.currentImageIndex = indexPath.row;
//    browser.sourceImagesContainerView = self.collectionView;
//    browser.imageCount = self.dataArray.count;
//    browser.delegate = self;
//    [browser show];
    
    self.IndianaMyThreeCellBlock(indexPath.row);
}



-(void)CellGetData:(NSMutableArray*)Arr{
    self.count = Arr.count;
    self.dataArray = Arr;
   // [self.collectionView reloadData];
    if (!_picContainerView) {
        self.picContainerView = [[YHWorkGroupPhotoContainer alloc] initWithWidth:Width-20];
        CGFloat picContainerH = [self.picContainerView setupPicUrlArray:self.dataArray];
        self.picContainerView.picOriArray = self.dataArray;
        self.picContainerView.frame = CGRectMake(10, 10, Width-20, picContainerH);
        self.picContainerView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.picContainerView];
    }else{
        CGFloat picContainerH = [self.picContainerView setupPicUrlArray:self.dataArray];
        self.picContainerView.picOriArray = self.dataArray;
        self.picContainerView.frame = CGRectMake(10, 10, Width-20, picContainerH);
    }
}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSURL *url = [NSURL new];
    NSString * str =self.dataArray[index];
    if (index < self.dataArray.count) {
        url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",str] ];
    }
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    HotSubCell *cell = ( HotSubCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
   
    
    
    
    //UIImageView *imageView = self.subviews[index];
    return cell.activity_img.image;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //Cell背景颜色
    self.contentView.backgroundColor = [UIColor whiteColor];
    //cell选中时的颜色 无色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //Cell右侧箭头
    //self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    self.separatorInset = UIEdgeInsetsMake(0, Width, 0, 0); // ViewWidth  [宏] 指的是手机屏幕的宽度
}

@end
