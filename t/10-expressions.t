#!perl

use strict;
use warnings;
use Test::More;
use Time::Duration::Parse::More;


sub ok_duration {
  my ($spec, $seconds) = @_;
  my $got = eval { parse_duration($spec) };
  if   ($@) { fail("With '$spec' died with '$@'") }
  else      { is($got, $seconds, "$spec = $seconds") }
}

sub fail_duration {
  my $spec = shift;
  eval { parse_duration($spec) };
  ok($@, $@);
}


subtest 'extended expressions' => sub {
  ok_duration '1 minute, 30 seconds',      90;
  ok_duration '1 minute plus 15 seconds',  75;
  ok_duration '1 minute minus 15 seconds', 45;

  ok_duration '1,3 m', 78;
  ok_duration ',3 m',  18;
  ok_duration '.3 m',  18;
  ok_duration '0.3 m', 18;

  ok_duration '  4,3 ', 4;
  ok_duration ' ,3',    0;
  ok_duration ' .3 ',   0;
  ok_duration '0.7 ',   1;

  ok_duration 'minus 15 seconds',                 -15;
  ok_duration 'minus 15 seconds plus minus plus', -15;

  ok_duration '1 day minus 2.5 hours and 10 minutes plus 15,6 seconds', 76816;

  ok_duration '3 h minus 2:30', 1800;
  ok_duration '1:1:1',          3661;
  ok_duration '100:200:300',    372300;

  fail_duration 'mi nus';
  fail_duration 'minus 15 seconds plu s plus';
  fail_duration '1M aaand minus 15 secs';
};


subtest 'Time::Duration::Parse tests' => sub {
  ok_duration '3',                       3;
  ok_duration '3 seconds',               3;
  ok_duration '3 Seconds',               3;
  ok_duration '3 s',                     3;
  ok_duration '6 minutes',               360;
  ok_duration '6 minutes and 3 seconds', 363;
  ok_duration '6 Minutes and 3 seconds', 363;
  ok_duration '1 day',                   86400;
  ok_duration '1 day, and 3 seconds',    86403;
  ok_duration '-1 seconds',              -1;
  ok_duration '-6 minutes',              -360;

  ok_duration '1 hr', 3600;
  ok_duration '3s',   3;
  ok_duration '1hr',  3600;

  ok_duration '1d 2:03',    93780;
  ok_duration '1d 2:03:01', 93781;
  ok_duration '1d -24:00',  0;
  ok_duration '2:03',       7380;

  ok_duration ' 1s   ', 1;
  ok_duration '   1  ', 1;
  ok_duration '  1.3 ', 1;

  ok_duration '1.5h',     5400;
  ok_duration '1,5h',     5400;
  ok_duration '1.5h 30m', 7200;
  ok_duration '1.9s',     2;      # Check rounding
  ok_duration '1.3s',     1;
  ok_duration '1.3',      1;
  ok_duration '1.9',      2;

  ok_duration '1h,30m, 3s',    5403;
  ok_duration '1h and 30m,3s', 5403;
  ok_duration '1,5h, 3s',      5403;
  ok_duration '1,5h and 3s',   5403;
  ok_duration '1.5h, 3s',      5403;
  ok_duration '1.5h and 3s',   5403;

  fail_duration '3 sss';
  fail_duration '6 minutes and 3 sss';
  fail_duration '6 minutes, and 3 seconds a';
};

done_testing();
