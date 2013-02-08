#!/usr/bin/perl
use strict;
use devquiz qw(srch $width $height $good);

$| = 1;

my $orig = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0";

open(AN, "answer.txt");
open(FH, "quiz.txt");

my $input = <FH>;
my $input = <FH>;
my $count;

my $rmd;
my $lmd;
my $umd;
my $dmd;

my $t1 = (times)[0];

while (<FH>) {
    $count++;

    my $an = <AN>;
    if ($an || $an ne "\n") {
	print "$an";
	next;
    }

    if (not m/^3,3,|^4,3|^3,4/) {
#    if (not m/^[34],[34],/) {
#    if (not m/^[34],[34],|^[34],5|^5,[34]/) {
#    if (not m/^3,3,|^4,3|^3,4|^4,4|^3,5|^5,3|^3,6|^6,3/) {
#    if (not m/^3,3,|^4,3|^3,4|^4,4|^3,5|^5,3|^3,6|^6,3|^4,5|^5,4/) {
	print "\n";
	next;
    }
    chomp;
    my $start = $_;
    $start =~ s/^(\d),(\d),//;
    $width = $1;
    $height = $2;
    $good = substr($orig, 0, length($start) - 1) . "0";
    for (my $i = 0; $i < length($start); $i++) {
	if (substr($start, $i, 1) eq "=") {
	    $good = substr($good, 0, $i) . "=" . substr($good, $i + 1, length($start) - $i);
	}
    }
    devquiz->do_search($start);
}

my $t2 = (times)[0];
my $t3 = $t2 - $t1;
print STDERR "$t3 sec\n";

exit 0;
