//
//  NetworkQueueManager.h
//  Challange-500px
//
//  Created by Dhrupa on 2019-03-15.
//  Copyright © 2019 Dhrupa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHttp.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkQueueManager : NSObject

@property (nonatomic) NSMutableArray* networkOperations;
+ (NetworkQueueManager *)sharedManager;   // class method to return the singleton object
-(void)addNetworkOperation:(BaseHttp *)networkOperation;
-(void)clearQueue;
@end

NS_ASSUME_NONNULL_END
