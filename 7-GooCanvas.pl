#! /usr/bin/perl

use strict;
use warnings;
use diagnostics;
use autodie;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;
use Goo::Canvas;


my $window = Gtk3::Window->new('toplevel');
$window->signal_connect('delete_event' => sub { Gtk3->main_quit; });
$window->set_default_size(640, 600);

my $swin = Gtk3::ScrolledWindow->new;
$swin->set_shadow_type('in');
$window->add($swin);

=head
my $canvas = Goo::Canvas->new();

$canvas->set_size_request(600, 450);
$canvas->set_bounds(0, 0, 1000, 1000);
$swin->add($canvas);

my $root = $canvas->get_root_item();
my $rect = Goo::Canvas::Rect->new(
    $root, 100, 100, 400, 400,
    'line-width' => 10,
    'radius-x' => 20,
    'radius-y' => 10,
    'stroke-color' => 'yellow',
    'fill-color' => 'red'
);
#$rect->signal_connect('button-press-event', \&on_rect_button_press);

my $text = Goo::Canvas::Text->new($root, "Hello World", 300, 300, -1, 'center', 'font' => 'Sans 24', );
$text->rotate(45, 300, 300);
=cut

$window->show_all();
Gtk3->main;

#sub on_rect_button_press {
#    print "Rect item pressed!\n";
#    return TRUE;
#}
