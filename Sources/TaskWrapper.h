// Based on Apple's "Moriarity" sample code at
// <http://developer.apple.com/library/mac/#samplecode/Moriarity/Introduction/Intro.html>
// See the accompanying LICENSE.txt for Apple's original terms of use.

#import <Foundation/Foundation.h>

@protocol TaskWrapperDelegate;

/*! A generalized process handling class that makes asynchronous interaction with an NSTask easier.  There is also a delegate protocol designed to work in conjunction with the TaskWrapper class; your delegate should conform to this protocol.  TaskWrapper objects are one-shot (since NSTask is one-shot); if you need to run a task more than once, destroy/create new TaskWrapper objects. */
@interface TaskWrapper : NSObject {
	NSTask 			*task;
	id				<TaskWrapperDelegate>taskDelegate;
	NSString		*commandPath;
	NSArray			*arguments;
}

// This is the designated initializer - pass in your delegate and any task arguments.
// The first argument should be the path to the executable to launch with the NSTask.
- (id)initWithCommandPath:(NSString *)commandPath
				arguments:(NSArray *)args
				 delegate:(id <TaskWrapperDelegate>)aDelegate;

// This method launches the process, setting up asynchronous feedback notifications.
- (void)startTask;

// This method stops the process, stoping asynchronous feedback notifications.
- (void)stopTask;

@end


@protocol TaskWrapperDelegate
@optional

// This method is a callback which your delegate can use to do other initialization when a process
// is launched.
- (void)taskWrapperWillStartTask:(TaskWrapper *)taskWrapper;

// Your delegate's implementation of this method will be called when output arrives from the NSTask.
// Output will come from both stdout and stderr, per the TaskWrapper implementation.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didProduceOutput:(NSString *)output;

// This method is a callback which your delegate can use to do other cleanup when a process
// is halted.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didFinishTaskWithStatus:(int)terminationStatus;

@end
