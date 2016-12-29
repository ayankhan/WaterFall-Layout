//
//  ViewController.m
//  WaterFall Layout
//
//  Created by Ayan Khan on 29/12/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

#import "ViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PhotoCell.h"
#import "SharedParsing.h"
#import "AppDelegate.h"
#import "PhotoModel.h"
#import "UIViewController+Alert.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailViewController.h"

#define CELL_IDENTIFIER @"PhotoCellID"

#define kSharedParsing [SharedParsing sharedSharedParsing]
# define kAppdelegate  (AppDelegate*) [[UIApplication sharedApplication] delegate]


@interface ViewController ()<CHTCollectionViewDelegateWaterfallLayout>
@property (weak, nonatomic) IBOutlet CHTCollectionViewWaterfallLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *cellSizes;
@property(strong,nonatomic) NSArray *arrayPhotos;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _flowLayout.headerHeight = 0;
    _flowLayout.footerHeight = 0;
    _flowLayout.minimumColumnSpacing = 8;
    _flowLayout.minimumInteritemSpacing = 8;
    _flowLayout.columnCount = 3 ;
    
    
    [self wsCallForImages];
    
}


- (NSArray *)cellSizes {
    if (!_cellSizes) {
        _cellSizes = @[
                       [NSValue valueWithCGSize:CGSizeMake(170, 250)],
                       [NSValue valueWithCGSize:CGSizeMake(170, 220)]
                       ];
    }
    return _cellSizes;
}
#pragma mark - WEBSERVICE For Images

-(void)wsCallForImages{
    
    if([kAppdelegate Is_InternetAvailable]){
        
        [kAppdelegate showLoadingAnimation];
        
        [kSharedParsing assignSender:self];
        
        [kSharedParsing WSCallForFeeds:nil successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
            
                /*....Add Objects Through Model....*/
                self.arrayPhotos=[PhotoModel getImages:[resultArray valueForKey:@"items"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.collectionView reloadData];
                    [kAppdelegate hideLoadingAnimation];
                    
                    
                });
                
        }
                          failureBlock:^(BOOL succeeded, NSArray *failureArray) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [kAppdelegate hideLoadingAnimation];
                                  [self showAlertViewWithTitle:@"Error" message:@"Something went wrong."];
                              });
                              
                          }];
    }
    else{
        
        [self showAlertViewWithTitle:@"No Internet!" message:@"Please check your Internet Connection."];
    }
    
}
#pragma mark - UICollectionViewDataSource & Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell =
    (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                           forIndexPath:indexPath];
    
    /*....Get Model from Array....*/
    PhotoModel *photo = (PhotoModel*)[self.arrayPhotos objectAtIndex:indexPath.row];
    
    // Configure the cell
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:photo.image]];

    
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor grayColor].CGColor;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    DetailViewController *mDetailVC = (DetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewControllerID"];
    mDetailVC.photo = [self.arrayPhotos objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:mDetailVC animated:YES];
    
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellSizes[indexPath.item % 2] CGSizeValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
