//
//  NMDetailViewController.h
//  rottentomatoesdemo
//
//  Created by Nicolas Melo on 6/8/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NMMovie;

@interface NMDetailViewController : UIViewController <UIScrollViewDelegate>

@property (atomic, strong) NMMovie *movieInfo;

@end
