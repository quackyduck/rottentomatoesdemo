//
//  NMAppDelegate.m
//  rottentomatoesdemo
//
//  Created by Nicolas Melo on 6/4/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "NMAppDelegate.h"
#import "NMMoviesViewController.h"

@implementation NMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
                                                            diskCapacity:100 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSMutableArray *tabItems = [[NSMutableArray alloc] initWithCapacity:2];
    
    NMMoviesViewController *vc = [[NMMoviesViewController alloc] initWithNibName:@"NMMoviesViewController" type:0];
    NMMoviesViewController *vc2 = [[NMMoviesViewController alloc] initWithNibName:@"NMMoviesViewController" type:1];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBar.barTintColor = [UIColor colorWithRed:255.0f/255.0f green:204.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    nvc.navigationBar.tintColor = [UIColor blackColor];
    nvc.tabBarItem.title = @"In Theaters";
    nvc.tabBarItem.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"film50" ofType:@"png"]];
    [tabItems addObject:nvc];
    
    UINavigationController *nvc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    nvc2.navigationBar.barTintColor = [UIColor colorWithRed:255.0f/255.0f green:204.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    nvc2.navigationBar.tintColor = [UIColor blackColor];
    nvc2.tabBarItem.title = @"DVD Rentals";
    nvc2.tabBarItem.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"compact10" ofType:@"png"]];
    [tabItems addObject:nvc2];
    
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    tbc.viewControllers = @[nvc, nvc2];
    
    self.window.rootViewController = tbc;
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
