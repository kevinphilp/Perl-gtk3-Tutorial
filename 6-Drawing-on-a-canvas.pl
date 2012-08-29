#! /usr/bin/perl

use strict;
use warnings;
use diagnostics;
use feature ':5.14';

use Cairo::GObject;
use Gtk3 '-init';
use autodie;

my $window = Gtk3::Window->new('toplevel');
$window->signal_connect( 'destroy' => sub { Gtk3->main_quit } );

my $drawable = Gtk3::DrawingArea->new;

$drawable->signal_connect(
    'draw' => sub {
        my ( $widget, $context ) = @_;

        my $alloc = $widget->get_allocation;

        $context->move_to( rand( $alloc->{width} ), rand( $alloc->{height} ) );
        $context->rel_line_to( 10, 10 );
        $context->stroke;
        sleep (1);
        $context->line_to( 30, 10 );
        $context->stroke;
        sleep (1);
        $context->line_to( 10, 30 );
        $context->stroke;

    }
);

$window->add($drawable);
$window->show_all;

Gtk3->main;
