#! /usr/bin/perl

use strict;
use warnings;
use feature ':5.10';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Cell Renderer Example");
$window->set_position("mouse");
$window->set_default_size(250, 100);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $data = Gtk3::ListStore->new( 'Glib::Int', 'Glib::String', 'Glib::String' );
$data->set( $data->append, 0, 1, 1, 'First bit');
$data->set( $data->append, 0, 2, 1, 'second' );
$data->set( $data->append, 0, 3, 2, 'third' );
my $tree = Gtk3::TreeView->new($data);

my $spinner = Gtk3::CellRendererSpin->new;
$spinner->set_property( editable => TRUE );
my $adj = Gtk3::Adjustment->new( 0, 0, 100, 1, 10, 0 );
$spinner->set_property( adjustment => $adj );
$spinner->signal_connect( edited => \&on_amount_edited, $data );
my $col0 = Gtk3::TreeViewColumn->new_with_attributes( 'Number', $spinner, text => 0 );
$tree->append_column($col0);

my $col1 = Gtk3::TreeViewColumn->new_with_attributes( 'Text', Gtk3::CellRendererText->new, text => 1 );
$tree->append_column($col1);

my $ren_text = Gtk3::CellRendererText->new();
$ren_text->set_property('editable', TRUE);
$ren_text->signal_connect (edited => \&cell_edited, $data);
my $col2 = Gtk3::TreeViewColumn->new_with_attributes( 'Ed Text', $ren_text, text => 2 );
$tree->append_column($col2);

$window->add($tree);
$window->show_all;
Gtk3->main;

sub on_amount_edited {
    my ( $widget, $path, $value, $model ) = @_;
    my $path_str = Gtk3::TreePath->new($path);
    my $iter = $model->get_iter($path_str);
    $model->set( $iter, 0, int($value) );
}

sub cell_edited {
	my ($cell, $path, $value, $model) = @_;
	my $path_str = Gtk3::TreePath->new($path);
	my $iter = $model->get_iter($path_str);
	$model->set($iter, 2, $value);
}


