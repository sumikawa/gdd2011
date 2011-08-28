#!/usr/bin/perl
use strict;

#my $width = 5;
#my $height = 6;
#my $start = "12=E4D9HIF8=GN576LOABMTPKQSR0J";
#my $good  = "12=456789AB=DEFGHIJKLMNOPQRST0";

#my $width = 4;
#my $height = 4;
#my $start = "32465871FAC0=9BE";
#my $good  = "123456789ABC=DE0";

#my $width = 3;
#my $height = 4;
#my $start = "1327A40=5B96";
#my $good  = "1234567=89A0";

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

sub srch {
    my @srchs = @_;
    my $min = 30;
    my $minpath = "";

    while (@srchs) {
	my $path  = pop(@srchs);
	my $num = pop(@srchs);
	my $current = pop(@srchs);

	my $next = "";

	next if ($num >= $min);
#	print STDERR "$current: $num, $path\n";

	$next = r($current);
	if ($next ne "") {
	    if (exists($done{$next})) {
		if (length($done{$next}) > length($path) + 1) {
		    $done{$next} = $path . "R";
		    push(@srchs, ($next, $num + 1, $path . "R"));
		}
	    } else {
		if ($next eq $good) {
		    $minpath = $path . "R";
		    $min = $num;
		    print STDERR "current minpath: $minpath\n";
		    next;
		}
		$done{$next} = $path . "R";
		push(@srchs, ($next, $num + 1, $path . "R"));
	    }
	}

	$next = l($current);
	if ($next ne "") {
	    if (exists($done{$next})) {
		if (length($done{$next}) > length($path) + 1) {
		    $done{$next} = $path . "L";
		    push(@srchs, ($next, $num + 1, $path . "L"));
		}
	    } else {
		if ($next eq $good) {
		    $minpath = $path . "L";
		    $min = $num;
		    print STDERR "current minpath: $minpath\n";
		    next;
		}
		$done{$next} = $path . "L";
		push(@srchs, ($next, $num + 1, $path . "L"));
	    }
	}

	$next = u($current);
	if ($next ne "") {
	    if (exists($done{$next})) {
		if (length($done{$next}) > length($path) + 1) {
		    $done{$next} = $path . "U";
		    push(@srchs, ($next, $num + 1, $path . "U"));
		}
	    } else {
		if ($next eq $good) {
		    $minpath = $path . "U";
		    $min = $num;
		    print STDERR "current minpath: $minpath\n";
		    next;
		}
		$done{$next} = $path . "U";
		push(@srchs, ($next, $num + 1, $path . "U"));
	    }
	}

	$next = d($current);
	if ($next ne "") {
	    if (exists($done{$next})) {
		if (length($done{$next}) > length($path) + 1) {
		    $done{$next} = $path . "D";
		    push(@srchs, ($next, $num + 1, $path . "D"));
		}
	    } else {
		if ($next eq $good) {
		    $minpath = $path . "D";
		    $min = $num;
		    print STDERR "current minpath: $minpath\n";
		    next;
		}
		$done{$next} = $path . "D";
		push(@srchs, ($next, $num + 1, $path . "D"));
	    }
	}
    }
    print "$minpath\n";
    print STDERR "thisismin: $minpath\n";
}

sub test {
    print "* right\n";
    my $t = "12=E4D9HIF8=GN576LOABMTPKQSR0J";
    print "$t\n";
    $t = r($t);
    print "$t\n";
    $t = r($t);
    print "$t\n";
    $t = r($t);
    print "$t\n";

    print "* left\n";
    my $t = "12=E4D9HIF8=GN576LOABMTPKQSR0J";
    print "$t\n";
    $t = l($t);
    print "$t\n";
    $t = l($t);
    print "$t\n";
    $t = l($t);
    print "$t\n";
    $t = l($t);
    print "$t\n";
    $t = l($t);
    print "$t\n";
    $t = l($t);
    print "$t\n";

    $t = "=10234";
    print "$t\n";
    $t = l($t);
    print "$t\n";
    $t = l($t);
    print "$t\n";
    $t = l($t);
    print "$t\n";

    print "* up\n";
    my $t = "12=E4D9HIF8=GN576LOABMTPKQSR0J";
    print "$t\n";
    $t = u($t);
    print "$t\n";
    $t = u($t);
    print "$t\n";
    $t = u($t);
    print "$t\n";
    $t = u($t);
    print "$t\n";
    $t = u($t);
    print "$t\n";
    $t = u($t);
    print "$t\n";

    $t = "123456780";
    print "$t\n";
    $t = u($t);
    print "$t\n";
    $t = u($t);
    print "$t\n";
    $t = u($t);
    print "$t\n";

    $t = "123456078";
    print "$t\n";
    $t = u($t);
    print "$t\n";
    $t = u($t);
    print "$t\n";
    $t = u($t);
    print "$t\n";

    print "* down\n";
    my $t = "10=E4D9HIF8=GN576LOABMTPKQSR2J";
    print "$t\n";
    $t = d($t);
    print "$t\n";
    $t = d($t);
    print "$t\n";

    my $t = "10=E4D9HIF=8GN576LOABMTPKQSR2J";
    print "$t\n";
    $t = d($t);
    print "$t\n";
    $t = d($t);
    print "$t\n";
    $t = d($t);
    print "$t\n";
    $t = d($t);
    print "$t\n";
    $t = d($t);
    print "$t\n";
    $t = d($t);
    print "$t\n";

    $t = "012345678";
    print "$t\n";
    $t = d($t);
    print "$t\n";
    $t = d($t);
    print "$t\n";
    $t = d($t);
    print "$t\n";
}

#test();

