#!/bin/env tclsh

namespace eval ::selfrun {
    set VERSION 0.1; # 2022-06-25
    set debug 0;

    proc LogDebug {msg} {
        if {$::selfrun::debug} {
            puts [format {::selfrun::eval debug: %-18s {%s}} $msg [::selfrun::script]];
        };
    };

    proc dumpvars {} {
        puts {> ::selfrun::dumpvars:};
        puts [format {interactive = %s} $::tcl_interactive];
        puts [format {pwd         = %s} [pwd]];
        puts [format {script      = %s} [file normalize [info script]]];
        puts [format {argv0       = %s} [file normalize $::argv0]];
        puts [format {argc        = %s} $::argc];
        puts [format {argv        = %s} $::argv];
    };

    proc test { {check_interactive 0} } {
        if {$::selfrun::debug > 1} {[namespace current]::dumpvars};

        if {$check_interactive != 0 && $::tcl_interactive == 1} {return 0};
        if {$::argc > 0} {return 0};
        if {[file normalize [info script]] == [file normalize $::argv0]} {return 1};
        return 0;
    };

    proc eval {command1 {command2 {}}} {
        if {[::selfrun::test] == 1} {
            ::selfrun::LogDebug {START DIRECTLY};
            uplevel 1 $command1;
            ::selfrun::LogDebug {FINISH DIRECTLY};
        } elseif {$command2 ne {}} {
            ::selfrun::LogDebug {INDIRECTLY START};
            uplevel 1 $command2;
            ::selfrun::LogDebug {INDIRECTLY FINISH};
        };
    };

    proc appdir {} {
        set @ {Return directory, where script placed.};
        return [file dirname [file normalize $argv0]];
    };
    proc script {} {
        set @ {Return full path to script.};
        return [file normalize [info script]];
    };
    proc scriptdir {} {
        set @ {Return directory, where script placed.};
        return [file dirname [file normalize [info script]]];
    };
};

package provide selfrun $::selfrun::VERSION;

::selfrun::eval {
    # Example:
    puts "This string is printed only if the script runs directly by interpreter."
    puts [string repeat {-} 40];
    source example.tcl;
};
