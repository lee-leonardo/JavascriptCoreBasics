//
//  JavascriptModel.h
//  JavascriptCore
//
//  Created by Leonardo Lee on 1/6/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

//Exposes properties and methods in the protocol to a Javascript version of the object.
@protocol ExportedObject <JSExport>

@property (nonatomic, strong) NSString *name;

@end

@interface JavascriptModel : NSObject <ExportedObject>

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger age;

- (instancetype)initWithName:(NSString *)name;

@end
