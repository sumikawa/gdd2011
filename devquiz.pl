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

my $min;

my $t1 = (times)[0];

while (<FH>) {
    $count++;
#    last if ($count > 500);
    print STDERR "($count/5000)\r";
    if (not m/^3,3,|^4,3|^3,4/) {
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
    for (my $i = 0; $i < 7; $i++) {
	$min = $init_num;
	%done = ();
	my $result = srch($start, 0, "");
	undef %done;
	if ($result eq "") {
	    print "\n" if ($i == 6); # xxx
	} else {
	    print "$result\n";
	    last;
	}
	$init_num += 2;
    }
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

my @gpw, my @gdw;

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

    while (@srchs) {
	my $path  = pop(@srchs);
	my $num = pop(@srchs);
	my $current = pop(@srchs);
	my $next;

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
#	    print STDERR "current minpath: $minpath  \r";
	    next;
	}

	next if ($num + md($current) >= $min);

	my $r = r($current);
	my $l = l($current);
	my $u = u($current);
	my $d = d($current);
	push(@srchs, ($r, $num + 1, $path . "R")) if ($r ne "");
	push(@srchs, ($l, $num + 1, $path . "L")) if ($l ne "");
	push(@srchs, ($u, $num + 1, $path . "U")) if ($u ne "");
	push(@srchs, ($d, $num + 1, $path . "D")) if ($d ne "");
    }
    return $minpath;
#    print STDERR "this is min: $minpath  \r";
}
