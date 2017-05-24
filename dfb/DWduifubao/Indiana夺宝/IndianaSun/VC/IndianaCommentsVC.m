//
//  IndianaCommentsVC.m
//  DWduifubao
//
//  Created by 席亚坤 on 17/4/28.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "IndianaCommentsVC.h"
#import "TZTestCell.h"
#import "LxGridViewFlowLayout.h"
#import "IndianaUserSunModel.h"
#import "LoginController.h"
@interface IndianaCommentsVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate, TZImagePickerControllerDelegate>
/** 显示选择的图片 collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
/** 图片 collectionView 高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
/** 图片数组 */
@property (nonatomic, strong) NSMutableArray *imageArray;
/** asset 数组，用以确定已选中的图片 */
@property (nonatomic, strong) NSMutableArray *assetArray;
///匿名Btn
@property (weak, nonatomic) IBOutlet UIButton *anonymousBtn;

@property (weak, nonatomic) IBOutlet EZTextView *contentTextView;



@property (weak, nonatomic) IBOutlet UIImageView *goods_image;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *times_no;
@property (weak, nonatomic) IBOutlet UILabel *allNumber;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation IndianaCommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //UI
    [self SET_UI];
    //数据
    [self  SET_DATA];
    
}
#pragma mark - 关于UI
-(void)SET_UI{
    self.title = @"发表评论";
    self.contentTextView.placeholder = @"请写下对宝贝的评价,对他人帮助很大哦";
    self.submitBtn.backgroundColor = [UIColor grayColor];
    [self.goods_image.layer setLaberMasksToBounds:YES cornerRadius:5.0 borderWidth:0.8 borderColor:[UIColor colorWithHexString:kViewBackgroundColor]];
    __weak typeof(self) weakSelf = self;
    [self showBackBtn:^{
        [weakSelf alertWithTitle:@"亲,评论尚未完成,您确定要离开?" message:nil OKWithTitle:@"确定" CancelWithTitle:@"取消" withOKDefault:^(UIAlertAction *defaultaction) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } withCancel:^(UIAlertAction *cancelaction) {
            
        }];
    }];
     [self setupCollectionView];
    
    
}
#pragma mark - 关于数据
-(void)SET_DATA{
    
    [self.goods_image SD_WebimageUrlStr:self.UserSunModel.goods_image placeholderImage:nil];
    self.goods_name.text = self.UserSunModel.goods_name;
    self.times_no.text =[NSString stringWithFormat:@"第%@期", self.UserSunModel.times_no];
    self.allNumber.text =[NSString stringWithFormat:@"此单参与%@人次", self.UserSunModel.number];
    NSLog(@"%@",[self.UserSunModel yy_modelToJSONObject]);
    
    
    
    
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length>0) {
        self.submitBtn.backgroundColor = [UIColor redColor];
        self.submitBtn.userInteractionEnabled = YES;
    }else{
        self.submitBtn.backgroundColor = [UIColor grayColor];
        self.submitBtn.userInteractionEnabled = NO;
 
    }
    
    
    
    
    
}
#pragma mark - 匿名评价
- (IBAction)anonymousAction:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    if (sender.selected ==YES) {
        
    }else{
        
    }
}



