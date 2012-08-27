#! /usr/bin/perl

use strict;
use warnings;
use diagnostics;
use feature ':5.14';
use Gtk3 '-init';

my $window = Gtk3::Window->new('toplevel');
$window->show_all;
Gtk3->main;

