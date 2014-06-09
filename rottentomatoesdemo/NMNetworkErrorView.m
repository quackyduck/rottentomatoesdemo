//
//  NMNetworkErrorView.m
//  rottentomatoesdemo
//
//  Created by Nicolas Melo on 6/7/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "NMNetworkErrorView.h"

@implementation NMNetworkErrorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSString *errorText = @"Network Error";
        UILabel *label = [[UILabel alloc] init];
        [label setText: errorText];
        [label setTextColor:[UIColor blackColor]];
        [label setBackgroundColor: [UIColor clearColor]];
        [self addSubview:label];
        
        float labelWidth = [errorText boundingRectWithSize:label.frame.size
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{ NSFontAttributeName:label.font }
                                                   context:nil].size.width;
        
        float xPosition = (320 - labelWidth)/2;
        [label setFrame:CGRectMake(xPosition, 2, labelWidth, 16)];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[UIColor colorWithRed:0.78 green:0.58 blue:0.58 alpha:1.0] set];
    UIRectFill([self bounds]);
    
}

@end
