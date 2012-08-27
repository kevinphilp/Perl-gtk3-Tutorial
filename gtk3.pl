#! /usr/bin/perl

use strict;
use warnings;
use diagnostics;
use feature ':5.14';
use Gtk3 '-init';

use Glib qw/TRUE FALSE/;

# Some changes 

sub quit_function {
	say "Exiting Gtk3";
	Gtk3->main_quit;
	return FALSE;
}

my $window = Gtk3::Window->new;
$window->set_title("My Title");
$window->set_position("mouse");
$window->set_default_size(400, 50);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $button1 = Gtk3::Button->new("Quit");
$button1->signal_connect (clicked => \&quit_function);

my $button2 = Gtk3::Button->new("test2");
my $button3 = Gtk3::Button->new("test3");

my $hbox = Gtk3::Box->new("horizontal", 5);
$hbox->pack_start($button1, TRUE, TRUE, 0);
$hbox->pack_start($button2, TRUE, TRUE, 0);
$hbox->pack_start($button3, TRUE, TRUE, 0);

$window->add($hbox);


 
$window->show_all;
Gtk3->main;
