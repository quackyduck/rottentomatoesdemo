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
#import "UIImageView+AFNetworking.h"

@interface NMMoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NMNetworkErrorView *networkErrorView;
@property UIRefreshControl *refreshControl;
@property (atomic, copy) NSMutableArray *movies;
@property NSInteger controllerType;
@property (nonatomic, strong) UIActivityIndicatorView *networkActivityIndicator;
@end

@implementation NMMoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil type:(NSInteger)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        self.movies = [[NSMutableArray alloc] init];
        self.controllerType = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 110;
    [self.tableView registerNib:[UINib nibWithNibName:@"NMMovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,32,32)];
    titleLabel.textColor = [UIColor blackColor];
    
    if (self.controllerType == 0) {
        titleLabel.text = @"In Theaters";
    }
    else {
        titleLabel.text = @"Top DVD Rentals";
    }
    [titleLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:18.0]];
    
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.leftBarButtonItem.title = @"";
    
    CGRect errorWindow = CGRectMake(0, 64, 320, 20);
    self.networkErrorView = [[NMNetworkErrorView alloc] initWithFrame:errorWindow];
    self.networkErrorView.alpha = 0.75;
    self.networkErrorView.backgroundColor = [UIColor blackColor];
    [self.navigationController.view.window addSubview:self.networkErrorView];
    [self.networkErrorView setHidden:YES];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshInvoked:forState:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.networkActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.networkActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.networkActivityIndicator];
    [self navigationItem].rightBarButtonItem = barButton;
    
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
        [self.refreshControl endRefreshing];
        [self.networkActivityIndicator stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed to load movies data from Rotten Tomatoes: %@", error.description);
        [self.networkErrorView setHidden:NO];
        [self.refreshControl endRefreshing];
        [self.networkActivityIndicator stopAnimating];
    }];
    
    [operation start];
}

-(void) refreshInvoked:(id)sender forState:(UIControlState)state {
    [self refresh];
}

- (void)refresh {
    NSString *url;
    
    [self.networkActivityIndicator startAnimating];
    
    if (self.controllerType == 0) {
        url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=dqghrug2e4mwtn4jv2hyecsy";
    }
    else {
        url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=dqghrug2e4mwtn4jv2hyecsy";
    }
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
    [movieCell.titleLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:17.0]];
    
    movieCell.synopsisLabel.text = movie.synopsis;
    [movieCell.synopsisLabel setFont:[UIFont fontWithName:@"Avenir-Book" size:15.0]];
    

    NSURL *url = [NSURL URLWithString:movie.mediumPosterURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [movieCell.posterImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        movieCell.posterImageView.alpha = 0.0;
        movieCell.posterImageView.image = image;
        [UIView animateWithDuration:0.25
                         animations:^{
                             movieCell.posterImageView.alpha = 1.0;
                         }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load profile poster image.");
    }];
    
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
