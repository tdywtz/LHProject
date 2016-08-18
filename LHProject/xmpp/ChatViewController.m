//
//  ChatViewController.m
//  chat
//
//  Created by luhai on 16/1/8.
//  Copyright © 2016年 luhai. All rights reserved.
//

#import "ChatViewController.h"
#import "LHChatTextCell.h"
#import "CZWIMInputBar.h"
#import "LHImageMessage.h"
#import "LHTextMessage.h"
#import "LHChatImageCell.h"

@interface ChatViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CZWIMInputBarDelegate,XMPPManagerDelegate>
{
    NSMutableArray *_dataArray;
    CZWIMInputBar *inputBar;
    
    CGRect startFrame;
    
    
    UICollectionView *_collectionView;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"123"];
   // [self.view addSubview:imageView];
    
    [XMPPManager shareManager].delegate = self;
    [self createCollectionView];
    [self loadData];
    
}

-(void)loadData{
    
    //获得消息记录
    NSArray *array = [[XMPPManager shareManager] messageRecordList:self.targetId];
    if (array.count) {
        _dataArray=[NSMutableArray arrayWithArray:array];
        [_collectionView reloadData];
        //数据偏移
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
}

-(void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    //_collectionView.pagingEnabled = YES;
    _collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_collectionView];
   
    inputBar = [[CZWIMInputBar alloc] initWithFrame:CGRectZero];
    inputBar.delegate = self;
    [self.view addSubview:inputBar];
    

 [_collectionView makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(0);
     make.top.equalTo(0);
     make.right.equalTo(0);
     make.bottom.equalTo(inputBar.top);
 }];
    [inputBar makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.equalTo(0);
        make.right.equalTo(0);
    }];

    
    [_collectionView registerClass:[LHChatTextCell class] forCellWithReuseIdentifier:@"collectionCellText"];
    [_collectionView registerClass:[LHChatImageCell class] forCellWithReuseIdentifier:@"collectionCellImage"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CZWIMInputBarDelegate
- (void)CZWIMInputBarDidSendTextAction:(NSString *)aText{
    if (aText.length == 0)
    {
        return;
    }
    
    NSString* text = [aText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"不能发送空白消息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    inputBar.textView.text = @"";
    [[XMPPManager shareManager] sendTextMessageWithTarget:self.targetId message:aText type:ConversationType_APPSERVICE];
    
    [self loadData];
}
- (void)CZWIMInputBarFrameChangeValue:(CGRect)frame{
    CGRect edege = startFrame;
    edege.size.height = frame.origin.y;
    _collectionView.frame = edege;
    //数据偏移
    if (_dataArray.count) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
}

-(void)selectedButton:(NSInteger *)index{
    LHPhotosController *poto = [[LHPhotosController alloc] init];
    poto.maxNumber = 6;
    __weak __typeof(self)weakSelf = self;
    [poto resultPhotos:^(NSArray<__kindof LHAsset *> *assets) {
        for (LHAsset *lhasset in assets) {
            [[XMPPManager shareManager] sendImageMessageWithTarget:self.targetId image:lhasset.iamge type:ConversationType_PRIVATE];
            
            [weakSelf loadData];
        }
    }];
    [self presentViewController:poto animated:YES completion:nil];
}


//图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

//字符串转图片
-(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr
{
    NSData *_decodedImageData   = [[NSData alloc] initWithBase64EncodedString:_encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
    return _decodedImage;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        //获取消息
        
        
        LHMessage *message = _dataArray[indexPath.row];
  
        if ([message isKindOfClass:[LHTextMessage class]]) {
            LHTextMessage *textMessage = (LHTextMessage *)message;
            LHChatTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCellText" forIndexPath:indexPath];//复用
            cell.message = textMessage;
           
            return cell;
        }else if([message isKindOfClass:[LHImageMessage class]]) {
            LHImageMessage *imageMessage = (LHImageMessage *)message;
            LHChatImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCellImage" forIndexPath:indexPath];//复用
            cell.imageMessage = imageMessage;
            return cell;
        }
    
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(WIDTH, 140);
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

#pragma mark - XMPPManagerDelegate
-(void)receiveMessage:(LHMessage *)message{
    [self loadData];
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
