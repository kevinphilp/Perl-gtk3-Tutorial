#! /usr/bin/perl

use strict;
use warnings;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;
use Cairo::GObject;

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Grid Example");
$window->set_position("mouse");
$window->set_default_size(600, 400);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $drawable = Gtk3::DrawingArea->new;
$drawable->signal_connect( draw => \&cairo_draw );

$window->add($drawable);
$window->show_all;

my $timer = Glib::Timeout->add( 500, \&update );

Gtk3->main;

sub update {
	$drawable->queue_draw;
	return TRUE;
}

sub cairo_draw {
		my ( $widget, $context ) = @_;
		my $alloc = $widget->get_allocation;
		$context->move_to( rand( $alloc->{'width'} ), rand( $alloc->{'height'} ) );
		$context->rel_line_to( 10, 10 );
		$context->stroke;
		say "updated...";
		return FALSE;
}
