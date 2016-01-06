//
//  ccBHImagesViewController.h
//  culosBigHumanTest
//
//  Created by Chris Culos on 1/4/16.
//  Copyright © 2016 Chris Culos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMosaicLayout.h"

@interface ccBHImagesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, FMMosaicLayoutDelegate>
{
    
}

@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic, retain) NSMutableArray *imagesArray;

@end
