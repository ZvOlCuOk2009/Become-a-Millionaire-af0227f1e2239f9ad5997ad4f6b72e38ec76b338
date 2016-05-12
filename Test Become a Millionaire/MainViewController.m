//
//  ViewController.m
//  Test Become a Millionaire
//
//  Created by Mac on 09.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "MainViewController.h"
#import "TSServerManager.h"
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+TSStringTitle.h"
#import "TSCustomButton.h"

static NSInteger counterQuestion = 0;
static NSInteger counterHintHall = 0;
static NSInteger counterHintFriends = 0;
static NSInteger counterHint50_50 = 0;
static NSInteger counterID = -1;
static NSString *kCounterID = @"kCounterID";

@interface MainViewController () <AVAudioPlayerDelegate>

@property (strong, nonatomic) TSRequest *request;
@property (strong, nonatomic) AVPlayer *player;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (strong, nonatomic) NSString *urlStringOne;
@property (strong, nonatomic) NSString *urlStringTwo;
@property (strong, nonatomic) NSString *urlStringFree;
@property (strong, nonatomic) NSString *urlStringFore;

@property (weak, nonatomic) UIButton *oneButton;
@property (weak, nonatomic) UIButton *twoButton;
@property (weak, nonatomic) UIButton *threeButton;
@property (weak, nonatomic) UIButton *foreButton;
@property (weak, nonatomic) UIButton *restartButton;

@property (weak, nonatomic) UIView *screenSaver;
@property (weak, nonatomic) UIView *verificationHintView;
@property (assign, nonatomic) BOOL isCorrect;
@property (strong, nonatomic) NSArray *buttons;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    UIImage *img = [UIImage imageNamed:@"logo_M-1"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    [self generationRequestQuestions];
    [self createdButtons];
    if (self.restartButton) {
        [self.restartButton removeFromSuperview];
    }
   [self createdButtonHints];
   //[self soundBackground];
}

- (void) createdLabel {
   
   if (counterQuestion != 16) {
      self.textLabel.text = self.request.question;
      self.textLabel.textColor = [UIColor lightGrayColor];
      CGRect newFrame = self.textLabel.frame;
      newFrame.size = CGSizeMake(self.view.frame.size.width - 40, CGFLOAT_MAX);
      self.textLabel.frame = newFrame;
      self.textLabel.frame = CGRectMake(35, 70, 263, 66);
      [self.textLabel sizeToFit];
      self.textLabel.textAlignment = NSTextAlignmentCenter;
      [self.view addSubview:self.textLabel];
   }
}

