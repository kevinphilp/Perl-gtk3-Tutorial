#! /usr/bin/perl

use strict;
use warnings;
use diagnostics;
use feature ':5.14';
use Gtk3 '-init';

use Glib qw/TRUE FALSE/;

sub quit_function {
	say "Exiting Gtk3";
	Gtk3->main_quit;
	return FALSE;
}

my $window = Gtk3::Window->new('toplevel');
$window->set_title("My Title");
$window->set_position("mouse");
$window->set_default_size(400, 50);
$window->set_border_width(20);
$window->signal_connect (delete_event => \&quit_function);

my $button1 = Gtk3::Button->new("Quit");
$button1->signal_connect (clicked => \&quit_function);

my $button2 = Gtk3::Button->new("Another Quit");
$button2->signal_connect (clicked => \&quit_function);

my $hbox = Gtk3::Box->new("horizontal", 5);

$hbox->pack_start($button1, TRUE, TRUE, 0);
$hbox->pack_start($button2, TRUE, TRUE, 0);

$hbox->set_homogeneous (TRUE);

$window->add($hbox);

$window->show_all;
Gtk3->main;
