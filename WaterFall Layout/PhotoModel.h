//
//  PhotoModel.h
//  WaterFall Layout
//
//  Created by Ayan Khan on 29/12/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject
/*....Photo Properties....*/

@property(nonatomic,retain)NSString* image;

/*....Modelize....*/
+(NSMutableArray*)getImages:(NSArray*)data;

@end