- (void) createdButtonHints {
   
   TSCustomButton *oneHintButton = [TSCustomButton cutomButton:[self sharedRect:43]
                                                    parentView:self.view bckgrndImg:@"people-5"];
   TSCustomButton *twoHintButton = [TSCustomButton cutomButton:[self sharedRect:128]
                                                    parentView:self.view bckgrndImg:@"telephon"];
   TSCustomButton *threeHintButton = [TSCustomButton cutomButton:[self sharedRect:213]
                                                      parentView:self.view bckgrndImg:@"cut-2"];
   
   [oneHintButton addTarget:self action:@selector(actionHintOneProgramming) forControlEvents:UIControlEventTouchUpInside];
   [twoHintButton addTarget:self action:@selector(actionHintTwoProgramming) forControlEvents:UIControlEventTouchUpInside];
   [threeHintButton addTarget:self action:@selector(actionHintThreeProgramming) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
   
   [super viewWillAppear:animated];
   NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
   NSInteger ID = [userDefault integerForKey:kCounterID];
   NSLog(@"counterID = %ld", ID);
}

-(void)viewWillDisappear:(BOOL)animated {
   
   [super viewWillDisappear:animated];
   NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
   [userDefault setInteger:counterID forKey:kCounterID];
   [userDefault synchronize];
   NSLog(@"counterID = %ld", counterID);
}

- (CGRect) sharedRect:(NSInteger) xValue {
   
   CGRect rect = CGRectMake(xValue, 20, 65, 35);
   return rect;
}

- (void) createdButtons {
   
   if (counterQuestion != 16) {
      UIButton * btnOne = [self createdButton:[self rectButton:-220 yValue:380]];
      UIButton * btnTwo = [self createdButton:[self rectButton:320 yValue:420]];
      UIButton * btnThree = [self createdButton:[self rectButton:-220 yValue:460]];
      UIButton * btnFore = [self createdButton:[self rectButton:320 yValue:500]];
      
      self.oneButton = btnOne;
      self.twoButton = btnTwo;
      self.threeButton = btnThree;
      self.foreButton = btnFore;
      
      [btnOne addTarget:self action:@selector(buttonOne) forControlEvents:UIControlEventTouchUpInside];
      [btnTwo addTarget:self action:@selector(buttonTwo) forControlEvents:UIControlEventTouchUpInside];
      [btnThree addTarget:self action:@selector(buttonThree) forControlEvents:UIControlEventTouchUpInside];
      [btnFore addTarget:self action:@selector(buttonFore) forControlEvents:UIControlEventTouchUpInside];
      
      self.buttons = @[btnOne, btnTwo, btnThree, btnFore];
      [self animButton];
   }
}

- (CGRect) rectButton:(NSInteger) xValue yValue:(NSInteger) yValue {
   
   CGRect rectBtn = CGRectMake(xValue, yValue, 220, 25);
   return rectBtn;
}

- (UIButton *) createdButton:(CGRect) rect {
   
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    button.backgroundColor = [UIColor colorWithRed:(29 / 255.0f) green:(109 / 255.0f) blue:(251 / 255.0f) alpha:0.7f];
    button.layer.cornerRadius = 12;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 0.75;
    [self.view addSubview:button];
    return button;
}

- (void) animButton {
    
    [UIView animateWithDuration:0.65
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.oneButton.frame = CGRectMake(50, 380, 220, 25);
                         self.twoButton.frame = CGRectMake(50, 420, 220, 25);
                         self.threeButton.frame = CGRectMake(50, 460, 220, 25);
                         self.foreButton.frame = CGRectMake(50, 500, 220, 25);
                     }
                     completion:nil];
}


#pragma mark - AVPlayer

- (void) soundBackground {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"7b9148f8c96e" ofType:@"mp3"];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:path]];
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    self.player.volume = 1.0;
    [self.player play];
}


#pragma mark - API

- (void) generationRequestQuestions {
    
   [self getRequestQuestions];
   [self postRequestQuestions];
    if (counterQuestion == 6) {
        [self notificationUser:@"Поздравляем у Вас первая несгораемая сумма 1000 $ !!!" time:0.45];
        } else if (counterQuestion == 11) {
            [self notificationUser:@"Поздравляем у Вас первая несгораемая сумма 32000 $ !!!" time:0.45];
        } else if (counterQuestion == 16) {
            [self notificationUser:@"Поздравляем Вы МИЛЛИОНЕР $ !!!" time:0.45];
    }
   if (counterID == 15) {
      counterID = -1;
   }
}

- (void) getRequestQuestions {
   
      [[TSServerManager sharedManager] getRequestQuestionTheServer:[NSString stringWithFormat:@"%ld", ++counterQuestion]
                                                         onSuccess:^(TSRequest *request) {
      self.request = request;
      self.urlStringOne = [request.answers objectAtIndex:0];
      self.urlStringTwo = [request.answers objectAtIndex:1];
      self.urlStringFree = [request.answers objectAtIndex:2];
      self.urlStringFore = [request.answers objectAtIndex:3];
      [self setTitleButton:self.urlStringOne button:self.oneButton];
      [self setTitleButton:self.urlStringTwo button:self.twoButton];
      [self setTitleButton:self.urlStringFree button:self.threeButton];
      [self setTitleButton:self.urlStringFore button:self.foreButton];
      [self createdLabel];
   }
    onFailre:^(NSError *error) {
       NSLog(@"%@", [error localizedDescription]);
    }];
}


- (void) postRequestQuestions {
   
   [[TSServerManager sharedManager]
    postRequestAnswerTheServer:[NSString stringWithFormat:@"%ld", ++counterID]
    onSuccess:^(TSRequest *request) {
   //current code...
    }
    onFailre:^(NSError *error) {
       NSLog(@"%@", [error localizedDescription]);
    }];
}


- (void) setTitleButton:(NSString *) url button:(UIButton *) currentButton {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             NSString *answer = [responseObject objectForKey:@"body"];
             [currentButton setTitle:answer forState:UIControlStateNormal];
             NSLog(@"JSON: %@", responseObject);
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}


