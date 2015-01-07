//
//  JavascriptModel.m
//  JavascriptCore
//
//  Created by Leonardo Lee on 1/6/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "JavascriptModel.h"

@implementation JavascriptModel

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
        _age = 20;
    }
    return self;
}

@end
