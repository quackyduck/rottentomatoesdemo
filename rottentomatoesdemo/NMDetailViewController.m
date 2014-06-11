//
//  NMDetailViewController.m
//  rottentomatoesdemo
//
//  Created by Nicolas Melo on 6/8/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "NMDetailViewController.h"
#import "NMMovie.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"

@interface NMDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (nonatomic, strong) UIActivityIndicatorView *networkActivityIndicator;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *synopsisView;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation NMDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.networkActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.networkActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.networkActivityIndicator];
    [self navigationItem].rightBarButtonItem = barButton;
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,32,32)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = self.movieInfo.title;
    [titleLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:18.0]];

    self.navigationItem.titleView = titleLabel;
    
    
    NSLog(@"URL: %@", self.movieInfo.largePosterURL);
    
    NSURL *url = [NSURL URLWithString:self.movieInfo.largePosterURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.networkActivityIndicator startAnimating];
    
    [self.posterView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        UIImage* poster = image;
        UIImage* croppedImage = nil;
        
        // Whole screen
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        // How much larger is our image than the screen?
        CGFloat scalingFactor = screenRect.size.height / poster.size.height;
        
        // Get the new width which is bigger than our screen's width
        CGFloat scaledWidth = poster.size.width * scalingFactor;
        
        // Calculate the new X coordinate which will be offscreen
        CGFloat offScreenX = (scaledWidth - screenRect.size.width)/2;
        
        // Begin drawing the new image
        UIGraphicsBeginImageContextWithOptions(screenRect.size, YES, 0.0);
        
        CGPoint croppedPoint = CGPointMake(-offScreenX, 0.0);
        CGRect croppedRect = CGRectZero;
        croppedRect.origin = croppedPoint;
        croppedRect.size.width  = scaledWidth;
        croppedRect.size.height = screenRect.size.height;
        
        // Redraw the downloaded poster in the new rect
        [poster drawInRect:croppedRect];
        
        croppedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.posterView.alpha = 0.0;
        
        // Assign the image to our UIImageView
        self.posterView.image = croppedImage;
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.posterView.alpha = 1.0;
                         }];
        
        
        // Stop network indicator
        [self.networkActivityIndicator stopAnimating];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load profile poster image.");
    }];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat synopsisViewOffset = 300.0;

    self.titleLabel.text = self.movieInfo.title;
    [self.titleLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:17.0]];
    self.synopsisLabel.text = self.movieInfo.synopsis;
    [self.synopsisLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    [self.synopsisLabel sizeToFit];
    
    // Calculate the size of the translucent synopsis view with padding
    float textHeight = self.titleLabel.frame.size.height + self.synopsisLabel.frame.size.height + 50;
    
    // Ensure our UIView reaches the bottom
    CGFloat synopsisViewHeight = (textHeight + (screenHeight - synopsisViewOffset) > screenHeight) ? textHeight : synopsisViewOffset;
    
    // Arbitrarily start the synopsis view 300 points from the bottom
    CGRect synopsisViewRect = CGRectMake(0.0, screenHeight-synopsisViewOffset, screenWidth, synopsisViewHeight);
    
    self.synopsisView.frame = synopsisViewRect;
    float contentHeight = self.synopsisView.frame.origin.y + self.synopsisView.frame.size.height;
    [self.scrollView setContentSize: CGSizeMake(screenWidth, contentHeight)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
