//
//  AppDelegate.m
//  WaterFall Layout
//
//  Created by Ayan Khan on 29/12/16.
//  Copyright © 2016 Ayan Khan. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"

#define kWINDOW_SIZE [[UIScreen mainScreen]bounds].size

@interface AppDelegate ()
{
    UIActivityIndicatorView * loadingIndicator;
    
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /*....Loading Indicator Initialization....*/
    [self customLoadingIndicator];

    return YES;
}

#pragma mark - Reachability

- (BOOL)Is_InternetAvailable
{
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection]
                               currentReachabilityStatus];
    BOOL isInternetActive = YES;
    if(netStatus == NotReachable)
    {
        isInternetActive = NO;
    }
    return isInternetActive;
}
#pragma mark - Loading Indicator Methods

-(void)customLoadingIndicator
{
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [_window addSubview:loadingIndicator];
}
-(void)showLoadingAnimation
{
    
    [loadingIndicator setFrame:CGRectMake(kWINDOW_SIZE.width/2, kWINDOW_SIZE.height/2, 10, 10)];
    [_window bringSubviewToFront:loadingIndicator];
    [self.window setUserInteractionEnabled:NO];
    [loadingIndicator startAnimating];
    
}
-(void)hideLoadingAnimation
{
    
    [self.window setUserInteractionEnabled:YES];
    [loadingIndicator stopAnimating];
    [_window sendSubviewToBack:loadingIndicator];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
