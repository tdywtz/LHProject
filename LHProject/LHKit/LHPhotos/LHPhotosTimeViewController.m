//
//  LHPhotosTimeViewController.m
//  LHProject
//
//  Created by bangong on 16/4/19.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHPhotosTimeViewController.h"

@interface LHPhotosTimeViewController ()

@property (nonatomic,strong) PHFetchResult *smartAlbums;
@end

@implementation LHPhotosTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self readResult];
    
}

-(void)readResult{
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    _smartAlbums = [PHAssetCollection fetchMomentsWithOptions:options];
//    [smartAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        PHAssetCollection *assetCollection = obj;
//        __block  NSMutableArray *marray = [[NSMutableArray alloc] init];
//        NSLog(@"%@",assetCollection.localizedLocationNames);
//        PHFetchResult *fet = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
//        [fet enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            LHAsset *myAsset = [[LHAsset alloc] init];
//            myAsset.asset = obj;
//            [marray addObject:myAsset];
//        }];
//        [self.assets addObject:marray];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.smartAlbums.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
     PHAssetCollection *assetCollection = [self.smartAlbums objectAtIndex:section];
     PHFetchResult *fet = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    return fet.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        reusableview.backgroundColor = [UIColor redColor];
    }
    return reusableview;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.frame.size.width/4-2, self.view.frame.size.width/4-2);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(CGRectGetWidth(self.view.frame), 20);
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
