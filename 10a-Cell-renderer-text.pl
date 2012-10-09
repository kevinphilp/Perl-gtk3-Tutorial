#! /usr/bin/perl

use strict;
use warnings;
use diagnostics;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;
use Data::Dumper;

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Cell Renderer Example");
$window->set_position("mouse");
$window->set_default_size(250, 100);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $data = Gtk3::ListStore->new( 'Glib::Int', 'Glib::String' );

$data->set( $data->append, 0, 1, 1, 'First bit' );
$data->set( $data->append, 0, 2, 1, 'second' );
$data->set( $data->append, 0, 3, 1, 'third' );

my $tree = Gtk3::TreeView->new($data);

my $spinner = Gtk3::CellRendererSpin->new;
$spinner->signal_connect( edited => \&on_amount_edited, $data );
$spinner->set_property( editable => TRUE );

my $adj = Gtk3::Adjustment->new( 0, 0, 100, 1, 10, 0 );
$spinner->set_property( adjustment => $adj );

my $cs = Gtk3::TreeViewColumn->new_with_attributes( 'Amount', $spinner, text => 0 );
$tree->append_column($cs);

my $ct = Gtk3::TreeViewColumn->new_with_attributes( 'Numbers', Gtk3::CellRendererText->new, text => 1 );
$tree->append_column($ct);

$window->add($tree);

$window->show_all;
Gtk3->main;

sub on_amount_edited {
    my ( $widget, $path, $value, $store ) = @_;

    my $path_str = Gtk3::TreePath->new($path);
    my $iter = $store->get_iter($path_str);

    $store->set( $iter, 0, int($value) );
}


=head



        treeview = Gtk.TreeView(model=self.liststore)

        renderer_text = Gtk.CellRendererText()
        column_text = Gtk.TreeViewColumn("Text", renderer_text, text=0)
        treeview.append_column(column_text)

        renderer_editabletext = Gtk.CellRendererText()
        renderer_editabletext.set_property("editable", True)

        column_editabletext = Gtk.TreeViewColumn("Editable Text",
            renderer_editabletext, text=1)
        treeview.append_column(column_editabletext)

        renderer_editabletext.connect("edited", self.text_edited)

        self.add(treeview)

    def text_edited(self, widget, path, text):
        self.liststore[path][1] = text

win = CellRendererTextWindow()
win.connect("delete-event", Gtk.main_quit)
win.show_all()
Gtk.main()

=cut
