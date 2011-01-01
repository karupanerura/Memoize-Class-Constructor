#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Memoize::Class::Constructor' ) || print "Bail out!
";
}

diag( "Testing Memoize::Class::Constructor $Memoize::Class::Constructor::VERSION, Perl $], $^X" );
