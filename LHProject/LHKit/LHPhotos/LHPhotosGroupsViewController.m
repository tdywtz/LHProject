//
//  LHPhotosGroupsViewController.m
//  photos
//
//  Created by bangong on 16/3/7.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHPhotosGroupsViewController.h"
#import <Photos/Photos.h>
#import "LHPhotosViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LHGroupsCell : UITableViewCell

@end

@implementation LHGroupsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5, 1, self.frame.size.height-2, self.frame.size.height-2);
    
    CGRect rect1 = self.textLabel.frame;
    rect1.origin.x = self.imageView.frame.size.width+10;
    self.textLabel.frame = rect1;
    
    CGRect rect2 = self.detailTextLabel.frame;
    rect2.origin.x = rect1.origin.x;
    self.detailTextLabel.frame = rect2;

}
@end

#pragma mark - //////////////////////////////////////////////// \

@interface LHPhotosGroupsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation LHPhotosGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArray = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0);
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    [self enable];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
   // [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"groupsCell"];
    
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        if (assetCollection) {
            [_dataArray addObject:assetCollection];
       }
    }
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    if (cameraRoll) {
         [_dataArray addObject:cameraRoll];
    }
   
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(double)0.3 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}

-(void)rightItemClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createPrompt{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"当前应用未获得使用相册授权，去设置？" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
     [btn sizeToFit];
}

//打开系统设置
-(void)btnClick{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
        
    }
}

-(BOOL)enable{
    BOOL enabel = YES;
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];

    if(authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied){
        NSLog(@"权限受限");
        enabel = NO;
        [self createPrompt];
    }

    return enabel;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LHGroupsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupsCell"];
    if (!cell) {
        cell = [[LHGroupsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"groupsCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    PHAssetCollection *assetCollection = _dataArray[indexPath.row];
    cell.textLabel.text = assetCollection.localizedTitle;
    
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",assets.count];

    if (assets.count) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:assets[0] targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.imageView.image = result;
          //  NSLog(@"%@",result);
        }];
    }else{
        [cell.imageView setContentMode:UIViewContentModeScaleToFill];
        cell.imageView.image = [UIImage imageNamed:@"default"];
    }

   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     PHAssetCollection *assetCollection = _dataArray[indexPath.row];
    LHPhotosViewController *photos = [[LHPhotosViewController alloc] init];
    photos.title = assetCollection.localizedTitle;
    photos.assetCollection = assetCollection;
    [self.navigationController pushViewController:photos animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
