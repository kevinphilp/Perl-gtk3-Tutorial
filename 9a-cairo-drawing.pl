#! /usr/bin/perl

use strict;
use warnings;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;
use Cairo::GObject;

use constant PI 	=> 3.1415927;

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Grid Example");
$window->set_position("mouse");
$window->set_default_size(600, 400);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $frame = Gtk3::Frame->new("Cairo Drawings");
$window->add($frame);

my $drawable = Gtk3::DrawingArea->new;
$drawable->signal_connect( draw => \&cairo_draw );
$frame->add($drawable);

$window->show_all;

Gtk3->main;

sub cairo_draw {
		my ( $widget, $context, $ref_status ) = @_;

		# Background
		$context->set_source_rgb(0.9, 0.9, 0.7);
		$context->paint;

 		# Solid box
 		$context->set_source_rgb(0.6, 0.0, 0.0);
 		$context->set_line_width(10);
		$context->rectangle( 5, 5, 160, 130);
		$context->stroke;

		# Transparent Rectangle
 		$context->set_source_rgba(0.0, 0.7, 0.0, 0.5);
 		$context->set_line_width(10);
		$context->rectangle( 85, 85, 160, 230);
		$context->fill;

		# Circle with border - transparent
		$context->set_source_rgba(0.0, 0.0, 0.9, 0.5);
 		$context->arc( 220, 150, 100, 0, PI * 2	);
 		$context->set_line_width(10);
 		$context->stroke_preserve;
 		$context->set_source_rgba(0.9, 0.2, 0.2, 0.2); 
 		$context->fill;

 		# Segment
		$context->set_source_rgba(0.9, 0.2, 0.2, 0.4);
		$context->set_line_width(2);
 		$context->arc( 400, 200, 100, 0, 5);
 		$context->stroke_preserve;
 		$context->line_to(400, 200);
 		$context->stroke_preserve;
 		$context->close_path;
 		$context->stroke_preserve;
 		$context->set_source_rgba(0.1, 0.4, 0.4, 0.4);
 		$context->fill;

 		# Arc
		$context->set_source_rgba(0.1, 0.1, 0.1, 0.8);
		$context->set_line_width(2);
 		$context->arc( 450, 220, 100, 0, 5);
 		$context->stroke;

		# Line
		$context->set_source_rgba(0, 0, 0, 0.5);
		$context->set_line_width(30);
		$context->move_to(50, 50);
 		$context->line_to(550, 350);
 		$context->stroke;
 		
		# Curve
		$context->set_line_width(10);
		$context->set_source_rgba(0.9, 0.9, 0, 0.9);		
 		$context->move_to(50, 50);
 		$context->curve_to( 100, 250, 250, 150, 550, 350);
 		$context->stroke;

		# Text
		$context->set_source_rgba(0.0, 0.9, 0.9, 0.7);		
 		$context->select_font_face( "Sans", "normal", "bold" );
 		$context->set_font_size( 50 );
 		$context->move_to(220, 50);
 		$context->show_text( "Ooooooh");
 		$context->stroke;

 		$context->move_to(370, 170);
 		$context->text_path( "pretty" );
		$context->set_source_rgba(0.9, 0, 0.9, 0.7);
		$context->fill_preserve;
		$context->set_source_rgba(0.2, 0.1, 0.1, 0.7);			
 		$context->set_line_width( 2 );
 		$context->stroke;

 		# Gradients
 		my $pattern = Cairo::RadialGradient->create(40, 220, 25, 60, 240, 150);
 		$pattern->add_color_stop_rgba(0, 1, 0.7, 1, 0.95);
 		$pattern->add_color_stop_rgba(1, 0, 0, 0.5, 0.95);
 		$context->set_source( $pattern );
 		$context->arc( 80, 250, 80, 0, PI * 2	);
 		$context->fill;

		return FALSE;
}
