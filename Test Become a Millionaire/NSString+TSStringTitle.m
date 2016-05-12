//
//  NSString+TSStringTitle.m
//  Test Become a Millionaire
//
//  Created by Mac on 13.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "NSString+TSStringTitle.h"

@implementation NSString (TSStringTitle)

+ (NSString *) titleLabelString:(NSInteger) index {
    
    NSString *str1 = @"100";
    NSString *str2 = @"200";
    NSString *str3 = @"300";
    NSString *str4 = @"500";
    NSString *str5 = @"1 000";
    NSString *str6 = @"2 000";
    NSString *str7 = @"4 000";
    NSString *str8 = @"8 000";
    NSString *str9 = @"16 000";
    NSString *str10 = @"32 000";
    NSString *str11 = @"64 000";
    NSString *str12 = @"125 000";
    NSString *str13 = @"250 000";
    NSString *str14 = @"500 000";
    NSString *str15 = @"100 000 000";
    
    NSArray *strings = @[str1, str2, str3, str4, str5, str6, str7, str8, str9, str10, str11, str12, str13, str14, str15];
    NSString *title = [strings objectAtIndex:index];
    
    return title;
}


@end
