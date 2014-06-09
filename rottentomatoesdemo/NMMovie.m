//
//  NMMovie.m
//  rottentomatoesdemo
//
//  Created by Nicolas Melo on 6/6/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "NMMovie.h"

@interface NMMovie()

@property (nonatomic, retain) NSMutableDictionary *rawData;

@end

@implementation NMMovie

- (id)initWithDictionary:(NSDictionary *)rawData {
    self = [super init];
    if (self) {
        
        self.rawData = [[NSMutableDictionary alloc] initWithDictionary:rawData];
        
    }
    return self;
}

- (NSString *)title {
    return self.rawData[@"title"];
}

- (NSString *)synopsis {
    return self.rawData[@"synopsis"];
}

- (NSString *)thumbnailPosterURL {
    return self.rawData[@"posters"][@"thumbnail"];
}

- (NSString *)smallPosterURL {
    return self.rawData[@"posters"][@"profile"];
}


- (NSString *)mediumPosterURL {
    return self.rawData[@"posters"][@"detailed"];
}

- (NSString *)largePosterURL {
    return self.rawData[@"posters"][@"original"];
}

@end
