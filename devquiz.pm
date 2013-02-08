package devquiz;

use warnings;
use strict;
use Exporter;

my %done;
our $width;
our $height;
my $good;
my $min;
my $minmd;
my $minmdpath;

my @notyet;
my @notyet2;

my @gpw, my @gdw;
my $trynum;

our @ISA = qw/Exporter/;
our @EXPORT = qw/l r u d srch md_init md do_search $width $height/;

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

    push(@srchs, @notyet2);
    push(@srchs, @notyet);

    my $numcand = 0;
    while (@srchs) {
	my $path  = pop(@srchs);
	my $num = pop(@srchs);
	my $current = pop(@srchs);
	my $next;

	$trynum++;
	last if ($trynum > 4000000);

	if (exists($done{$current})) {
	    if ($done{$current} > length($path)) {
	    } else {
		next;
	    }
	}

	my $currentmd = md($current);
	if ($num + $currentmd >= $min) {
	    if ($currentmd < $minmd) {
		$minmd = $currentmd;
		$minmdpath = $current;
		undef @notyet2;
		@notyet2 = @notyet;
		undef @notyet;
		@notyet = ();
		push(@notyet, ($current, $num, $path));
		$numcand = 0;
#		print STDERR "current md: $currentmd\n";
	    } elsif ($currentmd == $minmd) {
		$numcand++;
#		if ($numcand < 10) {
		push(@notyet, ($current, $num, $path));
#		    unshift(@notyet, ($current, $num, $path));
#		}
#		if ($numcand > 1000) {
#		    last;
#		}
	    } else {
#		if ($numcand > 10) {
#		    last;
#		}
#		unshift(@notyet, ($current, $num, $path));
	    }
	    next;
	}

	$done{$current} = length($path);
	if ($current eq $good) {
	    $minpath = $path;
	    $min = $num;
#	    print STDERR "current minpath: $minpath  \r";
	    last;
	}

	my $r = r($current);
	my $l = l($current);
	my $u = u($current);
	my $d = d($current);
	push(@srchs, ($r, $num + 1, $path . "R")) if ($r ne "");
	push(@srchs, ($d, $num + 1, $path . "D")) if ($d ne "");
	push(@srchs, ($l, $num + 1, $path . "L")) if ($l ne "");
	push(@srchs, ($u, $num + 1, $path . "U")) if ($u ne "");
    }
    return $minpath;
}

sub do_search {
    (my $self, my $start) = @_;

    my $orig = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0";
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
    $minmd = 99999;
    $minmdpath = "";
    my $result;

    my $loopmax = 300;
    for (my $i = 0; $i < $loopmax; $i++) {
	print STDERR "loop: $i, min: $init_num, trynum: $trynum, minmd: $minmd, minpath: $minmdpath\r";
	$min = $init_num;
	$result = srch();
	if ($result eq "") {
	    if ($i == $loopmax - 1) {
		print "\n";
	    }
	} else {
	    print "$result\n";
	    last;
	}
	$init_num += 16;
    }
    undef @notyet;
    undef @notyet2;
    undef %done;
    my $retnum = $trynum;
    $trynum = 0;
    return ($result, $retnum)
}

1;
