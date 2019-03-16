//
//  BaseHttp.h
//  Challange-500px
//
//  Created by Dhrupa on 2019-03-15.
//  Copyright © 2019 Dhrupa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericNotificationEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseHttp : NSObject

-(void)sendHTTPGetWithURL:(NSString *)urlString
        completionHandler:(void (^)(NSData *data,NSURLResponse *response,NSError *error))completionHandler;

-(void)executeNetworkOperation;
@end

//------------------------------------------------------------------------
//
//  Events published by this object
//
//------------------------------------------------------------------------

@interface NetworkCallCompleteEvent : GenericNotificationEvent

@property(nonatomic, readonly, weak) BaseHttp* sender;

+ (void)postNotification:(BaseHttp*)sender;

@end
NS_ASSUME_NONNULL_END
