//
//  SharedParsing.m
//  HorizontolScroll
//
//  Created by Ayan Khan on 05/09/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

#import "SharedParsing.h"

#define sharedQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation SharedParsing

static NSString *const FLICKR_URL = @"https://api.flickr.com/services/feeds/photos_public.gne?format=json";

SINGLETON_FOR_CLASS(SharedParsing);

-(void)assignSender:(id)sender
{
    obj = sender;
}

#pragma mark - FEEDS WEBSERVICE -

- (void)WSCallForFeeds:(NSDictionary*)dict
          successBlock:(completionBlock)completionBlock
          failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSURL *url1 = [NSURL URLWithString:FLICKR_URL];
                       [self createNSUrlSession:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                       
                   });
}


#pragma mark - CREATE NSURLSESSION -

-(void)createNSUrlSession:(NSURL*)URL postDict:(NSDictionary*)dict successBlock:(completionBlock)completionBlock
             failureBlock:(failureBlock)failure
{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          
                                          {
                                              if ([data length] > 0 && error == nil)
                                              {
                                                  //The below lines removes ‘jsonFlickrFeed’ from Flickr json response****Below lines copied from stackoverflow:)
                                                  NSString *dataAsString = [NSString stringWithUTF8String:[data bytes]];
                                                  //remove the leading ‘jsonFlickrFeed(‘ and trailing ‘)’ from the response data so we are left with a dictionary root object
                                                  NSString *correctedJSONString = [NSString stringWithString:[dataAsString substringWithRange:NSMakeRange (15, dataAsString.length-15-1)]];
                                                  //Flickr incorrectly tries to escape single quotes – this is invalid JSON (see http://stackoverflow.com/a/2275428/423565)
                                                  //correct by removing escape slash (note NSString also uses \ as escape character – thus we need to use \\)
                                                  correctedJSONString = [correctedJSONString stringByReplacingOccurrencesOfString:@"\\'" withString:@"‘"];
                                                  //re-encode the now correct string representation of JSON back to a NSData object which can be parsed by NSJSONSerialization
                                                  NSData *correctedData = [correctedJSONString dataUsingEncoding:NSUTF8StringEncoding];
                                                  NSError *error = nil;
                                                  
                                                  
                                                  NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:correctedData options:kNilOptions error:&error];
                                                  NSLog(@"result json: %@", jsonArray);
                                                  
                                                  if (!jsonArray) {
                                                      NSLog(@"Get Feeds Error is %@",[error description]);
                                                      failure(NO,nil);
                                                  }else
                                                  {
                                                      completionBlock(YES,jsonArray);
                                                  }
                                                  
                                              }
                                              
                                              else if ([data length] == 0 && error == nil){
                                                  failure(NO,nil);
                                              }
                                              
                                              else if (error != nil){
                                                  NSLog(@"Get Feeds Error is %@",[error description]);
                                                  failure(NO,nil);
                                              }
                                              
                                          }];
    
    [postDataTask resume];
}

@end
