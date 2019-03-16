//
//  ViewController.m
//  Challange-500px
//
//  Created by Dhrupa on 2019-03-14.
//  Copyright © 2019 Dhrupa. All rights reserved.
//

#import "PicDetailViewController.h"

@interface PicDetailViewController ()
- (void)updateDetailView;
@end

@implementation PicDetailViewController


- (void)updateDetailView
{
    self.detailImgView.image = [UIImage imageWithData:self.imgData];
    self.title = self.imgName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Update the view.
    [self updateDetailView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
