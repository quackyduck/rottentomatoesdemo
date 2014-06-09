//
//  NMMovieTableViewCell.h
//  rottentomatoesdemo
//
//  Created by Nicolas Melo on 6/4/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMMovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;

@end
