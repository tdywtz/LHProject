//
//  LHPhotosCollectionViewCell.m
//  photos
//
//  Created by bangong on 16/1/21.
//  Copyright © 2016年 auto. All rights reserved.
//

#define  LHPhotosBundleName(name) [@"LHPhotos.bundle" stringByAppendingPathComponent:name]
#import "LHPhotosCollectionViewCell.h"

@implementation LHPhotosCollectionViewCell
{
    UIImageView *imageView;
    UIImageView *selectIamgeView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:imageView];
       
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];

        selectIamgeView = [[UIImageView alloc] init];
        [imageView addSubview:selectIamgeView];
       
        selectIamgeView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[selectIamgeView(30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectIamgeView)]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[selectIamgeView(30)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectIamgeView)]];
        self.selected = NO;
      
    }
    return self;
}

-(void)setAsset:(LHAsset *)asset{
    if (_asset == asset) {
        return;
    }
    _asset = asset;
    
    if (_asset.assetSelected) {
        selectIamgeView.image = [UIImage imageNamed:LHPhotosBundleName(@"FriendsSendsPicturesSelectBigYIcon")];
    }else{
        selectIamgeView.image = [UIImage imageNamed:LHPhotosBundleName(@"FriendsSendsPicturesSelectBigNIcon")];
    }
    
    if (_asset.iamge) {
        imageView.image = _asset.iamge;
    }else{
        PHImageRequestOptions* requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        
     //   PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        [[PHImageManager defaultManager] requestImageForAsset:_asset.asset
                                targetSize:CGSizeMake(200, 200)
                               contentMode:PHImageContentModeAspectFill
                                   options:requestOptions
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 imageView.image = nil;
                                 imageView.backgroundColor = [UIColor whiteColor];
                                 imageView.image = result;
                                 _asset.iamge = result;
                                 NSLog(@"%@",info);
                             }];
//        [[PHImageManager defaultManager] requestImageDataForAsset:_asset.asset options:requestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//            NSLog(@"%@",[UIImage imageWithData:imageData]);
//           size_t k = CGImageGetBytesPerRow([UIImage imageWithData:imageData].CGImage);
//            NSLog(@"%zu,%@",k,info);
//        }];
    }
    //NSLog(@"%@",_asset.asset.creationDate);
}



@end
