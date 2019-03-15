//
//  ViewController.h
//  Challange-500px
//
//  Created by Dhrupa on 2019-03-14.
//  Copyright © 2019 Dhrupa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIImageView *detailImgView;
@end


