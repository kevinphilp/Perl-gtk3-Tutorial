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
use constant RADIUS	=> 12;	

my %status = (
	vector 		=> { 'x' => 2, 'y' => 3 },
	position 	=> { 'x' => 20, 'y' => 30 },
	playerA		=> { 'y' => 50 },
	playerB		=> { 'y' => 50 }
);

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Grid Example");
$window->set_position("mouse");
$window->set_default_size(WIDTH +50, HEIGHT +100);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });
$window->signal_connect( key_press_event => \&keypress );

my $vbox = Gtk3::Box->new("vertical", 5);
$window->add($vbox);

my $hbox = Gtk3::Box->new("horizontal", 5);
$vbox->add($hbox);

my $toggle1 = Gtk3::ToggleButton->new_with_label('Text');
my $toggle2 = Gtk3::ToggleButton->new_with_label('Percent');
my $toggle3 = Gtk3::ToggleButton->new_with_label('Invert');
$hbox->pack_start($toggle1, TRUE, TRUE, 0);
$hbox->pack_start($toggle2, TRUE, TRUE, 0);
$hbox->pack_start($toggle3, TRUE, TRUE, 0);

my $frame = Gtk3::Frame->new("Pong");
$vbox->pack_start($frame, TRUE, TRUE, 5);

my $drawable = Gtk3::DrawingArea->new;
$drawable->signal_connect( draw => \&cairo_draw, \%status );
$frame->add($drawable);

$window->show_all;

my $timer = Glib::Timeout->add( 20, \&update );

Gtk3->main;

sub keypress {
	my ( $widget, $event ) = @_;

	given($event->key->{'string'}) {
    	when ('q') 		{ $status{'playerA'}{'y'} -= 3; }
		when ('a') 		{ $status{'playerA'}{'y'} += 3; }
		when ('p') 		{ $status{'playerB'}{'y'} -= 3; }
		when ('l') 		{ $status{'playerB'}{'y'} += 3; }
	}
	return FALSE;	
}

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
		$context->set_source_rgb(0.19, 0.69, 0);
		$context->rectangle(0, 0, WIDTH, HEIGHT);
		$context->fill;

		# Ball
		$context->set_source_rgb(0.69, 0.19, 0);
 		$context->arc(
 			$ref_status->{'position'}{'x'},
 			$ref_status->{'position'}{'y'},
 			RADIUS,
 			0,
 			PI * 2
 		);
 		$context->stroke_preserve;
 		$context->set_source_rgb(0.6, 0.4, 0.2); 
 		$context->fill;

 		# Paddle A
 		$context->set_source_rgb(0.0, 0.0, 0.7);
		$context->rectangle( 15, $ref_status->{'playerA'}{'y'}, 10, 30);
		$context->fill;

		# Paddle B
 		$context->set_source_rgb(0.0, 0.0, 0.7);
		$context->rectangle( WIDTH - 15, $ref_status->{'playerB'}{'y'}, 10, 30);
		$context->fill;
		
		return FALSE;
}
