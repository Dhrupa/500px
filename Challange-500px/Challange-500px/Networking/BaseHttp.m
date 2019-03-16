//
//  BaseHttp.m
//  Challange-500px
//
//  Created by Dhrupa on 2019-03-15.
//  Copyright © 2019 Dhrupa. All rights reserved.
//

#import "BaseHttp.h"
#import "NetworkQueueManager.h"

#define MAX_RETRY 1
#define TIME_OUT_IN_SECONDS 10

@interface BaseHttp()
@property (copy, nonatomic)  void (^mCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);
@property (strong, nonatomic) NSString *mUrlString;
@property (strong, nonatomic) NSString *mContentType;
@property (strong, nonatomic) NSData *mPostData;
@property (nonatomic) int mRetryCount;

@end

@implementation BaseHttp

- (void)setupWithURL:(NSString *)urlString
     withContentType:(NSString *)contentType
            withData:(NSData *)data
withCompletionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    self.mUrlString = urlString;
    self.mContentType = contentType;
    self.mPostData = data;
    self.mCompletionHandler = [completionHandler copy];
    self.mRetryCount = 0;
}

// GET call
-(void)sendHTTPGetWithURL:(NSString *)urlString
        completionHandler:(void (^)(NSData *data,NSURLResponse *response,NSError *error))completionHandler
{
    [self setupWithURL:urlString withContentType:nil withData:nil withCompletionHandler:completionHandler];
    NetworkQueueManager * queueManager = [NetworkQueueManager sharedManager];
    [queueManager addNetworkOperation:self];
}

-(void)executeNetworkOperation
{
    [self executeGET];
}

-(void)executeGET
{
    NSURLSession *session = [self getSessionConfiguration];
    NSMutableURLRequest *request = [self getRequestWithURL:self.mUrlString withRequestMethod:@"GET"];
    
#if DEBUG_IS_ON
    NSString *string = self.mUrlString;
    NSArray *components = [string componentsSeparatedByString: network.url_Base];
    NSString *getURLAction = (NSString*) [components objectAtIndex:(components.count-1)];
#endif
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
      {
          if( error != nil && self.mRetryCount < MAX_RETRY)
          {
              self.mRetryCount++;
#if DEBUG_IS_ON
              [[ErrorLogManager sharedManager] postLog:[NSString stringWithFormat:@"Attemping GET Retry number %d", _mRetryCount]];
              NSLog(@"%@: Attemping GET Retry number %d", getURLAction, self.mRetryCount);
#endif
              [self executeGET];
          }
          else
          {
              NSHTTPURLResponse * httpURLResponse = (NSHTTPURLResponse *)response;
              long statusCode = [httpURLResponse statusCode];
              
              if( statusCode != 200 )
              {
                  NSLog(@"Error on attempting GET: URL:%@,StatusCode:%ld", self.mUrlString,statusCode);
              }
              
              self.mCompletionHandler(data, response, error);
              [NetworkCallCompleteEvent postNotification:self];
          }
      }] resume];
}

- (id)getRequestWithURL:(NSString *)urlString withRequestMethod:(NSString *)requestMethod{
    
    NSURL *url = [NSURL URLWithString: [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = requestMethod;
    [request setValue:self.mContentType forHTTPHeaderField:@"Content-Type"];
    return request;
}

- (id)getSessionConfiguration{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIME_OUT_IN_SECONDS;
    config.timeoutIntervalForResource = TIME_OUT_IN_SECONDS;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    return session;
}



@end

//------------------------------------------------------------------------
//
//  NetworkCallCompleteEvent
//
//------------------------------------------------------------------------

@implementation NetworkCallCompleteEvent

- (id)initWithSender:(BaseHttp *)sender
{
    if ( self = [super init] )
    {
        _sender = sender;
        return self;
    }
    else
    {
        return nil;
    }
}

//------------------------------------------------------------------------

+ (void)postNotification:(BaseHttp *)sender
{
    [self postEvent:[[self alloc] initWithSender:sender]];
}

@end
