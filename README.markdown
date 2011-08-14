# MoreArty

This is a cleaned-up version of Apple's [Moriarity][1] sample code, which illustrates how to use NSTask.

The TaskWrapper class and its associated TaskWrapperDelegate protocol are completely reusable. You can simply copy them to your project.

The main changes:

* I replaced the obsolete pbproj project file with an xcodeproj file.
* I used delegate terminology and signatures for methods that are properly delegate methods.
* Variables that were declared as `id ` now use explicit types.
* You can specify environment variables you want the task to run with.
* I edited the comments heavily and moved the boilerplate legalese into a separate file.
* I applied my personal coding style consistently (tabs, ivars with underscores, brackets on their own line).
* Source files now use Unix line endings instead of Classic Mac line endings, which mess up diffs in git.

As sample projects go, MoreArty is still about as simple (and limited) as Moriarity. You can find more sophisticated NSTask wrappers if you look around.

[1]: http://developer.apple.com/library/mac/#samplecode/Moriarity/Introduction/Intro.html