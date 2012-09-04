#! /usr/bin/perl

#
#	This example borrows very heavily from the
#	The Python GTK+ 3 Tutorial
#	http://python-gtk-3-tutorial.readthedocs.org/en/latest/index.html
#

use strict;
use warnings;
use diagnostics;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Basic Check Boxes");
$window->set_position("mouse");
$window->set_default_size(200, 100);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $vbox = Gtk3::Box->new("vertical", 5);
$window->add($vbox);

my $entry = Gtk3::Entry->new;
$entry->set_text("Hello World");
$vbox->pack_start($entry, TRUE, TRUE, 0);

my $hbox = Gtk3::Box->new("horizontal", 6);
$vbox->pack_start($hbox, TRUE, TRUE, 0);

my $check_button1 = Gtk3::CheckButton->new_with_label('Editable');
$check_button1->signal_connect (toggled => \&cb_toggled, "editable");
$check_button1->set_active(TRUE);
$hbox->pack_start($check_button1, TRUE, TRUE, 0);

my $check_button2 = Gtk3::CheckButton->new_with_label("Visible");
$check_button2->signal_connect (toggled => \&cb_toggled, "visible");
$check_button2->set_active(TRUE);
$hbox->pack_start($check_button2, TRUE, TRUE, 0);

my $check_button3 = Gtk3::CheckButton->new_with_label("Icon");
$check_button3->signal_connect (toggled => \&cb_toggled, "icon");
$check_button3->set_active(FALSE);
$hbox->pack_start($check_button3, TRUE, TRUE, 0);

$window->show_all;
Gtk3->main;

sub cb_toggled {
	my ($widget, $data) = @_;
	my $value = $widget->get_active;

	if ($data eq 'visible') {
        $entry->set_visibility($value);
	} elsif ($data eq 'editable') {
		$entry->set_editable($value);
	} elsif ($data eq 'icon') {
		my $stock_id = undef;
		if ($value == TRUE) {
			$stock_id = Gtk3::STOCK_FIND;
		}
		$entry->set_icon_from_stock('secondary', $stock_id);
	}
	return FALSE;
}
