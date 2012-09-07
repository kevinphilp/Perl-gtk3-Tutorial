#!/usr/bin/perl

use strict;
use warnings;
use Gtk2 -init;
use Gtk2::Ex::Dialogs;
use Gtk2::Gdk::Keysyms;
use Glib ':constants';
#use Goo::Canvas;

use Inline C => Config => CCFLAGS => '-O3 -msse3 -mfpmath=sse -march=core2 -ffast-math';
use Inline C => 'DATA';

# setting up default sizes
my $xbox = 360;
my $ybox = 300;
my $boxsize = 2;

my $centerx = 0;

my $centery = 0;

my $wsize = 4;



my $pmax = $centerx + $wsize / 2;

my $pmin = $centerx - $wsize / 2;

my $qmax = $centery + $wsize / 2 * $ybox/$xbox;

my $qmin = $centery - $wsize / 2 * $ybox/$xbox;



my $A = ($pmax-$pmin)/$xbox;
my $C = ($qmax-$qmin)/$ybox;
#print "$pmax, $pmin, $qmax, $qmin, $A, $C\n";

my $kmax=100;

# setting up palette
my @palette = map	{
						pack("WWW",
							int(sqrt($_/$kmax)*256),
							int(($_/$kmax)**3*256),
							int(sin(3.14159*$_/$kmax)*256)
						)
					} (0..$kmax);
$palette[-1] = "\0\0\0";

# Create the main window
my $win = new Gtk2::Window ( "toplevel" );
$win->signal_connect ("delete_event", sub { Gtk2->main_quit; });
#$win->signal_connect ("configure_event", \&win_expose);
$win->set_title( "Julia set demo" );
$win->set_border_width (6);
#$win->maximize;
$win->set_resizable (0);
$win->resize(700, 500);

my $vbox = Gtk2::VBox->new (0, 6);
$win->add ($vbox);

my $da = Gtk2::DrawingArea->new;
$da->set_size_request($xbox*$boxsize, $ybox*$boxsize);
$vbox->pack_start($da, 1, 1, 0);
$da->signal_connect (motion_notify_event => \&on_background_motion_notify);
$da->set_events ([ @{ $da->get_events },
                         'leave-notify-mask',
                         'pointer-motion-mask',
                         'pointer-motion-hint-mask', ]);
#my $gc1 = Gtk2::Gdk::GC->new ($win);

$win->show_all;

main Gtk2;

# replotting on mouse movement
sub on_background_motion_notify {
	my ($da, $event) = @_;

	my (undef, $ex, $ey, $state) = $event->window->get_pointer;

	my $cy = $C*int(($ey)/$boxsize) + $qmin;
	my $cx = $A*int(($ex)/$boxsize) + $pmin;

	#print $ex," ,",$ey," ,$cx ,$cy";
	my $data = '';
	my $row = '';
	foreach my $q (0..$ybox-1) {
		foreach my $p (0..$xbox-1) {
			my $k = julia_iter($p, $q, $A, $C, $pmin, $qmin, $kmax, $cx, $cy);
			$row .= $palette[$k] x $boxsize;
		}
		$data .= $row x $boxsize;
		$row = '';
	}

	my $pixbuf = Gtk2::Gdk::Pixbuf->new_from_data (
		$data, 'rgb', FALSE, 8,
		$xbox*$boxsize,
		$ybox*$boxsize,
		3*$xbox*$boxsize
	);

	my $gc1 = Gtk2::Gdk::GC->new ($da->window);
	$da->window->draw_pixbuf($gc1, $pixbuf,  0, 0,
		0, 0, $xbox*$boxsize,
		$ybox*$boxsize,

		'none', 0, 0,
	);
	return TRUE;
}

__DATA__
__C__
int julia_iter (int p, int q, double A, double C, double pmin, double qmin, int kmax, double cx, double cy) {
	int k = 0;
	double x = A*p + pmin;
	double y = C*q + qmin;
	double x2 = x*x;
	double y2 = y*y;
	while (x2+y2<4 && k<kmax) {
		y=2*x*y+cy;
		x=x2-y2+cx;
		x2=x*x;
		y2=y*y;
		k++;
	}
	return k;
}
