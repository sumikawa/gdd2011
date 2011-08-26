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

my $min = 100000;
my $minpath = "";
my %done;
my $orig = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0";
my $good;

open(FH, "quiz.txt");
my $input = <FH>;
my $input = <FH>;
while (<FH>) {
    if (not m/^3,3,/) {
	print "\n";
	next;
    }
    if (not m/=/) {
	print "\n";
	next;
    }
    chomp;
    my $start = $_;
    $start =~ s/3,3,//;
    $good = substr($orig, 0, length($start) - 1) . "0";
    for (my $i = 0; $i < length($start); $i++) {
	if (substr($start, $i, 1) eq "=") {
	    $good = substr($good, 0, $i) . "=" . substr($good, $i + 1, length($start) - $i);
	}
    }
#    print "$start, $good\n";
    $done{$start} = 1;
    $width = 3;
    $height = 3;
    $minpath = "";
    $min = 100000;
    srch($start, 0, "");
    print ("$minpath\n");
    %done = {};
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
    (my $current, my $num, my $path) = @_;
    # ゴールしたか
    #   YES
    #     探索回数を確認して、最短なら更新
    # L動くか
    #   YES
    #     動いた先は過去にあった局面か
    #       YES
    #         探索終了
    #       NO
    #         再帰呼出
    #   NO
    #         探索終了
    # R動くか
    # U動くか
    # D動くか
    # 終了
    if ($num > $min) {
	return
    }

    my $next = "";
#    print "$current\n";
#    print "$current: $path\n";
    if ($current eq $good) {
#	print "good = $current\n";
	if ($num < $min) {
	    $minpath = $path;	
	    $min = $num;
#	    print "  this is current minpath: $num, $minpath\n";
	}
	$done{$current} = 0;
	return;
    }

    $next = r($current);
    if ($next eq "") {
#	print "  cannot R: $next\n";
    } else {
	if (exists($done{$next}) && ($done{$next} == 1)) {
#	    print "  R exist: $next\n";
	} else {
	    $done{$next} = 1;
	    srch($next, $num + 1, $path . "R");
	}
    }

    $next = l($current);
    if ($next eq "") {
#	print "  cannot L: $next\n";
    } else {
	if (exists($done{$next}) && ($done{$next} == 1)) {
#	    print "  L exist: $next\n";
	} else {
	    $done{$next} = 1;
	    srch($next, $num + 1, $path . "L");
	}
    }

    $next = u($current);
    if ($next eq "") {
#	print "  cannot U: $next\n";
    } else {
	if (exists($done{$next}) && ($done{$next} == 1)) {
#	    print "  U exist: $next\n";
	} else {
	    $done{$next} = 1;
	    srch($next, $num + 1, $path . "U");
	}
    }

    $next = d($current);
    if ($next eq "") {
#	print "  cannot D: $next\n";
    } else {
	if (exists($done{$next}) && ($done{$next} == 1)) {
#	    print "  D exist: $next\n";
	} else {
	    $done{$next} = 1;
	    srch($next, $num + 1, $path . "D");
	}
    }

#    print "  * exit\n";
    return;
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

