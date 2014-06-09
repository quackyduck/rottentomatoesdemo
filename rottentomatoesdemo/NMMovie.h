//
//  NMMovie.h
//  rottentomatoesdemo
//
//  Created by Nicolas Melo on 6/6/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMMovie : NSObject

@property (readonly, assign) NSString *title;
@property (readonly, assign) NSString *synopsis;

@property (readonly, assign) NSString *thumbnailPosterURL;
@property (readonly, assign) NSString *smallPosterURL;
@property (readonly, assign) NSString *largePosterURL;
@property (readonly, assign) NSString *mediumPosterURL;

@property (copy) UIImage *thumbnailPosterImage;
@property (copy) UIImage *smallPosterImage;
@property (copy) UIImage *mediumPosterImage;
@property (copy) UIImage *largePosterImage;


- (id)initWithDictionary:(NSDictionary *)rawData;

@end
