//
//  NewsDetailViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/9.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "LHMenuController.h"

@interface NewsDetailViewController ()<UIWebViewDelegate,UITextViewDelegate>
{
    UILabel *_titleLabel;
    UILabel *_infoLabel;
    UIWebView *_webView;
    UIView *bgView;
    
    UIView *shareView;
}
@property (nonatomic,strong) NSDictionary *dictionary;
@end

@implementation NewsDetailViewController
- (void)dealloc
{
    [bgView removeFromSuperview];
}

-(void)loadData{
    NSString *url = [NSString stringWithFormat:@"http://m.12365auto.com/server/forAppWebService.ashx?act=newsinfo&id=%@",self.ID];
    if (self.invest) {
        url = [NSString stringWithFormat:@"http://m.12365auto.com/server/forAppWebService.ashx?act=carownerinfo&id=%@",self.ID];
    }
    [HttpRequestManger GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject count] == 0) {
            return ;
        }
        self.dictionary = responseObject[0];
        // NSLog(@"%@",self.dictionary);
        _infoLabel.text = [NSString stringWithFormat:@"时间：%@   编辑：%@", self.dictionary[@"date"], self.dictionary[@"editor"]];
        
        NSMutableString *newsContentHTML = [NSMutableString stringWithFormat:@"<style>body{padding:0 10px;}</style>%@",self.dictionary[@"content"]];
        
        NSRange range = range = [newsContentHTML rangeOfString:@"src=\"/"];
        while (range.length != 0) {
            [newsContentHTML insertString:@"http://www.12365auto.com" atIndex:range.location+range.length-1];
            range = [newsContentHTML rangeOfString:@"src=\"/"];
        }
        
        range = [newsContentHTML rangeOfString:@"<IMG"];
        while (range.length != 0) {
            [newsContentHTML insertString:@"qq" atIndex:range.location+1];
            range = [newsContentHTML rangeOfString:@"<IMG"];
        }
        NSString *width = [[NSString alloc] initWithFormat:@"style='max-width:%fpx'",WIDTH-50];
        
        range = [newsContentHTML rangeOfString:@"<qqIMG"];
        while (range.length != 0) {
            [newsContentHTML deleteCharactersInRange:NSMakeRange(range.location+1, 2)];
            [newsContentHTML insertString:width atIndex:range.location+5];
            range = [newsContentHTML rangeOfString:@"<qqIMG"];
            
        }
        range = [newsContentHTML rangeOfString:@"<img"];
        while (range.length != 0) {
            [newsContentHTML insertString:@"qq" atIndex:range.location+1];
            range = [newsContentHTML rangeOfString:@"<img"];
        }
        
        range = [newsContentHTML rangeOfString:@"<qqimg"];
        while (range.length != 0) {
            [newsContentHTML deleteCharactersInRange:NSMakeRange(range.location+1, 2)];
            [newsContentHTML insertString:width atIndex:range.location+5];
            range = [newsContentHTML rangeOfString:@"<qqimg"];
            
        }
        //        NSLog(@"%@",newsContentHTML);
        [_webView loadHTMLString:newsContentHTML baseURL:nil];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    [self createContent];
    [self loadData];
}

-(void)rightItemClick{
    
    LHMenuController *menu =  [[LHMenuController alloc] init];
    NSMutableArray *marray = [NSMutableArray new];
    for (int i = 0; i < 6; i ++) {
        NSString *name = [NSString stringWithFormat:@"fenxiang%d",i+1];
        [marray addObject:[[LHMenuItem alloc]initWithTitle:@"独孤求败" andImage: [UIImage imageNamed:[@"LHMenu.bundle" stringByAppendingPathComponent:name]]]];
    }
    menu.items = marray;
    menu.itemSize = CGSizeMake(60, 60);
    menu.queues = 3;
    [menu setBluffImageWithView:self.navigationController.view];
    [self presentViewController:menu animated:YES completion:nil];
}

-(void)createContent{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 74, WIDTH, 20)];
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:view];
    
    CGSize size =[self.titleLabelText boundingRectWithSize:CGSizeMake(WIDTH-30, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
 
    _titleLabel = [LHController createLabelWithFrame:CGRectMake(15, 20, WIDTH-30, size.height)  Font:17 Bold:NO TextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] Text:self.titleLabelText];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
     _titleLabel.numberOfLines = 0;
    [self.view addSubview:_titleLabel];
    
   
    _infoLabel = [LHController createLabelWithFrame:CGRectMake(20, 20+size.height+5, WIDTH-40, 20) Font:12 Bold:NO TextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] Text:nil];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_infoLabel];
    
    view.frame = CGRectMake(0, 10, WIDTH, _infoLabel.frame.origin.y+_infoLabel.frame.size.height+5);
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, _infoLabel.frame.origin.y+_infoLabel.frame.size.height+20, WIDTH, HEIGHT-64-49-_infoLabel.frame.origin.y-_infoLabel.frame.size.height-20)];
    _webView.frame = self.view.frame;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    [self.view addSubview:_webView];
}


#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#333333'"];
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '330%'"];
    //[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
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
