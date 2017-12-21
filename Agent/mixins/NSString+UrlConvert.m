//
//  NSString+UrlConvert.m
//  Agent
//
//  Created by admin on 2017/12/21.
//  Copyright © 2017年 xianlai. All rights reserved.
//

#import "NSString+UrlConvert.h"

@implementation NSString (UrlConvert)

- (NSString *)convertToHttps {
    if ([self hasPrefix:@"http://"]) {
        NSArray *urls = [self componentsSeparatedByString:@"http://"];
        NSString *newUrl = [@"https://" stringByAppendingString:urls[1]];
        return newUrl;
    }
    return self;
}

@end
