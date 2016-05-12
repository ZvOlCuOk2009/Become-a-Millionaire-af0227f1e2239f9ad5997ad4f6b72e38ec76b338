//
//  TSServerManager.h
//  Test Become a Millionaire
//
//  Created by Mac on 09.03.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSRequest.h"

@interface TSServerManager : NSObject

@property (strong, nonatomic) TSRequest *request;

+ (TSServerManager *) sharedManager;

- (void) postRequestAnswerTheServer:(NSString *) idRequest
                          onSuccess:(void(^)(TSRequest *request)) success
                           onFailre:(void(^)(NSError *error)) failure;

- (void) getRequestQuestionTheServer:(NSString *) idRequest
                           onSuccess:(void(^)(TSRequest *request)) success
                            onFailre:(void(^)(NSError *error)) failure;

@end
