#! /usr/bin/perl

use strict;
use warnings;
use diagnostics;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;
use Data::Dumper;

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Switch Example");
$window->set_position("mouse");
$window->set_default_size(250, 100);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $vbox = Gtk3::Box->new("vertical", 5);
$window->add($vbox);

my $spinner = Gtk3::Spinner->new;
my $switch = Gtk3::Switch->new;
$switch->set_active( FALSE );

my $sep = Gtk3::Separator->new("horizontal");

$vbox->pack_start($spinner, TRUE, TRUE, 5 );
$vbox->pack_start($sep, FALSE, FALSE, 2 );
$vbox->pack_start($switch, TRUE, TRUE, 5 );

$switch->signal_connect( 'notify::active' => \&toggle );

$window->show_all;
Gtk3->main;

sub toggle {
	my ($widget, $data) = @_;
	say Dumper($data);
	if ( $widget->get_active == TRUE ) {
			$spinner->start;
	} else {
			$spinner->stop;
	}
	return FALSE;
}
