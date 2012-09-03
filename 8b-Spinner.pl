#! /usr/bin/perl

use strict;
use warnings;
use diagnostics;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Spinner Example");
$window->set_position("mouse");
$window->set_default_size(250, 100);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $vbox = Gtk3::Box->new("vertical", 5);
$window->add($vbox);

my $spinner = Gtk3::Spinner->new;
my $toggle1 = Gtk3::ToggleButton->new_with_label('Spin');
$toggle1->set_active( FALSE );

$vbox->pack_start($spinner, TRUE, TRUE, 5 );
$vbox->pack_start($toggle1, TRUE, TRUE, 5 );

$toggle1->signal_connect ( toggled => \&toggle );

$window->show_all;
Gtk3->main;

sub toggle {
	my ($widget, $data) = @_;
	if ( $widget->get_active == TRUE ) {
			$spinner->start;
			$toggle1->set_label("Stop");
	} else {
			$spinner->stop;
			$toggle1->set_label("Spin");
	}
}
