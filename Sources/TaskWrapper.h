// Based on Apple's "Moriarity" sample code at// <http://developer.apple.com/library/mac/#samplecode/Moriarity/Introduction/Intro.html>// See the accompanying LICENSE.txt for Apple's original terms of use.#import <Foundation/Foundation.h>@protocol TaskWrapperController// Your controller's implementation of this method will be called when output arrives from the NSTask.// Output will come from both stdout and stderr, per the TaskWrapper implementation.- (void)appendOutput:(NSString *)output;// This method is a callback which your controller can use to do other initialization when a process// is launched.- (void)processStarted;// This method is a callback which your controller can use to do other cleanup when a process// is halted.- (void)processFinished;@end/*! A generalized process handling class that makes asynchronous interaction with an NSTask easier.  There is also a protocol designed to work in conjunction with the TaskWrapper class; your process controller should conform to this protocol.  TaskWrapper objects are one-shot (since NSTask is one-shot); if you need to run a task more than once, destroy/create new TaskWrapper objects. */@interface TaskWrapper : NSObject {	NSTask 			*task;	id				<TaskWrapperController>controller;	NSArray			*arguments;}// This is the designated initializer - pass in your controller and any task arguments.// The first argument should be the path to the executable to launch with the NSTask.- (id)initWithController:(id <TaskWrapperController>)controller arguments:(NSArray *)args;// This method launches the process, setting up asynchronous feedback notifications.- (void) startProcess;// This method stops the process, stoping asynchronous feedback notifications.- (void) stopProcess;@end