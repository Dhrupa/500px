//
//  GenericNotificationEvent.h
//  Challange-500px
//
//  Created by Dhrupa on 2019-03-15.
//  Copyright © 2019 Dhrupa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GenericNotificationEvent : NSObject

+ (NSString *) notificationID;
+ (void)postEvent:(id)eventObject;
+ (void)subscribe:(id)target selector:(SEL)selector;
+ (void)unsubscribe:(id)target;

@end

NS_ASSUME_NONNULL_END
