package Time::Duration::Parse::More;

# ABSTRACT: a very cool module
our $VERSION = '0.001'; # VERSION
our $AUTHORITY = 'cpan:MELO'; # AUTHORITY

use strict;
use warnings;


1;

__END__

=pod

=encoding utf-8

=for :stopwords Pedro Melo ACKNOWLEDGEMENTS cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 NAME

Time::Duration::Parse::More - a very cool module

=head1 VERSION

version 0.001

=head1 SYNOPSIS

    use Time::Duration::Parse::More;

    my ($seconds);
    $seconds = parse_duration('1 minute, 30 seconds'); ## 90
    $seconds = parse_duration('1 minute plus 15 seconds'); ## 75
    $seconds = parse_duration('1 minute minus 15 seconds'); ## 45
    $seconds = parse_duration('1 day minus 2.5 hours and 10 minutes plus 15 seconds'); ## 76815
    $seconds = parse_duration('minus 15 seconds'); ## -15

=head1 DESCRIPTION

The module a limited set of natural language expressions into seconds.
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

the tokens I<plus> or I<minus> change the signal of the expressions that
follow them;

=item *

expression in the form C<hh:mm:ss>, C<hh:mm> are also supported;

=item *

the final value is calculating by the sum of all the expressions
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

=encoding utf8

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

=head1 SEE ALSO

L<Time::Duration::Parse> and L<Time::Duration>.

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc Time::Duration::Parse::More

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/T/Time-Duration-Parse-More>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

L<http://matrix.cpantesters.org/?dist=Time-Duration-Parse-More>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=Time::Duration::Parse::More>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/Time-Duration-Parse-More>

=back

=head2 Email

You can email the author of this module at C<MELO at cpan.org> asking for help with any problems you have.

=head2 Bugs / Feature Requests

Please report any bugs or feature requests by email to C<bug-time-duration-parse-more at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/Public/Dist/Display.html?Name=Time-Duration-Parse-More>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code


L<https://github.com/melo/perl-time-duration-parse-more>

  git clone https://github.com/melo/perl-time-duration-parse-more.git

=head1 ACKNOWLEDGEMENTS

Stole test cases and other small tidbits from Miyagawa's L<Time::Duration::Parse>.

=head1 AUTHOR

Pedro Melo <melo@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by Pedro Melo.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
