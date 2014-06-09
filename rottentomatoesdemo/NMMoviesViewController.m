//
//  NMMoviesViewController.m
//  rottentomatoesdemo
//
//  Created by Nicolas Melo on 6/4/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "NMMoviesViewController.h"
#import "NMMovieTableViewCell.h"
#import "NMMovie.h"
#import "NMNetworkErrorView.h"
#import "NMDetailViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface NMMoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NMNetworkErrorView *networkErrorView;
@property (nonatomic, strong) UIActivityIndicatorView *networkActivityIndicator;
@property (atomic, copy) NSMutableArray *movies;
@end

@implementation NMMoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.movies = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 120;
    [self.tableView registerNib:[UINib nibWithNibName:@"NMMovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    self.networkActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.networkActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.networkActivityIndicator];
    [self navigationItem].rightBarButtonItem = barButton;
    self.navigationItem.title = @"In Theaters";
    
    CGRect errorWindow = CGRectMake(0, 64, 320, 20);
    self.networkErrorView = [[NMNetworkErrorView alloc] initWithFrame:errorWindow];
    [self.navigationController.view.window addSubview:self.networkErrorView];
    [self.networkErrorView setHidden:YES];
    
    
    [self refresh];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadMoviesForURL:(NSString *)uri {
    
    NSURL *url = [NSURL URLWithString:uri];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.networkErrorView setHidden:YES];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *moviesFromNetwork = (NSArray *)responseObject[@"movies"];
        NSMutableArray *currentMovies = [[NSMutableArray alloc] init];
        
        for (NSDictionary *m in moviesFromNetwork) {
            NMMovie *movie = [[NMMovie alloc] initWithDictionary:m];
            [currentMovies addObject:movie];
        }
        
        self.movies = currentMovies;
        
        [self.tableView reloadData];
        [self.networkActivityIndicator stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed to load movies data from Rotten Tomatoes: %@", error.description);
        [self.networkActivityIndicator stopAnimating];
        [self.networkErrorView setHidden:NO];
    }];
    
    [self.networkActivityIndicator startAnimating];
    [operation start];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < -100 && !self.networkActivityIndicator.isAnimating) {
        [self refresh];
    }
}

- (void)refresh {
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=dqghrug2e4mwtn4jv2hyecsy";
    [self downloadMoviesForURL:url];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NMMovieTableViewCell *movieCell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NMMovie *movie = self.movies[indexPath.row];
    movieCell.titleLabel.text = movie.title;
    movieCell.synopsisLabel.text = movie.synopsis;
    movieCell.posterImageView.image = nil;
    
    if (movie.mediumPosterImage) {
        NSLog(@"Got our poster image already.");
        movieCell.posterImageView.image = movie.mediumPosterImage;
    }
    else {
        NSLog(@"Fetch poster image from the API");
        movieCell.posterImageView.image = nil;
        NSURL *url = [NSURL URLWithString:movie.mediumPosterURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            UIImage* poster = (UIImage *)responseObject;
            
            CGSize itemSize = CGSizeMake(poster.size.width, poster.size.height);
            UIGraphicsBeginImageContext(itemSize);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [poster drawInRect:imageRect];
            movieCell.posterImageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            movie.mediumPosterImage = movieCell.posterImageView.image;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Failed to load profile poster image.");
        }];
        
        [operation start];
    }
    
    return movieCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NMMovie *movie = self.movies[indexPath.row];
    NSLog(@"Selected: %@", movie.largePosterURL);
    NMDetailViewController *detailViewController = [[NMDetailViewController alloc] initWithNibName:@"NMDetailViewController" bundle:nil];
    detailViewController.movieInfo = movie;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


@end