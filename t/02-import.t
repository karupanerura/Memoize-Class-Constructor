#!perl -T
package TestClass1;

my $cnt = 0;

sub new{
    my $class = shift;
    bless({args => [@_], cnt => ++$cnt} => $class);
}

package TestClass2;

my $cnt2 = 0;

sub new_instance{
    my $class = shift;
    bless({args => [@_], cnt => ++$cnt2} => $class);
}

package main;

my $sample_option = 'option';

use Test::More tests => 4;

use Memoize::Class::Constructor(-import);

ok(TestClass1->new($sample_option) ne TestClass1->new($sample_option));
ok(TestClass2->new_instance($sample_option) ne TestClass2->new_instance($sample_option));

memoize_constructor(
    TestClass1,
    +{TestClass2 => 'new_instance'}
);

ok(TestClass1->new($sample_option) eq TestClass1->new($sample_option));
ok(TestClass2->new_instance($sample_option) eq TestClass2->new_instance($sample_option));
