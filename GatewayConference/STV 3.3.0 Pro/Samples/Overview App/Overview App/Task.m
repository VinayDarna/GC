//
//  Task.m
//  Overview App
//
//
//  Copyright (c) 2013 Sensible Cocoa. All rights reserved.
//

#import "Task.h"


@implementation Task

- (id)init
{
	self = [super init];
	if(!self)
        return nil;
    
	_steps = [[NSMutableArray alloc] initWithCapacity:1];
	TaskStep *step1 = [[TaskStep alloc] init];
	step1.title = @"Step placeholder";
	step1.description = @"Placeholder for a task step";
	[_steps addObject:step1];
	
	return self;
}


- (void)logTask
{
	NSLog(@"\n\nname:%@, description:%@, dueDate:%@, active:%i, priority:%i, categoryIndex:%i",
		  self.name, self.description, self.dueDate, self.active, self.priority, self.categoryIndex);
}

@end
