//
//  SharedParsing.h
//  HorizontolScroll
//
//  Created by Ayan Khan on 05/09/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingeltonMacro.h"

typedef void (^completionBlock) (BOOL succeeded, NSArray *resultArray);
typedef void (^failureBlock) (BOOL succeeded, NSArray *failureArray);

@interface SharedParsing : NSObject{
    id obj;
}


-(void)assignSender:(id)sender;

- (void)WSCallForFeeds:(NSDictionary*)dict
          successBlock:(completionBlock)completionBlock
          failureBlock:(failureBlock)failure;


SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(SharedParsing);


@end

