#!/bin/env tclsh

lappend ::auto_path [file dirname [file normalize [info script]]];

package require selfrun;

puts "# ::selfrun - Example 1 - ::selfrun::test";
if {[::selfrun::test]} {
    puts "This script runs directly.\nLet's do evaluate this part of code!";
} else {
    puts "This script loaded from other script.\nSo, no need to evaluate this part of code.";
}

puts "# ::selfrun - Example 2 - ::selfrun::eval:";
::selfrun::eval {
    puts "This string is printed because script runs directly.";
} {
    puts "This string is printed only if this script was loaded from another script.";
};
