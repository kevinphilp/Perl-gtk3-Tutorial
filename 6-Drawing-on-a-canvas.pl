#!/usr/bin/env perl
use warnings;
<<<<<<< HEAD
use diagnostics;
use feature ':5.14';

use Cairo::GObject;
use Gtk3 '-init';
use autodie;
=======
use strict;
use Cairo::GObject;
use Gtk3 '-init';
>>>>>>> origin/master

my $window = Gtk3::Window->new('toplevel');
$window->signal_connect( 'destroy' => sub { Gtk3->main_quit } );

my $drawable = Gtk3::DrawingArea->new;

$drawable->signal_connect(
    'draw' => sub {
        my ( $widget, $context ) = @_;

        my $alloc = $widget->get_allocation;

        $context->move_to( rand( $alloc->{width} ), rand( $alloc->{height} ) );
<<<<<<< HEAD
        $context->rel_line_to( 10, 10 );
        $context->stroke;
        sleep (1);
        $context->line_to( 30, 10 );
        $context->stroke;
        sleep (1);
        $context->line_to( 10, 30 );
        $context->stroke;

=======
        $context->rel_line_to( 30, 30 );
        $context->rel_line_to( 30, 30 );
        $context->stroke;

        $context->set_source_rgb(0.69, 0.19, 0);
 		$context->arc(10, 10, 50, 45, 90);
 		$context->stroke_preserve;

 		$context->set_source_rgb (1, 0, 0);
		$context->fill;
>>>>>>> origin/master
    }
);

$window->add($drawable);
$window->show_all;

<<<<<<< HEAD
=======
$drawable->queue_draw;

>>>>>>> origin/master
Gtk3->main;

=cut
