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
while (<FH>) {
    $count++;
    print STDERR "($count/5000)\r";
    if (not m/^3,3,|^4,3|^3,4/) {
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


sub r {
    (my $cur) = @_;
    if (index($cur, "0") % $width != ($width - 1)) {
	if (not $cur =~ m/0=/) {
	    $cur =~ s/0(.)/$1 0/;
	    $cur =~ s/ //;
	    return $cur;
	}
    }
    return "";
}

sub l {
    (my $cur) = @_;
    if (index($cur, "0") % $width != 0) {
	my $reg = '.' x ($width - 2);
	if (not $cur =~ m/=0/) {
	    $cur =~ s/(.)0/0$1/;
	    return $cur;
	}
    }
    return "";
}

sub u {
    (my $cur) = @_;
    if (index($cur, "0") >= $width) {
	my $reg = '.' x ($width - 1);
	if (not $cur =~ m/=($reg)0/) {
	    $cur =~ s/(.)($reg)0/0$2$1/;
	    return $cur;
	}
    }
    return "";
}

sub d {
    (my $cur) = @_;
    if (length($cur) - index($cur, "0") > $width) {
	my $reg = '.' x ($width - 1);
	if (not $cur =~ m/0($reg)=/) {
	    $cur =~ s/0($reg)(.)/$2$1 0/;
	    $cur =~ s/ //;
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

