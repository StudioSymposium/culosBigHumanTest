//
//  ccbhInstagramCollectionViewCell.h
//  culosBigHumanTest
//
//  Created by Chris Culos on 1/4/16.
//  Copyright © 2016 Chris Culos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ccbhInstagramCollectionViewCell : UICollectionViewCell
{
    
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;

- (void)setImageUrl:(NSURL *)imageURL;

@end
