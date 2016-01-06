//
//  ccbhInstagramCollectionViewCell.m
//  culosBigHumanTest
//
//  Created by Chris Culos on 1/4/16.
//  Copyright © 2016 Chris Culos. All rights reserved.
//

#import "ccbhInstagramCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ccbhInstagramCollectionViewCell

- (void)setImageUrl:(NSURL *)imageURL
{
    [_imageView setImageWithURL:imageURL];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.imageView setImage:nil];
}
@end
