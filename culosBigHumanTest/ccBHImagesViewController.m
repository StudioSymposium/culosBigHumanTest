//
//  ccBHImagesViewController.m
//  culosBigHumanTest
//
//  Created by Chris Culos on 1/4/16.
//  Copyright © 2016 Chris Culos. All rights reserved.
//

#import "ccBHImagesViewController.h"
#import "InstagramKit.h"
#import "FMMosaicLayout.h"
#import "SVProgressHUD.h"
#import <Social/Social.h>
//
#import "ccbhInstagramCollectionViewCell.h"

@interface ccBHImagesViewController ()

@property (nonatomic, strong)   NSMutableArray *mediaArray;
@property (nonatomic, strong)   InstagramPaginationInfo *currentPaginationInfo;
@property (nonatomic, weak)     InstagramEngine *instagramEngine;

@end

@implementation ccBHImagesViewController

- (void)viewDidLoad {
    
    _imagesArray = [[NSMutableArray alloc] init];
    
    FMMosaicLayout *layout = [[FMMosaicLayout alloc] init];
    
    self.collectionView.collectionViewLayout = layout;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.currentPaginationInfo = nil;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self loadFeed];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)loadFeed
{
    [[InstagramEngine sharedEngine] getSelfRecentMediaWithCount:20 maxId:self.currentPaginationInfo.nextMaxId success:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo)
    {
        self.currentPaginationInfo = paginationInfo;
        [_imagesArray addObjectsFromArray:media];
        [_collectionView reloadData];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode)
    {
                 NSLog(@"Error: %@", error);
    }];
}


#pragma mark COLLECTION VIEW

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout numberOfColumnsInSection:(NSInteger)section
{
    return 3;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (FMMosaicCellSize)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout mosaicCellSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMMosaicCellSize cellSize;
    
    NSUInteger randomIndex = arc4random() % [_imagesArray count];
    
    if (randomIndex % 3)
    {
        cellSize = FMMosaicCellSizeBig;
    }
    else
    {
        cellSize = FMMosaicCellSizeSmall;
    }
    
    return cellSize;
}

- (CGFloat)collectionView:(UICollectionViewCell *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    ccbhInstagramCollectionViewCell *cell = (ccbhInstagramCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = (ccbhInstagramCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    else
    {
        InstagramMedia *image = self.imagesArray[indexPath.row];
        [cell setImageUrl:image.standardResolutionImageURL];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma MARK SHARE

- (void)takeScreenshotAndReturnImage:(void (^)(UIImage *))image
{
    [SVProgressHUD showInfoWithStatus:@"Loading"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
    {    
        CALayer *layer;
        
        layer = _collectionView.layer;
        
        UIGraphicsBeginImageContext(_collectionView.frame.size);
        [layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *sharedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [SVProgressHUD dismiss];
            image(sharedImage);
        });
    });
}

- (IBAction)shareMenu:(id)sender
{
    UIAlertController *shareMenu = [UIAlertController alertControllerWithTitle:@"Share" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
    {
        nil;
    }];
    
    UIAlertAction *fbShare = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [self shareImageWithService:SLServiceTypeFacebook];
    }];
    
    UIAlertAction *twitShare = [UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [self shareImageWithService:SLServiceTypeTwitter];
    }];
    
    UIAlertAction *saveImage = [UIAlertAction actionWithTitle:@"Save to Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [self saveImage];
    }];
    
    [shareMenu addAction:cancel];
    [shareMenu addAction:fbShare];
    [shareMenu addAction:twitShare];
    [shareMenu addAction:saveImage];
    [self presentViewController:shareMenu animated:YES completion:^{
        nil;
    }];
}

- (void)shareImageWithService:(NSString *)service
{
    [self takeScreenshotAndReturnImage:^(UIImage *image)
     {
         SLComposeViewController *share = [SLComposeViewController composeViewControllerForServiceType:service];
         [share addImage:image];
         [share setInitialText:@"Hi Big Human!"];
         [self presentViewController:share animated:YES completion:^
          {
              nil;
          }];
     }];
}

- (void)saveImage
{
    [self takeScreenshotAndReturnImage:^(UIImage *image)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imagesArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
