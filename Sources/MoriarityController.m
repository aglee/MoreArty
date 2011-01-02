// Based on Apple's "Moriarity" sample code at
// <http://developer.apple.com/library/mac/#samplecode/Moriarity/Introduction/Intro.html>
// See the accompanying LICENSE.txt for Apple's original terms of use.

#import "MoriarityController.h"

@implementation MoriarityController

// here we implement a cheesy check to determine if update.locatedb has been run on the current machine.
// a fresh Mac OS X install has a very small database file, that contains no useful information.
- (BOOL)ensureLocateDBExists
{
	NSDictionary *attr;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/db/locate.database"]==YES)
	{
		attr=[[NSFileManager defaultManager] fileAttributesAtPath:@"/var/db/locate.database" traverseLink:YES];
		if ([attr fileSize]>4096)//we pick some size that seems large enough that it couldn't be empty
			return YES;
		else
			return NO;
	}
	else
		return NO;
}

// This action kicks off a locate search task if we aren't already searching for something,
// or stops the current search if one is already running
- (IBAction)sleuth:(id)sender
{
	if (findRunning)
	{
		// This stops the task and calls our callback (-taskWrapper:didFinishTaskWithStatus:)
		[searchTask stopProcess];
		// Release the memory for this wrapper object
		[searchTask release];
		searchTask=nil;
		return;
	}
	else
	{
		// If the task is still sitting around from the last run, release it
		if (searchTask!=nil)
			[searchTask release];
		// Let's allocate memory for and initialize a new TaskWrapper object, passing
		// in ourselves as the delegate for this TaskWrapper object, the path
		// to the command-line tool, and the contents of the text field that 
		// displays what the user wants to search on
		searchTask=[[TaskWrapper alloc] initWithDelegate:self arguments:[NSArray arrayWithObjects:@"/usr/bin/locate",[findTextField stringValue],nil]];
		// kick off the process asynchronously
		[searchTask startProcess];
	}
}

// This callback is implemented as part of conforming to the TaskWrapperDelegate protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didProduceOutput:(NSString *)output
{
	// add the string (a chunk of the results from locate) to the NSTextView's
	// backing store, in the form of an attributed string
	[[resultsTextField textStorage] appendAttributedString: [[[NSAttributedString alloc]
															  initWithString: output] autorelease]];
	// setup a selector to be called the next time through the event loop to scroll
	// the view to the just pasted text.  We don't want to scroll right now,
	// because of a bug in Mac OS X version 10.1 that causes scrolling in the context
	// of a text storage update to starve the app of events
	[self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
}

// This routine is called after adding new results to the text view's backing store.
// We now need to scroll the NSScrollView in which the NSTextView sits to the part
// that we just added at the end
- (void)scrollToVisible:(id)ignore {
	[resultsTextField scrollRangeToVisible:NSMakeRange([[resultsTextField string] length], 0)];
}

// A callback that gets called when a TaskWrapper is launched, allowing us to do any setup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the TaskWrapperDelegate protocol.
- (void)taskWrapperDidStartTask:(TaskWrapper *)taskWrapper
{
	findRunning=YES;
	// clear the results
	[resultsTextField setString:@""];
	// change the "Sleuth" button to say "Stop"
	[sleuthButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the TaskWrapperDelegate protocol.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didFinishTaskWithStatus:(int)terminationStatus
{
	findRunning=NO;
	// change the button's title back for the next search
	[sleuthButton setTitle:@"Sleuth"];
}

// If the user closes the search window, let's just quit
-(BOOL)windowShouldClose:(id)sender
{
	[NSApp terminate:nil];
	return YES;
}

// Display the release notes, as chosen from the menu item in the Help menu.
- (IBAction)displayReleaseNotes:(id)sender
{
	// Grab the release notes from the Resources folder in the app bundle, and stuff 
	// them into the proper text field
	[relNotesTextField readRTFDFromFile:[[NSBundle mainBundle] pathForResource:@"ReadMe" ofType:@"rtf"]];
	[relNotesWin makeKeyAndOrderFront:self];
}

// when first launched, this routine is called when all objects are created
// and initialized.  It's a chance for us to set things up before the user gets
// control of the UI.
-(void)awakeFromNib
{
	findRunning=NO;
	searchTask=nil;
	// Lets make sure that there is something valid in the locate database; otherwise,
	// all searches will come back empty.
	if ([self ensureLocateDBExists]==NO)
	{
		// Explain to the user that they need to go update the database as root.
		// That is, if they want locate to be able to really find *any* file
		// on their hard drive (perhaps not great for security, but good for usability).
		NSRunAlertPanel(@"Error",@"Sorry, Moriarity's 'locate' database is missing or empty.  In a terminal, as root run '/usr/libexec/locate.updatedb' and try Moriarity again.", @"OK",NULL,NULL);
		[NSApp terminate:nil];
	}
}

@end
