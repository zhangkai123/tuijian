//
//  TTTAttributedLabel+link.m
//  Tuijian
//
//  Created by zhang kai on 4/9/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "TTTAttributedLabel+link.h"

@implementation TTTAttributedLabel (link)

-(void)createNoLineLinkAttributes:(UIColor*)color{
    
    NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName,(id)kCTUnderlineStyleAttributeName
                     , nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:color,[NSNumber numberWithInt:kCTUnderlineStyleNone], nil];
    NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    self.linkAttributes = linkAttributes;
}

@end
