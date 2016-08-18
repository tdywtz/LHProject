//
//  LHMenuController.m
//  LHProject
//
//  Created by bangong on 16/4/13.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHMenuController.h"
#import "UIImage+LH.h"
@interface LHMenuItem ()

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIImage *image;

@end

@implementation LHMenuItem

-(instancetype)initWithTitle:(NSString *)title andImage:(UIImage *)image{
    
    if (self = [super init]) {
        _image = image;
        _title = title;
       
        [self setUp];
    }
    return self;
}

-(void)setUp{
    _itemImage = [[UIImageView alloc] init];
    [_itemImage setContentMode:UIViewContentModeScaleAspectFit];
    _itemImage.image = _image;
   
    _itemTitleLabel = [[UILabel alloc] init];
    _itemTitleLabel.textAlignment = NSTextAlignmentCenter;
    _itemTitleLabel.font = [UIFont systemFontOfSize:13];
    _itemTitleLabel.text = _title;
    
    [self addSubview:_itemImage];
    [self addSubview:_itemTitleLabel];
    
    [_itemImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(0);
        make.bottom.lessThanOrEqualTo(_itemTitleLabel.top).offset(-5);
    }];
    
    [_itemTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.right.equalTo(0);
    }];
}


@end

#pragma mark - ////////////////////////////////////////////////////////
@interface LHMenuController ()
{
    CGFloat changY;
}
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) UIImage *bluffImage;
@end

@implementation LHMenuController

- (void)dealloc
{
    _items = nil;
    _buttons = nil;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _duration = 1.0;
        _beginTime = 0.042;
        _itemSize = CGSizeMake(40, 60);
        _lineSpacing = 30;
        _queues = 4;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
  
    UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:self.view.frame];
    iamgeView.image = [self.bluffImage scaleToSize:CGSizeMake(self.bluffImage.size.width/100, self.bluffImage.size.height/100)] ;
    [self.view insertSubview:iamgeView atIndex:0];

    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnBackground)]];
    
    //[self addVisualEffectView];
    [self setUpView];
    [self showItems];
}

-(void)setBluffImageWithView:(UIView *)view{
    self.bluffImage = [self snapshootView:view];
   
}

- (UIImage *) snapshootView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    CGContextRef  ctx = UIGraphicsGetCurrentContext();
    [view.window.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//-(void)addVisualEffectView{
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//
//    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
//    effectview.frame = self.view.bounds;
//   
//    [self.view insertSubview:effectview atIndex:0];
//    
//}

//点击空白处，dismiss
- (void)didTapOnBackground{
    [self hidenItems];
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration/2.0*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    });
}

//创建按钮
- (void)setUpView{
    CGFloat widthSpace = (self.view.frame.size.width - self.itemSize.width*self.queues)/(self.queues+1);
    for (int i = 0; i < self.items.count; i ++) {
        LHMenuItem *item = self.items[i];
   
        item.frame = CGRectMake(widthSpace+(i%self.queues)*(self.itemSize.width+widthSpace), CGRectGetHeight(self.view.frame)+(i/self.queues)*(self.itemSize.height+self.lineSpacing), self.itemSize.width, self.itemSize.height);
        item.tag = 100+i;
        [item addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:item];
        [self.buttons addObject:item];
    }
    
 
    NSInteger queues = self.items.count/self.queues+(self.items.count%self.queues>0?1:0);
    changY = queues*(self.itemSize.height+self.lineSpacing)+30;
}

-(void)buttonClick:(UIButton *)btn{
    [self didTapOnBackground];
    
}


//展示按钮
-(void)showItems{
  
    __weak __typeof(self)weakSelf = self;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.1f*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        for (int i = 0; i < strongSelf.buttons.count; i ++) {
            UIButton *btn = strongSelf.buttons[i];
        
            CGFloat k = fabsf(i%strongSelf.queues-((strongSelf.queues-1)/2.0f));
        
            [UIView animateWithDuration:self.duration delay:self.beginTime*k usingSpringWithDamping:0.6 initialSpringVelocity:1.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                CGRect rect = btn.frame;
                rect.origin.y = rect.origin.y-changY;
                btn.frame = rect;
            } completion:nil];

        }
    });
}

//隐藏按钮
-(void)hidenItems{
  
    for (int i = 0; i < self.buttons.count; i ++) {

        UIButton *btn = self.buttons[i];
      
        CGFloat k = fabsf(i%self.queues-((self.queues-1)/2.0f));

        [UIView animateWithDuration:self.duration/2.0 delay:self.beginTime*k options:UIViewAnimationOptionLayoutSubviews animations:^{
            CGRect rect = btn.frame;
            rect.origin.y = rect.origin.y+changY;
            btn.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
    }
}


-(void)setQueues:(NSInteger)queues{
    if (queues < 3) {
        _queues = 3;
    }else if (queues > 5){
        _queues = 5;
    }else{
        _queues = queues;
    }
}

-(NSMutableArray *)buttons{
   
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
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
