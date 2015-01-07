//
//  JavascriptCoreExample.m
//  JavascriptCore
//
//  Created by Leonardo Lee on 1/6/15.
//  Copyright (c) 2015 Leonardo Lee. All rights reserved.
//
/*
 http://www.bignerdranch.com/blog/javascriptcore-and-ios-7/
 http://www.bignerdranch.com/blog/javascriptcore-example/
 */

#import "JavascriptCoreExample.h"
#import "JavascriptModel.h"

@interface JavascriptCoreExample ()

@end

@implementation JavascriptCoreExample

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self javascriptCoreBasics];
//    [self javascriptCoreMethods];
//    [self javascriptCoreMethodsObjCBlock];
    [self javascriptCoreModel];
    
}

- (void)javascriptCoreBasics
{
    JSVirtualMachine *jvm = [[JSVirtualMachine alloc] init];
    JSContext *context = [[JSContext alloc] initWithVirtualMachine:jvm];
    context[@"a"] = @5; // equivalent to var a = 5;
    NSLog(@"Should be 5... %@", context[@"a"]);
    
    //This exposes a JSContext global variable to Objective C.
    JSValue *varA = context[@"a"];
    double da = [varA toDouble];
    NSLog(@"Should be 5... %.0f", da);
    
    //This is how one invokes Javascript on the JSContext.
    [context evaluateScript:@"a = 10"];
    NSLog(@"Should be 10... %@", context[@"a"]);
    
    //JSValues are copied as there's a
    double da2 = [varA toDouble];
    NSLog(@"Should be 5... %.0f", da2);
    
    //Thus to grab the new value, one needs to reassign.
    varA = context[@"a"];
    da2 = [varA toDouble];
    NSLog(@"Should be 10... %.0f", da2);
}

-(void)javascriptCoreMethods
{
    JSVirtualMachine *jvm = [[JSVirtualMachine alloc] init];
    JSContext *context = [[JSContext alloc] initWithVirtualMachine:jvm];
    
    //Simple script
    [context evaluateScript:@"var square = function (x) { return x*x; }"];
    JSValue *squareFunction = context[@"square"];
    NSLog(@"This is a function named square: %@", squareFunction);
    
    //Using the script
    JSValue *nineSquared = [squareFunction callWithArguments:@[@9]];
    NSLog(@"This is equivalent to javascript console command — square(9): %@", nineSquared);
    
}

-(void)javascriptCoreMethodsObjCBlock
{
    JSVirtualMachine *jvm = [[JSVirtualMachine alloc] init];
    JSContext *context = [[JSContext alloc] initWithVirtualMachine:jvm];
    
    //Creating a JS method via block.
    context[@"factorial"] = ^(int x) {
        int factorial = 1;
        for (; x > 1; x--) {
            factorial *= x;
        }
        return factorial;
    };
    NSLog(@"Factorial function: %@", context[@"factorial"]);
    
    [context evaluateScript:@"var fiveFactorial = factorial(5);"];
    JSValue *fiveFactorial = context[@"fiveFactorial"];
    NSLog(@"factorial(5): %@", fiveFactorial);
    
}

-(void)javascriptCoreModel
{
    JSVirtualMachine *jvm = [[JSVirtualMachine alloc] init];
    JSContext *context = [[JSContext alloc] initWithVirtualMachine:jvm];
    
    //Init
    JavascriptModel *foo = [[JavascriptModel alloc] initWithName:@"Foo"];
    
    //Assignment
    foo.name = @"Bar";
    context[@"TheFoo"] = foo;
    
    //Expose to ObjC
    JSValue *jsFoo = context[@"TheFoo"];
    
    NSLog(@"JSModel: %@ and age: %ld", foo.name, (long)foo.age);
    NSLog(@"JSValue: %@ and age: %@", jsFoo[@"name"], jsFoo[@"age"]);
    
    
    //Attempting to reassign
    foo.name = @"Bar2";
    foo.age = 14;
    jsFoo = context[@"TheFoo"];
    NSLog(@"JSModel: %@ and age: %ld", foo.name, (long)foo.age);
    NSLog(@"JSValue: %@ and age: %@", jsFoo[@"name"], jsFoo[@"age"]);
    
    
    //Since age is not exposed to the JSExport Protocol, age shouldn't change...
    [context evaluateScript:@"TheFoo.name = \"Bar3\"; TheFoo.age = 30;"];
    NSLog(@"JSValue: %@ and age: %@", jsFoo[@"name"], jsFoo[@"age"]);
    
    //How to add to the global copy, so that you can call it in Javascript.
    //Do this instead of adding to the ObjectiveC object as that would require an additional property.
    [context evaluateScript:@"TheFoo.loadedMethod = function() { return TheFoo.name; }"];
    [context evaluateScript:@"var grabbedName = TheFoo.loadedMethod();"];
    JSValue *grabbedName = context[@"grabbedName"];
    NSLog(@"Running Correct Loaded Method: %@", grabbedName);
    
    //Avoid doing this below:
    //Deceptive, you can add to the local copy of the context...
    jsFoo[@"loadedMethod"] = @"function() { return TheFoo.name; }";
    NSLog(@"Loaded Method: %@", jsFoo[@"loadedMethod"]); //Exists in JSFoo, not in the context.
    [context evaluateScript:@"var attempt = TheFoo.loadedMethod();"];
    JSValue *attempt = context[@"attempt"];
    NSLog(@"Attempt from global: %@", attempt);
    
}

@end
