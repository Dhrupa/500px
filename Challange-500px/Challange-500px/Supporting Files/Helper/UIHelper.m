//
//  UIHelper.m
//  Challange-500px
//
//  Created by Dhrupa on 2019-03-16.
//  Copyright © 2019 Dhrupa. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper

-(void)showSimpleAlertController:(NSString *)title errorMessage:(NSString *)message viewController:(UIViewController *)vc
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:ok];
    
    [vc presentViewController:alertController animated:YES completion:nil];
}


@end
