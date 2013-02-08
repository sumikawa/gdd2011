#!/usr/bin/perl
use strict;
use warnings;
use devquiz qw(srch $width $height);
use Getopt::Std;

getopts('c');
our $opt_c;

$| = 1;

open(AN, "answer.txt") if (!$opt_c);
open(FH, "quiz.txt");

my $input = <FH>;
my $totalcount = <FH>;
chomp $totalcount;
my $count;
my $succeed = 0;
my $try = 0;

my $t1 = (times)[0];

while (<FH>) {
    chomp;
    $count++;

    if (!$opt_c) {
	my $an = <AN>;
	if ($an || $an ne "\n") {
	    print "$an";
	    next;
	}
    }

#    if (not m/^3,3,/) {
    if (not m/^3,3,|^4,3,|^3,4,/) {
#    if (not m/^[34],[34],/) {
#    if (not m/^[34],[34],|^[34],5|^5,[34]/) {
#    if (not m/^3,3,|^4,3|^3,4|^4,4|^3,5|^5,3|^3,6|^6,3/) {
#    if (not m/^3,3,|^4,3|^3,4|^4,4|^3,5|^5,3|^3,6|^6,3|^4,5|^5,4/) {
	print "\n";
	next;
    } else {
	$try++;
    }

    my $start = $_;
    $start =~ s/^(\d),(\d),//;
    $width = $1;
    $height = $2;
    (my $result, my $trynum) = devquiz->do_search($start);
    if ($result eq "") {
	$result = "no result" ;
    } else {
	$succeed++;
    }
    printf STDERR "($count/$totalcount), path = %s, # of try = %d" . " "x32 . "\n", $result, $trynum;
}

my $t2 = (times)[0];
my $t3 = $t2 - $t1;
printf STDERR "# of success = %d/%d\n", $succeed, $try;
print STDERR "$t3 sec\n";

exit 0;
