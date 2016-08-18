//
//  LHController.m
//  auto
//
//  Created by bangong on 15/7/3.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "LHController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
@implementation LHController

#pragma mark --创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(CGFloat)font Bold:(BOOL)bold TextColor:(UIColor *)color Text:(NSString*)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    if (color) {
        label.textColor = color;
    }
    if (bold == YES) {
        label.font = [UIFont boldSystemFontOfSize:font];
    }
    label.numberOfLines = 0;
    return label;
}


#pragma mark - 判断网络是否可用
+(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
       // printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}


+ (NSDateComponents *)intervalsDate:(NSTimeInterval)time{

  NSDate *fromdate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    if (!fromdate) {
        return nil;
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;

    
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:[NSDate date]  toDate:fromdate  options:0];
    NSInteger hour          = [comps hour];
    NSInteger minute        = [comps minute];
    NSInteger second        = [comps second];
    NSString *timeSting     = [NSString stringWithFormat:@"%0.2ld:%0.2ld:%0.2ld",hour,minute,second];
    return comps;
}


+ (NSString *)setChatDate:(NSTimeInterval)time{
    
    NSArray *weekDays = @[@"",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSDate *fromdate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    if (!fromdate) {
        return nil;
    }
    NSTimeInterval timeInterval =[[NSDate date] timeIntervalSinceDate:fromdate];
    int days=((int)timeInterval)/(3600*24);
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    if (days == 0) {
        [format setDateFormat:@"HH:mm"];
        return [format stringFromDate:fromdate];
    }else if (days == 1){
        return @"昨天";
    }else if (days > 1 && days <= 4){
        NSDateComponents *comps = [self calculateDate:time];
    
        return weekDays[comps.weekday];
    }else{
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [format stringFromDate:fromdate];
    }
}

+ (NSDateComponents *)calculateDate:(NSTimeInterval)time{
    
    NSDate *fromdate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|
    NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:fromdate];
    
    return comps;
}



@end
