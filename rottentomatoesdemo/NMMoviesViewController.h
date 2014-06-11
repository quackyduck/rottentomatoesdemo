//
//  NMMoviesViewController.h
//  rottentomatoesdemo
//
//  Created by Nicolas Melo on 6/4/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMMoviesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
- (id)initWithNibName:(NSString *)nibNameOrNil type:(NSInteger)type;
@end
