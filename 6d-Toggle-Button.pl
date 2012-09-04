#! /usr/bin/perl

use strict;
use warnings;
use diagnostics;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Spin and toggle Example");
$window->set_position("mouse");
$window->set_default_size(250, 100);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $vbox = Gtk3::Box->new("vertical", 5);
$window->add($vbox);

my $adjust = Gtk3::Adjustment->new(5, 0, 10, 1, 10, 0);
my $spin = Gtk3::SpinButton->new($adjust, 1, 1);
$vbox->pack_start($spin, FALSE, FALSE, 0);

my $hbox = Gtk3::Box->new("horizontal", 5);
$vbox->pack_start($hbox, FALSE, FALSE, 0);

my $zero_button = Gtk3::Button->new('Zero');
$hbox->pack_start($zero_button, FALSE, FALSE, 0);
$zero_button->signal_connect ( clicked => \&zero );

my $toggle_accuracy = Gtk3::ToggleButton->new_with_label('High accuracy');
$hbox->pack_start($toggle_accuracy, FALSE, FALSE, 0);
$toggle_accuracy->signal_connect ( toggled => \&toggle_accuracy );

my $hbox2 = Gtk3::Box->new("horizontal", 5);
$vbox->pack_start($hbox2, FALSE, FALSE, 0);

my $update_button = Gtk3::Button->new('Update');
$hbox->pack_start($update_button, FALSE, FALSE, 0);
$update_button->signal_connect ( clicked => \&update );

my $label = Gtk3::Label->new("No Value");
$hbox->pack_start($label, FALSE, FALSE, 0);

$window->show_all;
Gtk3->main;

sub zero {
	my ($widget, $data) = @_;
    $spin->set_value(0);
	return FALSE;
}

sub toggle_accuracy{
	my ($widget, $data) = @_;
    my $value = $widget->get_active;
    if ( $value == TRUE ) {
            $spin->set_digits(2);
    } else {
            $spin->set_digits(1);
    }
	return FALSE;
}

sub update {
	$label->set_label( $spin->get_value );
	return FALSE;
}
