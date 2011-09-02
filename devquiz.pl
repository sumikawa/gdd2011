#!/usr/bin/perl
use strict;

$| = 1;

my $width;
my $height;

my %done;
my @notyet;
my $orig = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0";
my $good;

open(AN, "answer.txt");

open(FH, "quiz.txt");
my $input = <FH>;
my $input = <FH>;
my $count;
my $min;
my $trynum;

my @gpw, my @gdw;
my $rmd;
my $lmd;
my $umd;
my $dmd;

my $t1 = (times)[0];

while (<FH>) {
    $count++;
#    last if ($count > 500);
    print STDERR "($count/5000)\r";

    my $an = <AN>;
    if ($an ne "\n") {
	print "$an";
	next;
    }

#    if (not m/^3,3,|^4,3|^3,4/) {
#    if (not m/^3,3,|^4,3|^3,4|^4,4|^3,5|^5,3|^3,6|^6,3/) {
    if (not m/^[34],[34],|^[34],5|^5,[34]/) {
#    if (not m/^3,3,|^4,3|^3,4|^4,4|^3,5|^5,3|^3,6|^6,3|^4,5|^5,4/) {
#    if (not m/^3,3/) {
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

    md_init();
    my $init_num = md($start) + 1;
    %done = ();
    @notyet = ($start, 0, "");
    $trynum = 0;
    for (my $i = 0; $i < 1; $i++) {
	$min = $init_num + 24;
	my $result = srch();
	if ($result eq "") {
	    printf STDERR "no result, # of try = %d\n", $trynum;
	    print "\n" if ($i == 0); # xxx
	} else {
	    printf STDERR "path = %s, # of try = %d\n", $result, $trynum;
	    print "$result\n";
	    last;
	}
	$init_num += 2;
    }
    undef @notyet;
    undef %done;
    $trynum = 0;
}

my $t2 = (times)[0];
my $t3 = $t2 - $t1;
print STDERR "$t3 sec\n";

exit 0;

sub r {
    (my $cur) = @_;
    my $idx = index($cur, "0");
    if ($idx % $width != ($width - 1)) {
	my $pos = $idx + 1;
	if (substr($cur, $pos, 1) ne "=") {

	    my $c1 = index($cur, ('0'..'9', 'A'..'Z')[$idx]);
	    my $c2 = index($cur, ('0'..'9', 'A'..'Z')[$pos]);
	    $rmd -= abs(($c1 % $width) - $gpw[$idx]);
	    $rmd -= abs(int($c1 / $width) - $gdw[$idx]);
	    $rmd -= abs(($c2 % $width) - $gpw[$pos]);
	    $rmd -= abs(int($c2 / $width) - $gdw[$pos]);

	    my $tmp = substr($cur, $idx, 1);
	    substr($cur, $idx, 1) = substr($cur, $pos, 1);
	    substr($cur, $pos, 1) = $tmp;

	    my $c1 = index($cur, ('0'..'9', 'A'..'Z')[$idx]);
	    my $c2 = index($cur, ('0'..'9', 'A'..'Z')[$pos]);
	    $rmd += abs(($c1 % $width) - $gpw[$idx]);
	    $rmd += abs(int($c1 / $width) - $gdw[$idx]);
	    $rmd += abs(($c2 % $width) - $gpw[$pos]);
	    $rmd += abs(int($c2 / $width) - $gdw[$pos]);

	    return $cur;
	}
    }
    return "";
}

sub l {
    (my $cur) = @_;
    my $idx = index($cur, "0");
    if ($idx % $width != 0) {
	my $pos = $idx - 1;
	if (substr($cur, $pos, 1) ne "=") {

	    my $c1 = index($cur, ('0'..'9', 'A'..'Z')[$idx]);
	    my $c2 = index($cur, ('0'..'9', 'A'..'Z')[$pos]);
	    $lmd -= abs(($c1 % $width) - $gpw[$idx]);
	    $lmd -= abs(int($c1 / $width) - $gdw[$idx]);
	    $lmd -= abs(($c2 % $width) - $gpw[$pos]);
	    $lmd -= abs(int($c2 / $width) - $gdw[$pos]);

	    my $tmp = substr($cur, $idx, 1);
	    substr($cur, $idx, 1) = substr($cur, $pos, 1);
	    substr($cur, $pos, 1) = $tmp;

	    my $c1 = index($cur, ('0'..'9', 'A'..'Z')[$idx]);
	    my $c2 = index($cur, ('0'..'9', 'A'..'Z')[$pos]);
	    $lmd += abs(($c1 % $width) - $gpw[$idx]);
	    $lmd += abs(int($c1 / $width) - $gdw[$idx]);
	    $lmd += abs(($c2 % $width) - $gpw[$pos]);
	    $lmd += abs(int($c2 / $width) - $gdw[$pos]);

	    return $cur;
	}
    }
    return "";
}

sub u {
    (my $cur) = @_;
    my $idx = index($cur, "0");
    if ($idx >= $width) {
	my $pos = $idx - $width;
	if (substr($cur, $pos, 1) ne "=") {

	    my $c1 = index($cur, ('0'..'9', 'A'..'Z')[$idx]);
	    my $c2 = index($cur, ('0'..'9', 'A'..'Z')[$pos]);
	    $umd -= abs(($c1 % $width) - $gpw[$idx]);
	    $umd -= abs(int($c1 / $width) - $gdw[$idx]);
	    $umd -= abs(($c2 % $width) - $gpw[$pos]);
	    $umd -= abs(int($c2 / $width) - $gdw[$pos]);

	    my $tmp = substr($cur, $idx, 1);
	    substr($cur, $idx, 1) = substr($cur, $pos, 1);
	    substr($cur, $pos, 1) = $tmp;

	    my $c1 = index($cur, ('0'..'9', 'A'..'Z')[$idx]);
	    my $c2 = index($cur, ('0'..'9', 'A'..'Z')[$pos]);
	    $umd += abs(($c1 % $width) - $gpw[$idx]);
	    $umd += abs(int($c1 / $width) - $gdw[$idx]);
	    $umd += abs(($c2 % $width) - $gpw[$pos]);
	    $umd += abs(int($c2 / $width) - $gdw[$pos]);

	    return $cur;
	}
    }
    return "";
}

sub d {
    (my $cur) = @_;
    my $idx = index($cur, "0");
    if (length($cur) - $idx > $width) {
	my $pos = $idx + $width;
	if (substr($cur, $pos, 1) ne "=") {

	    my $c1 = index($cur, ('0'..'9', 'A'..'Z')[$idx]);
	    my $c2 = index($cur, ('0'..'9', 'A'..'Z')[$pos]);
	    $dmd -= abs(($c1 % $width) - $gpw[$idx]);
	    $dmd -= abs(int($c1 / $width) - $gdw[$idx]);
	    $dmd -= abs(($c2 % $width) - $gpw[$pos]);
	    $dmd -= abs(int($c2 / $width) - $gdw[$pos]);

	    my $tmp = substr($cur, $idx, 1);
	    substr($cur, $idx, 1) = substr($cur, $pos, 1);
	    substr($cur, $pos, 1) = $tmp;
	    return $cur;

	    my $c1 = index($cur, ('0'..'9', 'A'..'Z')[$idx]);
	    my $c2 = index($cur, ('0'..'9', 'A'..'Z')[$pos]);
	    $dmd += abs(($c1 % $width) - $gpw[$idx]);
	    $dmd += abs(int($c1 / $width) - $gdw[$idx]);
	    $dmd += abs(($c2 % $width) - $gpw[$pos]);
	    $dmd += abs(int($c2 / $width) - $gdw[$pos]);
	}
    }
    return "";
}

sub md_init {
    for (my $i = 1; $i < $width * $height; $i++) {
	# 0 and = must be skipped for calculation
	my $g = index($good, ('0'..'9', 'A'..'Z')[$i]);
	next if ($g == -1); # case: '='
	$gpw[$i] = $g % $width;
	$gdw[$i] = int($g / $width);
    }
}

sub md {
    (my $cur) = @_;

    my $md = 0;
    for (my $i = 1; $i < $width * $height; $i++) {
	# 0 and = must be skipped for calculation
	my $c = index($cur, ('0'..'9', 'A'..'Z')[$i]);
	next if ($c == -1); # case: '='
	$md += abs(($c % $width) - $gpw[$i]);
	$md += abs(int($c / $width) - $gdw[$i]);
    }
#    printf STDERR "md %s, %d  \r",$cur, $md;
    return $md;
}

sub srch {
    my @srchs = @_;
    my $minpath = "";

    while (@notyet) {
	my $path  = pop(@notyet);
	my $num = pop(@notyet);
	my $current = pop(@notyet);

	push(@srchs, ($current, $num, $path));
    }

    while (@srchs) {
	my $path  = pop(@srchs);
	my $num = pop(@srchs);
	my $current = pop(@srchs);
	my $next;

	$trynum++;
	last if ($trynum > 1000000);

	if (exists($done{$current})) {
	    if ($done{$current} > length($path)) {
	    } else {
		next;
	    }
	}

	if ($num + md($current) >= $min) {
	    push(@notyet, ($current, $num, $path));
	    next;
	}

	$done{$current} = length($path);
	if ($current eq $good) {
	    $minpath = $path;
	    $min = $num;
#	    print STDERR "current minpath: $minpath  \r";
	    next;
	}

	my $r = r($current);
	my $l = l($current);
	my $u = u($current);
	my $d = d($current);

	if ($r < $l) {
	    if ($u < $d) {
		push(@srchs, ($r, $num + 1, $path . "R")) if ($r ne "");
		push(@srchs, ($l, $num + 1, $path . "L")) if ($l ne "");
		push(@srchs, ($u, $num + 1, $path . "U")) if ($u ne "");
		push(@srchs, ($d, $num + 1, $path . "D")) if ($d ne "");
	    } else {
		push(@srchs, ($r, $num + 1, $path . "R")) if ($r ne "");
		push(@srchs, ($l, $num + 1, $path . "L")) if ($l ne "");
		push(@srchs, ($d, $num + 1, $path . "D")) if ($d ne "");
		push(@srchs, ($u, $num + 1, $path . "U")) if ($u ne "");
	    }
	} else {
	    if ($u < $d) {
		push(@srchs, ($l, $num + 1, $path . "L")) if ($l ne "");
		push(@srchs, ($r, $num + 1, $path . "R")) if ($r ne "");
		push(@srchs, ($u, $num + 1, $path . "U")) if ($u ne "");
		push(@srchs, ($d, $num + 1, $path . "D")) if ($d ne "");
	    } else {
		push(@srchs, ($l, $num + 1, $path . "L")) if ($l ne "");
		push(@srchs, ($r, $num + 1, $path . "R")) if ($r ne "");
		push(@srchs, ($d, $num + 1, $path . "D")) if ($d ne "");
		push(@srchs, ($u, $num + 1, $path . "U")) if ($u ne "");
	    }
	}
    }
    return $minpath;
}
