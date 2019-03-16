//
//  GenericNotificationEvent.m
//  Challange-500px
//
//  Created by Dhrupa on 2019-03-15.
//  Copyright © 2019 Dhrupa. All rights reserved.
//

#import "GenericNotificationEvent.h"

@implementation GenericNotificationEvent

+ (NSString *) notificationID
{
    return NSStringFromClass(self);
}

//------------------------------------------------------------------------

+ (void)postEvent:(GenericNotificationEvent *)eventObject
{
    if (eventObject)
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [[NSNotificationCenter defaultCenter] postNotificationName: [self class].notificationID object:eventObject];
        });
    }
}

//------------------------------------------------------------------------

+ (void)subscribe:(id)target selector:(SEL)selector
{
    [[self class] unsubscribe:target];
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:[self class].notificationID object:nil];
}

//------------------------------------------------------------------------

+ (void)unsubscribe:(id)target
{
    [[NSNotificationCenter defaultCenter] removeObserver:target name:[self class].notificationID object:nil];
}

@end
