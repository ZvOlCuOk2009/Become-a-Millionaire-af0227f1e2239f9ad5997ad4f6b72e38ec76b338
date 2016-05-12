//
//  TSServerManager.m
//  Test Become a Millionaire
//
//  Created by Mac on 09.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSServerManager.h"
#import "AFNetworking.h"

@interface TSServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManagerQuestion;

@end

@implementation TSServerManager

+ (TSServerManager *) sharedManager {
    
    static TSServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TSServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *stringURLQuestion = [NSURL URLWithString:
                                    @"http://ec2-52-37-184-161.us-west-2.compute.amazonaws.com:80/api/questions/"];
        self.sessionManagerQuestion = [[AFHTTPSessionManager alloc] initWithBaseURL:stringURLQuestion];
    }
    return self;
}

#pragma mark - Request


- (void) postRequestAnswerTheServer:(NSString *) idRequest
                          onSuccess:(void(^)(TSRequest *request)) success
                           onFailre:(void(^)(NSError *error)) failure {
    
    [self.sessionManagerQuestion POST:idRequest
                           parameters:nil
                             progress:nil
                              success:^(NSURLSessionTask *task, id responseObject) {
                                  NSLog(@"JSON: %@", responseObject);
                              } failure:^(NSURLSessionTask *operation, NSError *error) {
                                  NSLog(@"Error: %@", error);
                              }];
}


- (void) getRequestQuestionTheServer:(NSString *) idRequest
                           onSuccess:(void(^)(TSRequest *request)) success
                            onFailre:(void(^)(NSError *error)) failure {
    
    [self.sessionManagerQuestion GET:idRequest
                          parameters:nil
                            progress:nil
                             success:^(NSURLSessionTask *task, id responseObject) {
     NSArray *answers = [responseObject objectForKey:@"answers"];
     NSString *question = [responseObject objectForKey:@"body"];
     TSRequest *request = [[TSRequest alloc] init];
     request.answers = answers;
     request.question = question;
         if (success) {
             success(request);
                 }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


@end
