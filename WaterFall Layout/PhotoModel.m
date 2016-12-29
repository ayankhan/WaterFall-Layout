//
//  PhotoModel.m
//  WaterFall Layout
//
//  Created by Ayan Khan on 29/12/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

#define kPropertyImagepath @"media.m"

#pragma mark - Get Feeds Data in Model

+(NSMutableArray*)getImages:(NSArray *)data
{
    NSMutableArray* tempArray=[[NSMutableArray alloc]init];
    for (NSDictionary* dict in data) {
        PhotoModel* mFeed=[[PhotoModel alloc]init];
        
        mFeed.image=[dict valueForKeyPath:kPropertyImagepath];
        
        [tempArray addObject:mFeed];
    }
    return tempArray;
}

@end