#pragma mark - Parse Answer Json Button

- (void) parsingAnswerJson:(NSString *) url button:(UIButton *) currentButton {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             NSString *answer = [responseObject objectForKey:@"body"];
             BOOL isCorrect = [[responseObject objectForKey:@"is_correct"] boolValue];
             self.isCorrect = isCorrect;
             [currentButton setTitle:answer forState:UIControlStateNormal];
             if (isCorrect == 1) {
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     currentButton.backgroundColor = [UIColor greenColor];
                     [UIView animateKeyframesWithDuration:0.7
                                                    delay:0.5
                                                  options:UIViewKeyframeAnimationOptionRepeat
                                               animations:^{
                                                   currentButton.backgroundColor =
                                                   [UIColor colorWithRed:(29 / 255.0f) green:(109 / 255.0f) blue:(251 / 255.0f) alpha:1];
                                               }
                                               completion:nil];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [self screenSaverToPassLevel];
                         [self deleteButton];
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [self gameSequel];
                         });
                     });
                 });
             } else {
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     currentButton.backgroundColor = [UIColor orangeColor];
                     [UIView animateKeyframesWithDuration:0.7
                                                    delay:0.5
                                                  options:UIViewKeyframeAnimationOptionRepeat
                                               animations:^{
                                                   currentButton.backgroundColor =
                                                   [UIColor colorWithRed:(29 / 255.0f) green:(109 / 255.0f) blue:(251 / 255.0f) alpha:1];
                                               }
                                               completion:nil];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [self theUltimateSaver];
                     });
                 });
             }
             NSLog(@"JSON: %@", responseObject);
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (void) gameSequel {
    

    [self generationRequestQuestions];
    [self createdButtons];
}


- (void) deleteButton {
    
    [self.oneButton removeFromSuperview];
    [self.twoButton removeFromSuperview];
    [self.threeButton removeFromSuperview];
    [self.foreButton removeFromSuperview];
}


#pragma mark - Alert

- (void) notificationUser:(NSString *) text time:(CGFloat) time {
    
    CGRect rectView = CGRectMake(60, -100, 200, 100);
    UIView *notification = [[UIView alloc] initWithFrame:rectView];
    notification.backgroundColor = [UIColor blackColor];
    notification.alpha = 0.85;
    notification.layer.cornerRadius = 12;
    CGRect rectLbl = CGRectMake(20, 0, 160, 100);
    UILabel *lbl = [[UILabel alloc] initWithFrame:rectLbl];
    [lbl setText:text];
    lbl.textColor = [UIColor whiteColor];
    lbl.lineBreakMode = NSLineBreakByWordWrapping;
    lbl.numberOfLines = 0;
    [self.view addSubview:notification];
    [notification addSubview:lbl];
    
    [UIView animateWithDuration:time
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         notification.frame = CGRectMake(60, 200, 200, 100);
                     }
                     completion:nil];
    
    [UIView animateWithDuration:0.5
                          delay:3
                        options: UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         notification.alpha = 0;
                     }completion:^(BOOL finished){
                         [notification removeFromSuperview];
                     }];
}


- (void) theUltimateSaver {
    
    UIView *finishView = [[UIView alloc]
                          initWithFrame:CGRectMake(0, -568, self.view.bounds.size.width, self.view.bounds.size.height)];
    UIImage *img = [UIImage imageNamed:@"logo_M"];
    finishView.backgroundColor = [UIColor colorWithPatternImage:img];
    [self.view addSubview:finishView];
    [UIView animateWithDuration:1.7
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         finishView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                     }
                     completion:nil];
    [self notificationUser:@"К сожалению ответ не верный, игра окончена :(..." time:0.15];
    [self deleteButton];
    [self createdRestartButton:finishView];
}

