//
//  TSCustomButton.m
//  Test Become a Millionaire
//
//  Created by Mac on 14.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSCustomButton.h"

@implementation TSCustomButton

@synthesize tag;

+(TSCustomButton *) cutomButton:(CGRect) rect parentView:(UIView *) view bckgrndImg:(NSString *) bckgrndImg {
    
    TSCustomButton *ctmBtn = [[TSCustomButton alloc] initWithFrame:rect];
    ctmBtn.backgroundColor = [UIColor colorWithRed:(29 / 255.0f) green:(109 / 255.0f) blue:(251 / 255.0f) alpha:0.0f];
    UIImage *image = [[UIImage imageNamed:bckgrndImg] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [ctmBtn setImage:image forState:UIControlStateNormal];
    ctmBtn.layer.cornerRadius = ctmBtn.frame.size.height / 2;
    ctmBtn.clipsToBounds = YES;
    ctmBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    ctmBtn.layer.borderWidth = 1.5f;
    [view addSubview:ctmBtn];
    
    return ctmBtn;
}

@end
