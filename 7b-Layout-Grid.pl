#! /usr/bin/perl

use strict;
use warnings;
use diagnostics;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Grid Example");
$window->set_position("mouse");
$window->set_default_size(250, 100);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $grid = Gtk3::Grid->new;
$window->add($grid);

my $toggle1 = Gtk3::ToggleButton->new_with_label('One');
my $toggle2 = Gtk3::ToggleButton->new_with_label('Two');
my $toggle3 = Gtk3::ToggleButton->new_with_label('Three');
my $toggle4 = Gtk3::ToggleButton->new_with_label('Four');
my $toggle5 = Gtk3::ToggleButton->new_with_label('Five');
my $toggle6 = Gtk3::ToggleButton->new_with_label('Six');

#attach (Widget child, gint32 left, gint32 top, gint32 width, gint32 height) : none
#void  gtk_grid_attach_next_to   (GtkGrid *grid, GtkWidget *child, GtkWidget *sibling, GtkPositionType side, gint width, gint height);

$grid->add($toggle1);
$grid->attach($toggle2, 1, 0, 2, 1);
$grid->attach_next_to($toggle3, $toggle1, "bottom", 1, 2);
$grid->attach_next_to($toggle4, $toggle3, "right", 2, 1);
$grid->attach($toggle5, 1, 2, 1, 1);
$grid->attach_next_to($toggle6, $toggle5, "right", 1, 1);

$window->show_all;
Gtk3->main;
