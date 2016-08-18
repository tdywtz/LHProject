//
//  FriendsViewController.m
//  chat
//
//  Created by luhai on 15/12/29.
//  Copyright © 2015年 luhai. All rights reserved.
//

#import "LHFriendsViewController.h"
#import "XMPPManager.h"
#import "LHFriendsTableViewCell.h"
#import "LHFriendsSectionView.h"
#import "ChatViewController.h"

@interface LHFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,LHFriendsSectionViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) NSMutableArray *sectionViewArray;
@end

@implementation LHFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    double delayInSeconds = 4.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self loadData];
       
    });

    [self createTableView];
    [self createRightItem];
    [self createLeftItem];
}

-(void)createRightItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightClick{
    [self loadData];
  
}

-(void)createLeftItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(leftClick1) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:btn],[[UIBarButtonItem alloc] initWithTitle:@"tongyi" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick2)]];
}

-(void)leftClick1{
    UIAlertController *alet = [UIAlertController alertControllerWithTitle:@"add" message:@"adsfadsf" preferredStyle:UIAlertControllerStyleAlert];
      [alet addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
          NSLog(@"%@",textField.text);
      }];
    UIAlertAction *act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alet.textFields[0];
        [[XMPPManager shareManager] addSomeBody:textField.text Newmessage:@"hello"];
    }];
    [alet addAction:act];
     [self presentViewController:alet animated:YES completion:nil];
    
   
   
}

-(void)leftClick2{
    [[XMPPManager shareManager] agreeRequest:@"123456"];
}

-(void)loadData{
    
    self.dataArray = [[XMPPManager shareManager] friendsList:nil];
    [_tableView reloadData];
}

-(void)createTableView{

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, self.view.frame.size.height-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = RGB_color(235, 235, 241, 1);
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    self.sectionViewArray = [[NSMutableArray alloc] init];
     NSArray*titleArray=@[@"好友",@"我关注的人",@"关注我的人",@"陌生人"];
    for (NSString *title in titleArray) {
         LHFriendsSectionView *view = [[LHFriendsSectionView alloc ] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
        view.delegate = self;
        view.nameLabel.text = title;
        [self.sectionViewArray addObject:view];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LHFriendsSectionView *view = self.sectionViewArray[section];
    
    return view.open?[self.dataArray[section] count]:0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LHFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHFriendsCell"];
    if (!cell) {
        cell = [[LHFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LHFriendsCell"];
    }
    //读取数据源
   LHUserInfo *userInfo = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = userInfo.userId;
    if (userInfo.nikeName.length > 0) {
        cell.textLabel.text = userInfo.nikeName;
    }
   // cell.detailTextLabel.text = userInfo.
    //获取用户头像
   // UIImage*image=[[ZCXMPPManager sharedInstance]avatarForUser:object];
    if (userInfo.image) {
        cell.imageView.image = userInfo.image;
    }else{
        cell.imageView.image = [UIImage imageNamed:@"头像"];
    }
    
    return cell;
}


#pragma Mark- UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    LHFriendsSectionView *view = self.sectionViewArray[section];
    view.numberLabel.text = [@([self.dataArray[section] count]) stringValue];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ChatViewController *chat = [[ChatViewController alloc] init];
    LHUserInfo *userInfo = _dataArray[indexPath.section][indexPath.row];
    chat.targetId = userInfo.userId;
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
}

//**删除*/
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *action1 = [UITableViewRowAction  rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        LHUserInfo *userInfo = _dataArray[indexPath.section][indexPath.row];
        [[XMPPManager shareManager] removeBuddy:userInfo.userId];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.f*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self loadData];
        });
    }];
    
    return @[action1];
}


#pragma mark - LHFriendsSectionViewDelegate
-(void)clickSectionView{
    
    [_tableView reloadData];
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
