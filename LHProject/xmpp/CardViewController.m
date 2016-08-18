//
//  CardViewController.m
//  chat
//
//  Created by luhai on 16/1/9.
//  Copyright © 2016年 luhai. All rights reserved.
//

#import "CardViewController.h"
#import "XMPPManager.h"

NSString *const sign        = @"sign";//签名
NSString *const sex         = @"sex";//性别
NSString *const address     = @"address";
NSString *const phoneNumber = @"phoneNumber";
//个人中心编码解码
#define CODE(str)\
[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]\


@interface CardTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UIImageView *iconImageView;

@end

@implementation CardTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = colorViewBackColor;
        
        self.leftLabel = [[UILabel alloc] init];
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.textColor = [UIColor grayColor];
        self.rightLabel.font = [UIFont systemFontOfSize:15];
        self.iconImageView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.rightLabel];
        [self.contentView addSubview:self.iconImageView];
        
        [self.leftLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.centerY.equalTo(0);
        }];
        [self.rightLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.right).offset(20);
            make.right.equalTo(-10);
            make.centerY.equalTo(0);
        }];
        
        [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightLabel);
            make.centerY.equalTo(0);
            make.size.equalTo(CGSizeMake(60, 60));
        }];
    }
    return self;
}

@end

#pragma mark - /////////////////////////////////////////////////////////

@interface CardViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;

}
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)XMPPvCardTemp *card;
@end
@implementation CardViewController

-(void)viewDidLoad{
    [super viewDidLoad];
 
    [self createTableView];
    _dataArray =  @[@"头像",@"昵称",@"签名",@"性别",@"地区",@"二维码",@"手机号"];
    [_tableView reloadData];
    [self loadVcardValue];
   
}

-(void)loadVcardValue{
    [[XMPPManager shareManager] getMyVcardBlock:^(XMPPvCardTemp *card) {
        self.card = card;
        NSData*data = card.photo;
        if (data == nil) {
            data = [NSData new];
            //data = UIImagePNGRepresentation([UIImage imageNamed:@"123"]);
        }
        NSString * nickName = card.nickname;
        nickName = [nickName stringByRemovingPercentEncoding];
        if (nickName == nil) {
            nickName = @"没有昵称";
        }
        NSString *qmd =[[card elementForName:@"QMD"]stringValue];
        if (qmd==nil) {
            qmd=@"没有设置签名";
        }
        NSString *sex = [[card elementForName:@"SEX"]stringValue];
        if (sex==nil) {
            sex=@"人妖";
        }
        NSString *address= [[card elementForName:@"DQ"] stringValue];
        if (address==nil) {
            address=@"来着星星的你";
        }
        NSString *phoneNum=[[card elementForName:@"phonenum"] stringValue];
        if (phoneNum==nil) {
            phoneNum=@"*********";
        }
        
        self.dict = @{@"头像":data,@"昵称":nickName,@"签名":qmd,@"性别":sex,@"地区":address,@"手机号":phoneNum};
        
        [_tableView reloadData];
    }];

}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CardTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
      
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    if (indexPath.row == 0) {
//     //   cell.imageView.image = self.dict[_dataArray[indexPath.row]];
//        NSData *data = self.dict[_dataArray[indexPath.row]];
//        UIImage *image = [UIImage imageWithData:data];
//        cell.imageView.image = image;
//    }else{
//        cell.imageView.image = nil;
//        cell.detailTextLabel.text = self.dict[_dataArray[indexPath.row]];
//    }
//    cell.textLabel.text = _dataArray[indexPath.row];
    if (indexPath.row == 0) {
          cell.accessoryType = UITableViewCellAccessoryNone;
        cell.leftLabel.text = _dataArray[indexPath.row ];
        cell.rightLabel.text = nil;
        NSData *data = self.dict[_dataArray[indexPath.row]];
        cell.iconImageView.image = [UIImage imageWithData:data];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.leftLabel.text = _dataArray[indexPath.row ];
        cell.rightLabel.text = self.dict[_dataArray[indexPath.row]];
        cell.iconImageView.image = nil;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 70;
    }
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     UIActionSheet UIAlertView在iOS8下的时候合并为UIAlertController取消了代理，更改为block
     UISearchDisplayController更改为 UISearchController
     
     */
    
    
    switch (indexPath.row) {
        case 0:
        {
            UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
            [sheet showInView:self.view];
            
        }
            break;
        case 1:
            //昵称
            [self createAlertViewWithString:@"请输入昵称" tag:indexPath.row];
            break;
        case 2:
            //签名
            [self createAlertViewWithString:@"请输入签名" tag:indexPath.row];
            
            break;
        case 3:
            //性别不修改的
            [self createAlertViewWithString:@"请输入签名" tag:indexPath.row];
            break;
        case 4:
            //地区
            [self createAlertViewWithString:@"请输入地区" tag:indexPath.row];
            
            break;
        case 5:
            //二维码不可修改
            break;
        case 6:
            //手机号
            [self createAlertViewWithString:@"请输入手机号" tag:indexPath.row];
            
            break;
            
        default:
            break;
    }
}

-(void)createAlertViewWithString:(NSString*)message tag:(NSInteger)tag{
    UIAlertView*al=[[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    al.alertViewStyle=UIAlertViewStylePlainTextInput;
    al.tag=tag;
    [al show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        return;
    }
    //获取输入框内容
    NSString*str=[alertView textFieldAtIndex:0].text;
    if (str.length==0) {
        return;
    }
     NSString *string1;
   // [string1 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"dfsfsafda"]];
    switch (alertView.tag) {
        case 1:
            
            //昵称
            self.card.nickname = CODE(str);
            break;
        case 2:
            //签名
            [[XMPPManager shareManager] customVcardXML:str name:@"QMD" myVcard:self.card];
            break;
            
        case 3:
              [[XMPPManager shareManager] customVcardXML:str name:@"SEX" myVcard:self.card];
            break;
            
        case 4:
            //地区
            [[XMPPManager shareManager]customVcardXML:str name:@"DQ" myVcard:self.card];
            break;
        case 6:
            //手机
            [[XMPPManager shareManager]customVcardXML:str name:@"phonenum" myVcard:self.card];
            break;
            
        default:
            break;
    }
    [[XMPPManager shareManager] upData:self.card];
    [self loadVcardValue];
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==2) {
        return;
    }
    
    UIImagePickerController*picker=[[UIImagePickerController alloc]init];
    picker.delegate = self;
    if (buttonIndex==0) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
    }
    
    [self presentViewController:picker animated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //读取数据
    UIImage*image=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.card.photo = UIImageJPEGRepresentation(image, 0.1);
     [[XMPPManager shareManager] upData:self.card];
    [self loadVcardValue];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
