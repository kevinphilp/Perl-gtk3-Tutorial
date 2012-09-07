#! /usr/bin/perl

use strict;
use warnings;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;
use Cairo::GObject;
use Data::Dumper;

use constant PI 	=> 3.1415927;
use constant WIDTH 	=> 600;
use constant HEIGHT => 400;
use constant RADIUS	=> 20;

my %status = (
	vector 		=> { 'x' => 2, 'y' => 3 },
	position 	=> { 'x' => 20, 'y' => 30 },
);

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Cairo animation");
$window->set_position("mouse");
$window->set_default_size(WIDTH+10, HEIGHT+30);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $frame = Gtk3::Frame->new("Pong");
$window->add($frame);

my $drawable = Gtk3::DrawingArea->new;
$drawable->signal_connect( draw => \&cairo_draw, \%status );
$frame->add($drawable);

$window->show_all;

my $timer = Glib::Timeout->add( 20, \&update );

Gtk3->main;

sub update {
	$status{'position'}{'x'} += $status{'vector'}{'x'};
	$status{'position'}{'y'} += $status{'vector'}{'y'};
	if ( $status{'position'}{'y'} >= HEIGHT - RADIUS ) {
		$status{'vector'}{'y'} = -$status{'vector'}{'y'};
	}
	if ( $status{'position'}{'y'} <= RADIUS ) {
		$status{'vector'}{'y'} = -$status{'vector'}{'y'};
	}
	if ( $status{'position'}{'x'} >= WIDTH - RADIUS ) {
		$status{'vector'}{'x'} = -$status{'vector'}{'x'};
	}
	if ( $status{'position'}{'x'} <= RADIUS ) {
		$status{'vector'}{'x'} = -$status{'vector'}{'x'};
	}
	$drawable->queue_draw;
	return TRUE;
}

sub cairo_draw {
		my ( $widget, $context, $ref_status ) = @_;

		# Background
 		my $pattern2 = Cairo::LinearGradient->create( 0,  0, WIDTH ,  HEIGHT);
 		$pattern2->add_color_stop_rgba(0, 0.2, 0.7, 0.9, 0.7);
 		$pattern2->add_color_stop_rgba(1, 0.2, 0.7, 0.5, 0.7);
 		$context->set_source( $pattern2 );
 		$context->rectangle( 0,  0, WIDTH ,  HEIGHT);
 		$context->fill;

		# Ball
 		 my $pattern = Cairo::RadialGradient->create(
			$ref_status->{'position'}{'x'},
			$ref_status->{'position'}{'y'},
			RADIUS,
			$ref_status->{'position'}{'x'}-2,
			$ref_status->{'position'}{'y'}-2,
			RADIUS / 2
		);
 		$pattern->add_color_stop_rgb(0, 0.8, 0.6, 0.8);
 		$pattern->add_color_stop_rgb(1, 1, 0.7, 1);
 		$context->set_source( $pattern );
 		$context->arc(
			$ref_status->{'position'}{'x'},
			$ref_status->{'position'}{'y'},
			RADIUS,
			0,
			PI * 2,
		);
 		$context->fill;

		return FALSE;
}