- (void) screenSaverToPassLevel {
    
    CGRect rect = CGRectMake(40, 1136, 240, 568);
    UIView *passingTheScreen = [[UIView alloc] initWithFrame:rect];
    passingTheScreen.backgroundColor = [UIColor blackColor];
    passingTheScreen.alpha = 0.85;
    passingTheScreen.layer.cornerRadius = 12;
    [self.view addSubview:passingTheScreen];
    [UIView animateWithDuration:0.45
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         passingTheScreen.frame = CGRectMake(40, 10, 240, 568);
                     }
                     completion:nil];
    
    CGRect rectLbl = CGRectMake(60, 510, 120, 25);
    
    for (int i = 0; i < 15; i++) {
        UIColor *blueClr = [UIColor colorWithRed:(29 / 255.0f) green:(109 / 255.0f) blue:(251 / 255.0f) alpha:1];
        UIColor *greenClr = [UIColor greenColor];
        if (counterQuestion - 1 == i) {
            [self createdLabelLevel:rectLbl title:[NSString titleLabelString:i] color:greenClr perentView:passingTheScreen];
        } else {
            [self createdLabelLevel:rectLbl title:[NSString titleLabelString:i] color:blueClr perentView:passingTheScreen];
        }
        rectLbl.origin.y -= 35;
    }
    
    [UIView animateWithDuration:1.2
                          delay:3
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         passingTheScreen.frame = CGRectMake(40, 1136, 240, 568);
                     }
                     completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [passingTheScreen removeFromSuperview];
    });
}

- (void) createdLabelLevel:(CGRect) rect title:(NSString *) title color:(UIColor *) color perentView:(UIView *) perentView {
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.backgroundColor = color;
    lbl.layer.cornerRadius = 12;
    lbl.layer.borderColor = [UIColor whiteColor].CGColor;
    lbl.layer.borderWidth = 1.5;
    lbl.layer.masksToBounds = YES;
    lbl.text = title;
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    [perentView addSubview:lbl];

}

#pragma mark - Hint Hall And Call Friends


- (void) tipsHelpHall:(CGFloat) heightOne heightOne:(CGFloat) heightTwo {
    
    CGRect rect = CGRectMake(40, heightOne, 240, 448);
    UIView *screenSaver = [[UIView alloc] initWithFrame:rect];
    screenSaver.backgroundColor = [UIColor blackColor];
    screenSaver.alpha = 0.8;
    screenSaver.layer.cornerRadius = 12;
    [self.view addSubview:screenSaver];
    self.screenSaver = screenSaver;
    [UIView animateWithDuration:0.45
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         screenSaver.frame = CGRectMake(40, heightTwo, 240, 448);
                     }
                     completion:nil];

    NSInteger xValue = 12;
    [self createdViewDiagramma:xValue rndHeight:arc4random_uniform(300) + 1];
    [self createdViewDiagramma:xValue + 57 rndHeight:arc4random_uniform(300) + 1];
    [self createdViewDiagramma:xValue + 114 rndHeight:arc4random_uniform(300) + 1];
    [self createdViewDiagramma:xValue + 171 rndHeight:arc4random_uniform(300) + 1];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 385, 200, 25)];
    btn.backgroundColor = [UIColor colorWithRed:(29 / 255.0f) green:(109 / 255.0f) blue:(251 / 255.0f) alpha:1];
    btn.layer.cornerRadius = 12;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 0.75;
    [btn setTitle:@"Да" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [screenSaver addSubview:btn];
    [btn addTarget:self action:@selector(deletScreenHall) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger xVl = 28;
    [self titleLabelDiagramma:xVl title:@"A"];
    [self titleLabelDiagramma:xVl + 57 title:@"Б"];
    [self titleLabelDiagramma:xVl + 114 title:@"В"];
    [self titleLabelDiagramma:xVl + 171 title:@"Г"];
}

// этот метод пришлось продублировать, так как мне не удалось передать параметр int в селектор

- (void) tipsHelpFriend:(CGFloat) heightOne heightOne:(CGFloat) heightTwo {
    
    CGRect rect = CGRectMake(40, heightOne, 240, 448);
    UIView *screenSaver = [[UIView alloc] initWithFrame:rect];
    screenSaver.backgroundColor = [UIColor blackColor];
    screenSaver.alpha = 0.8;
    screenSaver.layer.cornerRadius = 12;
    [self.view addSubview:screenSaver];
    self.screenSaver = screenSaver;
    [UIView animateWithDuration:0.45
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         screenSaver.frame = CGRectMake(40, heightTwo, 240, 448);
                     }
                     completion:nil];
    
    NSInteger xValue = 12;
    [self createdViewDiagramma:xValue rndHeight:arc4random_uniform(300) + 1];
    [self createdViewDiagramma:xValue + 57 rndHeight:arc4random_uniform(300) + 1];
    [self createdViewDiagramma:xValue + 114 rndHeight:arc4random_uniform(300) + 1];
    [self createdViewDiagramma:xValue + 171 rndHeight:arc4random_uniform(300) + 1];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 385, 200, 25)];
    btn.backgroundColor = [UIColor colorWithRed:(29 / 255.0f) green:(109 / 255.0f) blue:(251 / 255.0f) alpha:1];
    btn.layer.cornerRadius = 12;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 0.75;
    [btn setTitle:@"Да" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [screenSaver addSubview:btn];
    [btn addTarget:self action:@selector(deletScreenFriend) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger xVl = 28;
    [self titleLabelDiagramma:xVl title:@"A"];
    [self titleLabelDiagramma:xVl + 57 title:@"Б"];
    [self titleLabelDiagramma:xVl + 114 title:@"В"];
    [self titleLabelDiagramma:xVl + 171 title:@"Г"];
    
}

- (void) deletScreenHall {
    
    [UIView animateWithDuration:0.35
                          delay:0
                        options: UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.screenSaver.alpha = 0;
                     }completion:^(BOOL finished){
                         [self.screenSaver removeFromSuperview];
                     }];
    [self addDeleteImage:43];
}

