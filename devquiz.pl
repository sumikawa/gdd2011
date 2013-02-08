#!/usr/bin/perl
use strict;
use devquiz qw(srch $width $height);

$| = 1;

open(AN, "answer.txt");
open(FH, "quiz.txt");

my $input = <FH>;
my $input = <FH>;
my $count;

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
    devquiz->do_search($start);
}

my $t2 = (times)[0];
my $t3 = $t2 - $t1;
print STDERR "$t3 sec\n";

exit 0;
