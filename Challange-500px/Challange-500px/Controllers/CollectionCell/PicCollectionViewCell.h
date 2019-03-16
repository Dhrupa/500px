//
//  PicCollectionViewCell.h
//  Challange-500px
//
//  Created by Dhrupa on 2019-03-14.
//  Copyright © 2019 Dhrupa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PicCollectionViewCell : UICollectionViewCell
{
    IBOutlet UIImageView *imgView;
}

-(void)setImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