- (void) deletScreenFriend {
    
    [UIView animateWithDuration:0.35
                          delay:0
                        options: UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.screenSaver.alpha = 0;
                     }completion:^(BOOL finished){
                         [self.screenSaver removeFromSuperview];
                     }];
    [self addDeleteImage:128];
}

- (void) addDeleteImage:(NSInteger) xValue {
    
    UIImage *imgDelete = [UIImage imageNamed:@"delete"];
    UIImageView *imgVw = [[UIImageView alloc] initWithImage:imgDelete];
    imgVw.frame = CGRectMake(xValue, 20, 65, 35);
    imgVw.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imgVw];
}

#pragma mark - Diagramma Hint Hall And Call Friends

- (void) createdViewDiagramma:(NSInteger) originX rndHeight:(NSInteger) rndHeight {
    
    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(originX, 348, 45, 0)];
    viewOne.backgroundColor = [UIColor yellowColor];
    [self.screenSaver addSubview:viewOne];
    [UIView animateWithDuration:2.0
                          delay:0.45
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         viewOne.frame = CGRectMake(originX, 348, 45, -rndHeight);
                     }
                     completion:nil];
}

-(void) titleLabelDiagramma:(NSInteger) xValue title:(NSString *) title {
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(xValue, 10, 20, 20)];
    lbl.text = title;
    lbl.textColor = [UIColor whiteColor];
    [self.screenSaver addSubview:lbl];
}

#pragma mark - Hint50_50

-(void) deletRandomButtons {
    
    
    NSMutableArray *randomButon = [NSMutableArray array];
    int remaining = 2;
    if ([self.buttons count] >= remaining) {
        while (remaining > 0) {
            UIButton *button = self.buttons[arc4random_uniform((int)self.buttons.count)];
            [UIView animateWithDuration:0.5
                                  delay:0
                                options: UIViewAnimationOptionLayoutSubviews
                             animations:^{
                                 button.alpha = 0;
                             }completion:^(BOOL finished){
                                 [button removeFromSuperview];
                             }];
            if (![randomButon containsObject:button]) {
                [randomButon addObject:button];
                remaining--;
            }
        }
    }
    [self addDeleteImage:213];
}


#pragma mark - Actions

- (void) buttonOne {
    
    [self parsingAnswerJson:self.urlStringOne button:self.oneButton];
}

- (void) buttonTwo {
    
    [self parsingAnswerJson:self.urlStringTwo button:self.twoButton];
}

- (void) buttonThree {
    
    [self parsingAnswerJson:self.urlStringFree button:self.threeButton];
}

- (void) buttonFore {
    
    [self parsingAnswerJson:self.urlStringFore button:self.foreButton];
}


- (void) actionHintOneProgramming {
    
    if (counterHintHall == 0) {
        ++counterHintHall;
        [self tipsHelpHall:1016 heightOne:60];
    }
}

- (void) actionHintTwoProgramming {
    
    if (counterHintFriends == 0) {
        ++counterHintFriends;
        [self tipsHelpFriend:1016 heightOne:60];
    }
}

