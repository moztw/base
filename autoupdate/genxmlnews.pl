#!/usr/bin/perl

# moztw.org news html -> rdf generator
# Author: Hung-Te Lin <piaip@csie.ntu.edu.tw>

use strict;

my $fnLatest = '/home/moztw/htdocs/inc/news.html';
my $fnAll = '/home/moztw/htdocs/news/index.shtml';
my $maxEntries = 10;

my $HTTP_HEADER=<<HERE;
Content-Type: text/xml; charset=UTF-8

HERE

my $RDF_HEADER=<<HERE;
<?xml version="1.0" encoding="utf-8" ?>
<rss version="0.92">
<channel>
    <title>MozTW.org: Mozilla Taiwan</title>
    <link>http://moztw.org/</link>
    <description>Mozilla 系列的中文化與相關資源</description>
HERE

my $RDF_FOOTER=<<HERE;
</channel>
</rss>
HERE

my @ents = ();
my @dats = ();
# parse entries
open LN, "<$fnLatest";
@dats = <LN>;
close LN;
open AN, "<$fnAll";
push (@dats, <AN>);
close AN;

my $lastdate = undef;
for (@dats) {
	my %e = ();
	my $t;
	my $l = undef;
	if ($_ =~ /<\s*div\s*class=.date.[^>]*>([^<]*)<.div\s*>/i) {
		$lastdate = $1;
		next;
	} else {
		next if (!defined $lastdate);
		if ($_ =~ /<a\s*href=['"]([^'"]*)['"]\s*>/i) {
			$l = $1;
		}
	}
	# strip tags
	$_ =~ s/<!--.*-->//g;
	$_ =~ s/<[^>]*>//g;
	$e{title} = "$lastdate: " . $_;
	$l = 'http://www.moztw.org/' if !$l;
	if ($l !~ /^http/) {
		# local ref
		if ($l =~ /^\//) {
			# absolute
			$l = 'http://www.moztw.org' . $l;
		} else {
			# relative
			$l = 'http://www.moztw.org/' . $l;
		}
	}
	$e{link} = $l;
	push (@ents, \%e);
	$lastdate = undef;
}

# Main Program
if (@ARGV == 1) {
	# got filename
	print "Output File: $ARGV[0]\n";
	close STDOUT;
	open STDOUT, ">$ARGV[0]";
} else {
	print $HTTP_HEADER;
}
print $RDF_HEADER;
my $i = 1;
foreach (@ents) {
	my %e = %{$_};
	print '<item>';
	for my $k (keys %e) {
		my $v = $e{$k};
		$v =~ s/</&lt;/g;
		$v =~ s/>/&gt;/g;
		$v =~ s/\s\s*/ /g;
		print "<$k>$v</$k>";
	}
	print "</item>\n";
	last if(++$i > $maxEntries);
}
print $RDF_FOOTER;
close STDOUT;

