#! /usr/bin/perl

use strict;
use warnings;
use diagnostics;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Progress Bar");
$window->set_position("mouse");
$window->set_default_size(250, 100);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $vbox = Gtk3::Box->new("vertical", 5);
$window->add($vbox);

my $progress = Gtk3::ProgressBar->new;
$progress->set_orientation("horizontal");
$progress->set_inverted(FALSE);
$progress->set_text(undef);
$progress->set_show_text(FALSE);
$vbox->add($progress);

my $hbox = Gtk3::Box->new("horizontal", 2);
$vbox->add($hbox);

my $toggle1 = Gtk3::ToggleButton->new_with_label('Text');
my $toggle2 = Gtk3::ToggleButton->new_with_label('Percent');
my $toggle3 = Gtk3::ToggleButton->new_with_label('Invert');
$hbox->pack_start($toggle1, TRUE, TRUE, 0);
$hbox->pack_start($toggle2, TRUE, TRUE, 0);
$hbox->pack_start($toggle3, TRUE, TRUE, 0);

$toggle1->signal_connect ( toggled => \&showtext );
$toggle2->signal_connect ( toggled => \&showpercent );
$toggle3->signal_connect ( toggled => \&invert );

my $increment = 0.01;
my $timer = Glib::Timeout->add (50, \&update);

$window->show_all;
Gtk3->main;

sub showtext {
	my ($widget, $data) = @_;
	my $text = undef;
	if ( $widget->get_active ) {
		$text = "some text";
	} 
	$progress->set_text( $text );
	$progress->set_show_text( $widget->get_active );
}

sub showpercent {
	my ($widget, $data) = @_;
	my $show = $widget->get_active;
	$progress->set_text( undef );
	$progress->set_show_text( $show );
}

sub invert {
	my ($widget, $data) = @_;
	$progress->set_inverted( $widget->get_active );
}
	
sub update {
	if ( $progress->get_fraction >= 1 ) {
		$increment = -0.01;
	}
	if ( $progress->get_fraction <= 0 ) {
		$increment = 0.01;
	}
	$progress->set_fraction( $progress->get_fraction + $increment );
	return TRUE;
}
