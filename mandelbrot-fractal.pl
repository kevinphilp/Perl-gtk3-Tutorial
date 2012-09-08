#! /usr/bin/perl

# Based on http://warp.povusers.org/Mandelbrot/

use strict;
use warnings;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;
use Cairo::GObject;
use Data::Dumper;

use constant LOOPS		=> 100;

use constant MAX_X		=> 800; # REAL
use constant MAX_Y		=> 800; # IMAG

use constant MIN_REAL	=> -2.0;  	# -2.0
use constant MIN_IMAG	=> -1.2;	# -1.2
use constant MAX_REAL	=>  1.0;		# 1.0
my $MAX_IMAG			= MIN_IMAG + (MAX_REAL - MIN_REAL) * (MAX_X / MAX_Y);
my $re_factor 			= (MAX_REAL - MIN_REAL) / (MAX_X - 1);
my $im_factor			= ($MAX_IMAG - MIN_IMAG) / (MAX_Y - 1);

my @farray = ();

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Mandelbrot Set");
$window->set_position("mouse");
$window->set_default_size(MAX_X + 50, MAX_Y + 100);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $vbox = Gtk3::Box->new("vertical", 1);
$window->add($vbox);

my $frame = Gtk3::Frame->new("Cairo Drawings");
$vbox->pack_start($frame, TRUE, TRUE, 0);

my $drawable = Gtk3::DrawingArea->new;
$drawable->signal_connect( draw => \&cairo_draw );
$frame->add($drawable);

my $surface = Cairo::ImageSurface->create ('argb32', MAX_X, MAX_Y);
my $cr = Cairo::Context->create ($surface);

fractal();
drawbuf();

$window->show_all;

Gtk3->main;

sub fractal {
	for (my $y = 0; $y <= MAX_Y; $y++ ) {
		my $c_im = $MAX_IMAG - $y * $im_factor;
		for (my $x = 0; $x <= MAX_X; $x++ ) {
			$farray[$x][$y]{'real'} = MIN_REAL + $x * $re_factor;
			$farray[$x][$y]{'imag'} = $c_im;
			my $z = calcz( $farray[$x][$y]{'real'}, $farray[$x][$y]{'imag'} );
			$farray[$x][$y]{'z'} = $z;
		}
	}
}

sub calcz {
	my ($c_re, $c_im) = @_;
	my $z_re = $c_re;
	my $z_im = $c_im;
	my $inside = TRUE;
	for (my $n=0; $n <= LOOPS; $n++) {
		my $z_re2 = ($z_re * $z_re);
		my $z_im2 = ($z_im * $z_im);
		if ( ($z_re2 + $z_im2) > 4 ) {
			return $n;
		}
		$z_im = 2 * $z_re * $z_im + $c_im;
		$z_re = $z_re2 - $z_im2 + $c_re;
	}
	return 0;
}

sub drawbuf {
	$cr->set_line_width(1);
	for (my $y = 0; $y <= MAX_Y; $y++ ) {
		for (my $x = 0; $x <= MAX_X; $x++ ) {
			$cr->set_source_rgb( $farray[$x][$y]{'z'} / LOOPS, 0, 0 );
			$cr->rectangle( $x, $y, 1, 1);
			$cr->stroke;
		}
	}
}

sub cairo_draw {
		my ( $widget, $context, $ref_status ) = @_;
		$context->set_source_surface($surface, 0, 0);
		$context->paint;
		return FALSE;
}
