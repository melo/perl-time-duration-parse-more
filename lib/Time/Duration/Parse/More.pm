package Time::Duration::Parse::More;

# ABSTRACT: a very cool module
# VERSION
# AUTHORITY

use strict;
use warnings;
use Exporter;
use Carp;

our @ISA    = qw( Exporter );
our @EXPORT = qw( parse_duration );

# From Time::Duration::Parse
my %units = (
  map(($_, 1),                  qw(s second seconds sec secs)),
  map(($_, 60),                 qw(m minute minutes min mins)),
  map(($_, 60 * 60),            qw(h hr hour hours)),
  map(($_, 60 * 60 * 24),       qw(d day days)),
  map(($_, 60 * 60 * 24 * 7),   qw(w week weeks)),
  map(($_, 60 * 60 * 24 * 30),  qw(M month months)),
  map(($_, 60 * 60 * 24 * 365), qw(y year years))
);

my %cache;

sub parse_duration {
  my ($expression) = @_;
  return unless defined $expression;

  return $cache{$expression} if exists $cache{$expression};
  return $cache{$expression} = parse_duration_nc($expression);
}

sub parse_duration_nc {
  my ($expression) = @_;
  return unless defined $expression;

  my $e = $expression;
  $e =~ s/\band\b/ /gi;
  $e =~ s/[\s\t]+/ /g;
  $e =~ s/^\s+|\s+$//g;

  $e =~ s/^\s*([-+]?\d+(?:[.,]\d+)?)\s*$/$1s/;
  $e =~ s/^\s*([-+]?[.,]\d+)\s*$/$1s/;
  $e =~ s/\b(\d+):(\d+):(\d+)\b/$1h $2m $3s/g;
  $e =~ s/\b(\d+):(\d+)\b/$1h $2m/g;

  my $duration = 0;
  my $signal   = 1;
  while ($e) {
    if    ($e =~ s/^plus\b(\s*,?)*//)  { $signal = 1 }
    elsif ($e =~ s/^minus\b(\s*,?)*//) { $signal = -1 }
    elsif ($e =~ s/^(([-+]?\d+(?:[,.]\d*)?)\s*(\w+))(\s*,?)*// or $e =~ s/^(([-+]?[,.]\d+)\s*(\w+))(\s*,?)*//) {
      my ($m, $n, $u) = ($1, $2, $3);
      $n =~ s/,/./;
      $u = lc($u) unless length($u) == 1;
      croak "Unit '$u' not recognized in '$m'" unless exists $units{$u};
      $duration += $signal * $n * $units{$u};
    }
    else {
      croak("Could not parse '$e'");
    }
  }

  return sprintf('%.0f', $duration);
}


1;

=encoding utf8

=head1 SYNOPSIS

    use Time::Duration::Parse::More;

    my ($seconds);
    $seconds = parse_duration('1 minute, 30 seconds'); ## 90
    $seconds = parse_duration('1 minute plus 15 seconds'); ## 75
    $seconds = parse_duration('1 minute minus 15 seconds'); ## 45
    $seconds = parse_duration('1 day minus 2.5 hours and 10 minutes plus 15 seconds'); ## 76815
    $seconds = parse_duration('minus 15 seconds'); ## -15


=head1 DESCRIPTION

The module parses a limited set of natural language expressions and
converts them into seconds.

It is backwards compatible with L<Time::Duration::Parse> (passes the
same test cases), but adds more expressions and memoization.

At the moment, the module is limited to english language expressions.


=head2 Rules

The following rules are used to parse the expressions:

=over 4

=item *

horizantal white-space, commas and the token I<and> are ignored;

=item *

an expresion in the form C<< N factor >> is translated to
C<< N * factor_in_seconds >>. C<factor> is optional, defaults to I<seconds>.
Negative and fractional values of C<N> are suported. Singular, plural
and single letter versions of C<factor> are understood. All are
case-insensitive B<except> the single letter versions;

=item *

expressions in the form C<hh:mm:ss>, C<hh:mm> are also supported;

=item *

the tokens I<plus> or I<minus> change the signal of the expressions that
follow them;

=item *

the final value is the sum of all the expressions
taking in account the sign defined by the previous rule.

=back


=head2 Factors

The following factors are understood, with the corresponding value in seconds between parentesis:

=over 4

=item *

seconds (1): s, second, seconds, sec, and secs;

=item *

minutes (60): m, minute, minutes, min, and mins;

=item *

hours (60 * minutes factor): h, hr, hour, and hours;

=item *

days (24 * hours factor): d, day, and days;

=item *

weeks (7 * days factor): w, week, and weeks;

=item *

months (30 * days factor): M (note the case), month and months;

=item *

years (365 * days factor): y, year, and years;

=back

=head1 FUNCTIONS

=head2 parse_duration

    $seconds = parse_duration($expression);

Given an C<$expression> in natural lanaguage returns the number of seconds it represents.

If the expression cannot be parsed, C<parse_duration> will croak.


=head1 HISTORY

This module started as a private module for a closed-source project. I
started to release it as C<Time::Delta> when I discovered
L<Time::Duration::Parse>. I updated the API to match it, and added my
own improvements. This is the result.


=head1 ACKNOWLEDGEMENTS

Stole test cases and other small tidbits from Miyagawa's L<Time::Duration::Parse>.


=head1 SEE ALSO

L<Time::Duration::Parse> and L<Time::Duration>.


=cut