#pragma mark - 网络请求
-(void)requestAction:(NSMutableArray*)imageArr{
    NSString *Token =[AuthenticationModel getLoginToken];
    //NSLog(@"Token----- %@",Token);
   self.UserSunModel.content = self.contentTextView.text;
   self. UserSunModel.images = imageArr.count>0 ?imageArr :[@[] mutableCopy];
    __weak typeof(self) weakself = self;
    if (Token.length!= 0) {
        BaseRequest *baseReq = [[BaseRequest alloc] init];
        baseReq.token = [AuthenticationModel getLoginToken];
        baseReq.encryptionType = AES;
        baseReq.data = [AESCrypt encrypt:[_UserSunModel yy_modelToJSONString] password:[AuthenticationModel getLoginKey]];
        [[DWHelper shareHelper] requestDataWithParm:[baseReq yy_modelToJSONString] act:Request_DbAddComment sign:[baseReq.data MD5Hash] requestMethod:GET PushVC:self success:^(id response) {
            NSLog(@"发表评论----%@",response);
            if ([response[@"resultCode"] isEqualToString:@"1"]) {
                weakself.IndianaCommentsVCBlock();
                [weakself showToast:@"评论成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [weakself showToast:response[@"msg"]];
                weakself.view.userInteractionEnabled = YES;

            }
            
            
        } faild:^(id error) {
            weakself.view.userInteractionEnabled = YES;

            NSLog(@"%@", error);
        }];
        
    }else {
        [self  pushLoginController];
    }
    
    
}



#pragma mark - 发表评论
- (IBAction)publishedCommentAction:(UIButton *)sender {
   [self.view endEditing:YES];
    if ( [self IF]) {
        __weak typeof(self) weakSelf = self;
        self.view.userInteractionEnabled = NO;
        if (self.imageArray.count>0) {
            [[DWHelper shareHelper]UPImageToServer:self.imageArray toKb:70 success:^(NSArray *urlArr) {
                NSMutableArray * arr =[NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dic in urlArr) {
                    [arr addObject:dic[@"url"]];
                }
                [weakSelf requestAction:arr];
            } faild:^(id error) {
                weakSelf.view.userInteractionEnabled = YES;
            }];
        }else{
           [weakSelf requestAction:[@[]mutableCopy]];
        }
    }
    
    
}








#pragma mark - 判断条件
-(BOOL)IF{
    
    BOOL  Y = YES;
    if (self.contentTextView.text .length>140) {
        [self showToast:@"评论字数最多140个字符"];
        return NO;
    }
       return Y;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCollectionView" forIndexPath:indexPath];
    if (indexPath.row == self.imageArray.count) {
        cell.imageView.image = [UIImage imageNamed:@"goods_add_plus"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = self.imageArray[indexPath.row];
        cell.deleteBtn.hidden = NO;
        
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.row >= self.imageArray.count) {
        [self pushImagePickerViewController];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    self.imageArray = [NSMutableArray arrayWithArray:photos];
    self.assetArray = [NSMutableArray arrayWithArray:assets];
    [self.imageCollectionView reloadData];
    [self setupCollectionViewHeight];
}

/**
 collectionView 图片删除按钮点击事件处理
 
 @param btn 删除按钮
 */
- (void)deleteBtnClik:(UIButton *)btn {
    NSInteger index = btn.tag;
    [self.imageArray removeObjectAtIndex:index];
    // 编辑时无 asset 对象
    if (self.assetArray.count) {
        [self.assetArray removeObjectAtIndex:index];
    }
    
    [self.imageCollectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.imageCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.imageCollectionView reloadData];
        [self setupCollectionViewHeight];
    }];
}

#pragma mark - lazy init

- (NSMutableArray *)assetArray {
    if (!_assetArray) {
        _assetArray = [[NSMutableArray alloc] init];
    }
    return _assetArray;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}


/**
 设置 collectionView 的各属性
 */
- (void)setupCollectionView {
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    layout.panGestureRecognizerEnable = YES;
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    CGFloat WH = (Width - 50) / 4.f;
    layout.itemSize = CGSizeMake(WH, WH);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.imageCollectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"imageCollectionView"];
    self.imageCollectionView.collectionViewLayout = layout;
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    [self setupCollectionViewHeight];
}
#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < self.imageArray.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < self.imageArray.count && destinationIndexPath.item < self.imageArray.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = self.imageArray[sourceIndexPath.item];
    PHAsset *asset = self.assetArray[sourceIndexPath.item];
    [self.imageArray removeObjectAtIndex:sourceIndexPath.item];
    [self.imageArray insertObject:image atIndex:destinationIndexPath.item];
    [self.assetArray removeObjectAtIndex:sourceIndexPath.item];
    [self.assetArray insertObject:asset atIndex:destinationIndexPath.item];
    [self.imageCollectionView reloadData];
}
#pragma mark - others

/**
 push 图片选择控制器
 */
- (void)pushImagePickerViewController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.selectedAssets = self.assetArray;
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO;
    //imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 更新 collectionView 高度
 */
- (void)setupCollectionViewHeight {
    NSInteger row = ceil((self.imageArray.count + 1) / 4.0);
    self.collectionViewHeight.constant = (Width - 20) / 4.0 * row + 20;
}

#pragma mark-- 跳转到登录界面
-(void)pushLoginController{
    //Push 跳转
    LoginController * VC = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
    [VC LoginRefreshAction:^{
        
    }];
    [self.navigationController  pushViewController:VC animated:YES];
    
    
}
#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%@销毁了", [self class]);
}





@end
