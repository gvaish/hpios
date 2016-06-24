//
//  HPPhoto.h
//  HighPerformance
//
//  Created by Gaurav Vaish on 8/17/14.
//  Copyright (c) 2014 Gaurav Vaish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HPAlbum;

@interface HPPhoto : NSObject

@property (nonatomic, strong) HPAlbum *album;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *comments;

@end
