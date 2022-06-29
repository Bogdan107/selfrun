# selfrun
This is a library for [Tcl](https://tcl.tk/) language.

Library allows to run a part of code, depending on how the script is runs: directly from interpreter, or indirectly - when script is loaded from another script.

This is need to quickly test the currently edited file without needs to start it by the main application.
With this library, I can edit the script and can test behaviour of changes directly from IDE.

Many scripts are the part of big project.
To use functionality of those scripts, main project script must be called.
But if I need to make changes into some part of this script and quick test this new version of script without needs to load the main project, then I just use command `::selfrun::eval { <some code> };`.
So, main application loads this script without calls the commands, which placed inside the braces of "::selfrun::eval" command.
But if this script loads directly by interpreter - then code inside the braces will be executed and I can to see some result.

This library is like [tcltest](https://wiki.tcl-lang.org/page/tcltest), but allows to puts test-code directly into the file with code, not into the separate file.

## Which problem this script resolve

I open Geany editor and edit code of some library:
```
namespace eval ::some_namespace {
  proc proc1 {args} {
    <some code>
  };
};
package provide some_library 0.1;
```

I want to test this code directly by pressing key sequence F8, which starts this code in the console in the bottom of the Geany.

But this call has no helpful effect - no beneficial commands in the code.
Geany just report "Build process finished successful" and no other lines in the console.

Normal behaviour to test this code - is to call it from another script.
So, I need to write separate file to test this library, like this.
```
lappend ::auto_path {<some path to tested library>}
package require some_library;
<some code to test the library "some_library">
```

But in this case I need:
- synchronize path of the library, path of the file of test-script and value of `::auto_path` variable in the file of test-script;
- switch between tabs in the Geany or switch window between Geany and separate console, which used to quick run the test-script.

This steps waste my time.
This is mechanical procedures and must to be avoided.

Another way - to place some test commands, at the end of the library script, into the braces, like this sequence:
```
<code of the library "some_library">

if {[info script] == $::argv0} {
  <some code to test the library "some_library">
};
```

But this sequence construction (inside the if{} operator) is correct only for most cases, but not correct for all cases.
So, correct line of sequence for universal usage must have more test sequences, must be longer, than the some number of words.

And if I in the active development process and change many files simultaneously, then I just copy and paste this sequence from other files, not write it from memory.
In this case:
- I don't use my brain as a high-level human instrument;
- my brain functioning as a primitive machine to rule the hands for copy-paste process;
- I don't feel the coding process;
- I need to remember, which files has correct test-sequence for self-test part;
- I need to waste time to find this file in the file system and copy a part of code from this file.

This library allows to write test-code into the file of the script by typing what human think, without needs to remember all nuances of this code:
```
<code of the library "some_library">

package require selfrun;
  ::selfrun::eval {
  <some code to test the library "some_library">
}
```

With this code, I can quick write self-test code into the file of the library an quick run this script in Geany.
