//
//  NetworkQueueManager.m
//  Challange-500px
//
//  Created by Dhrupa on 2019-03-15.
//  Copyright © 2019 Dhrupa. All rights reserved.
//

#import "NetworkQueueManager.h"

@implementation NetworkQueueManager
static NetworkQueueManager *sharedManager = nil;    // static instance variable
bool mBusy;

+ (NetworkQueueManager *)sharedManager {
    if (sharedManager == nil) {
        sharedManager = [[self alloc] init];
    }
    return sharedManager;
}

- (id)init {
    if ( (self = [super init]) ) {
        // your custom initialization
        self.networkOperations = [[NSMutableArray alloc] init];
        [NetworkCallCompleteEvent subscribe:self selector:@selector(onNetworkCallComplete:)];
        mBusy = false;
    }
    return self;
}

- (void)dealloc
{
    [NetworkCallCompleteEvent unsubscribe:self];
}

-(void)addNetworkOperation:(BaseHttp *)networkOperation
{
    [self.networkOperations addObject:networkOperation];
    [self executeNextIfReady];
}

-(void)clearQueue
{
    [self.networkOperations removeAllObjects];
}
- (void)onNetworkCallComplete:(NSNotification *)notification
{
    mBusy = false;
    [self executeNextIfReady];
}

-(void)executeNextIfReady
{
    if( !mBusy )
    {
        if( [self.networkOperations count] > 0)
        {
            mBusy = true;
            BaseHttp * networkOperation = [self.networkOperations objectAtIndex:0];
            [self.networkOperations removeObjectAtIndex:0];
            [networkOperation executeNetworkOperation];
        }
    }
    else
    {
        NSLog(@"BUSY.. wait until next time");
    }
}

@end
