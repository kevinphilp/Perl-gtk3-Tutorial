#! /usr/bin/perl

#
#	This example borrows from the
#	The Python GTK+ 3 Tutorial
#	http://python-gtk-3-tutorial.readthedocs.org/en/latest/index.html
#

use strict;
use warnings;
use diagnostics;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Basic Radio Boxes");
$window->set_position("mouse");
$window->set_default_size(200, 100);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $hbox = Gtk3::Box->new("horizontal", 5);
$window->add($hbox);

my $rbutton1 = Gtk3::RadioButton->new_with_label_from_widget(undef, "Button 1");
$hbox->pack_start($rbutton1, TRUE, TRUE, 0);
$rbutton1->signal_connect (toggled => \&rb_toggled, "rb1");

my $rbutton2 = Gtk3::RadioButton->new_with_label_from_widget($rbutton1, "Button 2");
$hbox->pack_start($rbutton2, TRUE, TRUE, 0);
$rbutton2->signal_connect (toggled => \&rb_toggled, "rb2");

my $rbutton3 = Gtk3::RadioButton->new_with_label_from_widget($rbutton1, "Button 3");
$hbox->pack_start($rbutton3, TRUE, TRUE, 0);
$rbutton3->signal_connect (toggled => \&rb_toggled, "rb3");

$window->show_all;
Gtk3->main;

sub rb_toggled {
	my ($widget, $data) = @_;
	print "Radio button $data is now ";
	if ($widget->get_active == TRUE) {
		say " set ON";
	} else {
		say " set OFF";
	}
}

