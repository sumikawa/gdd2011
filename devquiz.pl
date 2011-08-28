#!/usr/bin/perl
use strict;

$| = 1;

my $width;
my $height;

my %done;
my $orig = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0";
my $good;

open(FH, "quiz.txt");
my $input = <FH>;
my $input = <FH>;
my $count;

#$width = 4;
#$height = 4;
#$good =            "123456789ABC=EF0";
#printf "%d\n",  md("32465871FAC0=9BE");
#exit 0;

my $t1 = (times)[0];

while (<FH>) {
    $count++;
    last if ($count > 500);
    print STDERR "($count/5000)\r";
#    if (not m/^3,3,|^4,3|^3,4/) {
    if (not m/^3,3/) {
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
    %done = ();
    $done{$start} = 1;
    srch($start, 0, "");
    undef %done;
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
	    my $tmp = substr($cur, $idx, 1);
	    substr($cur, $idx, 1) = substr($cur, $pos, 1);
	    substr($cur, $pos, 1) = $tmp;
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
	    my $tmp = substr($cur, $idx, 1);
	    substr($cur, $idx, 1) = substr($cur, $pos, 1);
	    substr($cur, $pos, 1) = $tmp;
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
	    my $tmp = substr($cur, $idx, 1);
	    substr($cur, $idx, 1) = substr($cur, $pos, 1);
	    substr($cur, $pos, 1) = $tmp;
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
	    my $tmp = substr($cur, $idx, 1);
	    substr($cur, $idx, 1) = substr($cur, $pos, 1);
	    substr($cur, $pos, 1) = $tmp;
	    return $cur;
	}
    }
    return "";
}

sub md {
    (my $cur) = @_;

    my $md = 0;
    my @k = ('0'..'9', 'A'..'Z');

    for (my $i = 1; $i < $width * $height; $i++) {
	# 0 must be skipped for calculation
	my $c = index($cur, $k[$i]);
	my $g = index($good, $k[$i]);
	$md += abs(($c % $width) - ($g % $width));
	$md += abs(int($c / $width) - int($g / $width));
    }
    return $md;
}

sub srch {
    my @srchs = @_;
#    my $min = 30;
    my $min = 200;
    my $minpath = "";

    while (@srchs) {
	my $path  = pop(@srchs);
	my $num = pop(@srchs);
	my $current = pop(@srchs);
	my $next;

	next if ($num + md($current) >= $min);

	if (exists($done{$current})) {
	    if (length($done{$current}) > length($path)) {
	    } else {
		next;
	    }
	}

	$done{$current} = $path;
	if ($current eq $good) {
	    $minpath = $path;
	    $min = $num;
	    print STDERR "current minpath: $minpath  \r";
	    next;
	}


	$next = r($current);
	if ($next ne "") {
	    push(@srchs, ($next, $num + 1, $path . "R"));
	}
	$next = l($current);
	if ($next ne "") {
	    push(@srchs, ($next, $num + 1, $path . "L"));
	}
	$next = u($current);
	if ($next ne "") {
	    push(@srchs, ($next, $num + 1, $path . "U"));
	}
	$next = d($current);
	if ($next ne "") {
	    push(@srchs, ($next, $num + 1, $path . "D"));
	}
    }
    print "$minpath\n";
    print STDERR "this is min: $minpath  \r";
}
