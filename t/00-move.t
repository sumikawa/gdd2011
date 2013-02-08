#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

use devquiz qw(l r u d $width $height);

$width = 6;

is (
    l(l(l("=12340"))),
    "=10234"
);

is (
    l(l("=10234")),
    ""
);

is (
    r(r(r("0123=4"))),
    "1230=4"
);

is (
    r("1230=4"),
    ""
);

$width = 3;
$height = 3;

is (
    u(u("=12345670")),
    "=10342675"
);

is (
    u(u(u("123456780"))),
    ""
);

is (
    d(d("012345678")),
    "312645078"
);

is (
    d(d("012345=67")),
    ""
);

done_testing();
