#!/usr/bin/perl

#$current = "12=E4D9HIF8=GN576LOABMTPKQSR0J";
#$good    = "12=3456789A=BCDEFGHIJKLMNOPQR0";

$current = "168452=30";
$good    = "123456=70";

$num = 0;
$min = 100000;
my %done;
$path = "";
$| = 1;

$width = 3;
$height = 3;

sub r {
    if (index($_[0], "0") % $width != ($width - 1)) {
	if (not $_[0] =~ m/0=/) {
	    $reg = '.' x ($width - 2);
	    $_[0] =~ s/0($reg)/$1 0/;
	    $_[0] =~ s/ //;
	    return 0;
	}
    }
    return 1;
}

sub l {
    if (index($_[0], "0") % $width != 0) {
	if (not $_[0] =~ m/=0/) {
	    $reg = '.' x ($width - 2);
	    $_[0] =~ s/($reg)0/0$1/;
	    return 0;
	}
    }
    return 1;
}

sub u {
    if (index($_[0], "0") > $width) {
	$reg = '.' x ($width - 1);
	if (not $_[0] =~ m/=($reg)0/) {
	    $_[0] =~ s/(.)($reg)0/0$2$1/;
	    return 0;
	}
    }
    return 1;
}

sub d {
    if (length($_[0]) - index($_[0], "0") > $width) {
	$reg = '.' x ($width - 1);
	if (not $_[0] =~ m/0($reg)=/) {
	    $_[0] =~ s/0($reg)(.)/$2$1 0/;
	    $_[0] =~ s/ //;
	    return 0;
	}
    }
    return 1;
}

sub srch {
    ($current, $num, $path) = @_;
    # 終了したか
    #   YES
    #     探索回数を確認して、最短なら更新
    #     ret
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
    print "$current: $path";
    if ($current eq $good) {
	print "  good = $current\n";
	if ($num < $min) {
	    $minpath = $path;	
	    print "  minpath = $minpath\n";
	}
	return;
    }
    if (l($current) == 0) {
	if (exists($done{$current})) {
	    return;
	} else {
	    $done{$current} = 1;
	    $num++;
	    $path = $path . "L";
	    srch($current, $num, $path);
	}
    } else {
	return;
    }
    if (r($current) == 0) {
	if (exists($done{$current})) {
	    return;
	} else {
	    $done{$current} = 1;
	    $num++;
	    $path = $path . "R";
	    srch($current, $num, $path);
	}
    } else {
	return;
    }
    if (u($current) == 0) {
	if (exists($done{$current})) {
	    return;
	} else {
	    $done{$current} = 1;
	    $num++;
	    $path = $path . "U";
	    srch($current, $num, $path);
	}
    } else {
	return;
    }
    if (d($current) == 0) {
	if (exists($done{$current})) {
	    return;
	} else {
	    $done{$current} = 1;
	    $num++;
	    $path = $path . "D";
	    srch($current, $num, $path);
	}
    } else {
	return;
    }
}

sub test {
    print "\n right\n";
    $t = "01234=";
    print "start: $t\n";
    $ret = r($t);
    print "ret = $ret, $t\n";
    $ret = r($t);
    print "ret = $ret, $t\n";
    $ret = r($t);
    print "ret = $ret, $t\n";

    print "\n left\n";
    $t = "=12340";
    print "\nstart: $t\n";
    $ret = l($t);
    print "ret = $ret, $t\n";
    $ret = l($t);
    print "ret = $ret, $t\n";
    $ret = l($t);
    print "ret = $ret, $t\n";

    $t = "=10234";
    print "\nstart: $t\n";
    $ret = l($t);
    print "ret = $ret, $t\n";
    $ret = l($t);
    print "ret = $ret, $t\n";
    $ret = l($t);
    print "ret = $ret, $t\n";

    print "\n up\n";
    $t = "=12345670";
    print "\nstart: $t\n";
    $ret = u($t);
    print "ret = $ret, $t\n";
    $ret = u($t);
    print "ret = $ret, $t\n";

    $t = "123456780";
    print "\nstart: $t\n";
    $ret = u($t);
    print "ret = $ret, $t\n";
    $ret = u($t);
    print "ret = $ret, $t\n";
    $ret = u($t);
    print "ret = $ret, $t\n";

    print "\n down\n";
    $t = "012345=67";
    print "\nstart: $t\n";
    $ret = d($t);
    print "ret = $ret, $t\n";
    $ret = d($t);
    print "ret = $ret, $t\n";

    $t = "012345678";
    print "\nstart: $t\n";
    $ret = d($t);
    print "ret = $ret, $t\n";
    $ret = d($t);
    print "ret = $ret, $t\n";
    $ret = d($t);
    print "ret = $ret, $t\n";
}

##$done{$current} = 1;
srch($current, $num, $path);

#test();