- (void) actionHintThreeProgramming {
   
   CGRect rect = CGRectMake(40, -120, 240, 160);
   UIView *verificationHintView = [[UIView alloc] initWithFrame:rect];
   verificationHintView.backgroundColor = [UIColor blackColor];
   verificationHintView.alpha = 0.85;
   verificationHintView.layer.cornerRadius = 12;
   [self.view addSubview:verificationHintView];
   self.verificationHintView = verificationHintView;
   
   CGRect rectLbl = CGRectMake(30, 10, 180, 60);
   UILabel *lbl = [[UILabel alloc] initWithFrame:rectLbl];
   [lbl setText:@"Вы хотите убрать два неверных ответа?"];
   lbl.textColor = [UIColor whiteColor];
   lbl.lineBreakMode = NSLineBreakByWordWrapping;
   lbl.numberOfLines = 0;
   [verificationHintView addSubview:lbl];
   
   UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, 75, 180, 25)];
   btn.backgroundColor = [UIColor colorWithRed:(29 / 255.0f) green:(109 / 255.0f) blue:(251 / 255.0f) alpha:1];
   btn.alpha = 0.85f;
   [btn setTitle:@"Да" forState:UIControlStateNormal];
   [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   btn.layer.cornerRadius = 12;
   btn.layer.borderColor = [UIColor whiteColor].CGColor;
   btn.layer.borderWidth = 1;
   [verificationHintView addSubview:btn];
   [btn addTarget:self action:@selector(verificationHint) forControlEvents:UIControlEventTouchUpInside];
   
   UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(30, 115, 180, 25)];
   btn2.backgroundColor = [UIColor colorWithRed:(29 / 255.0f) green:(109 / 255.0f) blue:(251 / 255.0f) alpha:1];
   btn2.alpha = 0.85f;
   [btn2 setTitle:@"Нет" forState:UIControlStateNormal];
   [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   btn2.layer.cornerRadius = 12;
   btn2.layer.borderColor = [UIColor whiteColor].CGColor;
   btn2.layer.borderWidth = 1;
   [verificationHintView addSubview:btn2];
   [btn2 addTarget:self action:@selector(disappearanceView) forControlEvents:UIControlEventTouchUpInside];
   
   [UIView animateWithDuration:0.45
                         delay:0
        usingSpringWithDamping:0.7
         initialSpringVelocity:0.5
                       options:UIViewAnimationOptionLayoutSubviews
                    animations:^{
                       verificationHintView.frame = CGRectMake(40, 200, 240, 160);
                    }
                    completion:nil];
}


- (void) disappearanceView {
   
   [UIView animateWithDuration:1.0
                         delay:0
        usingSpringWithDamping:0.7
         initialSpringVelocity:0.5
                       options:UIViewAnimationOptionLayoutSubviews
                    animations:^{
                       self.verificationHintView.frame = CGRectMake(40, -160, 240, 120);
                    }
                    completion:nil];
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self.verificationHintView removeFromSuperview];
   });
}


- (void) verificationHint {
   
   [UIView animateWithDuration:1.0
                         delay:0
        usingSpringWithDamping:0.7
         initialSpringVelocity:0.5
                       options:UIViewAnimationOptionLayoutSubviews
                    animations:^{
                       self.verificationHintView.frame = CGRectMake(40, -160, 240, 120);
                    }
                    completion:nil];
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self.verificationHintView removeFromSuperview];
   });
   
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      if (counterHint50_50 == 0) {
         ++counterHint50_50;
         [self deletRandomButtons];
      }
   });
}

- (void) createdRestartButton:(UIView *) view {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 520, 220, 25)];
    btn.backgroundColor = [UIColor colorWithRed:(29 / 255.0f) green:(109 / 255.0f) blue:(251 / 255.0f) alpha:0.7f];
    [btn setTitle:@"Хотите играть сначала?" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 12;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1;
    [view addSubview:btn];
    self.restartButton = btn;
    [btn addTarget:self action:@selector(restartGame) forControlEvents:UIControlEventTouchUpInside];
}

- (void) restartGame {
   
   [self generationRequestQuestions];
   [self createdButtons];
   if (self.restartButton) {
      [self.restartButton removeFromSuperview];
   }
   [self createdButtonHints];
}

@end
