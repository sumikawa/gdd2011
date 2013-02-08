use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'devquiz',
    AUTHOR              => 'Munechika Sumikawa <sumikawa@sumikawa.jp',
    VERSION		=> '0.1',
    PL_FILES            => {},
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);
