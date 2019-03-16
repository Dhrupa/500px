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

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (self.detailItem != newDetailItem) {
        self.detailItem = newDetailItem;
        // Update the view.
        [self updateDetailView];
    }
}

- (void)updateDetailView
{
    if (self.detailItem)
    {
        self.detailImgView.image = [UIImage imageWithData:[self.detailItem valueForKey:@"imgUrlData"]];
        self.title = [self.detailItem valueForKey:@"imgName"];
    }
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
