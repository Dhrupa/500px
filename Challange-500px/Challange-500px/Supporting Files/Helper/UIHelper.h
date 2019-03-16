//
//  UIHelper.h
//  Challange-500px
//
//  Created by Dhrupa on 2019-03-16.
//  Copyright © 2019 Dhrupa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PicCollectionViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIHelper : NSObject

// ALERT HELPERS
-(void)showSimpleAlertController:(NSString *)title errorMessage:(NSString *)message viewController:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
