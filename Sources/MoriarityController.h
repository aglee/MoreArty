// Based on Apple's "Moriarity" sample code at
// <http://developer.apple.com/library/mac/#samplecode/Moriarity/Introduction/Intro.html>
// See the accompanying LICENSE.txt for Apple's original terms of use.

#import <Cocoa/Cocoa.h>
#import "TaskWrapper.h"

/*! Controller class that operates as the go-between for the view (the UI) and the model (the locate database).  The point of this code is to show how you can wrap a UNIX task in a nice Cocoa GUI, and get back the output (which you could then operate on or parse further if you choose). */
@interface MoriarityController : NSObject <TaskWrapperController>
{
	IBOutlet id findTextField;
	IBOutlet id resultsTextField;
	IBOutlet id window;
	IBOutlet id relNotesWin;
	IBOutlet id relNotesTextField;
	IBOutlet NSButton *sleuthButton;
	BOOL findRunning;
	TaskWrapper *searchTask;
}
- (IBAction)sleuth:(id)sender; // the action that gets executed when the button is pushed
- (IBAction)displayReleaseNotes:(id)sender; // powers our addition to the help menu
- (BOOL)ensureLocateDBExists; // uses a heuristic to make sure we're up to date
@end
