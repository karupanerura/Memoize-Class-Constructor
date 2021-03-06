#!/usr/bin/perl
package Packed::Text::Xslate;
use lib '../lib';
use parent qw(Text::Xslate);
use Memoize::Class::Constructor (-target => 'new');

sub new{ SUPER::new(@_); }

1;

package main;

use common::sense;
use lib '../lib';
use Benchmark qw(cmpthese timethis);
use Text::Xslate;
use Object::Container;

my @options = (
    +{
	path       => ['.'],
        cache_dir  => "$ENV{HOME}/.xslate_cache",
        cache      => 1,
    },
    +{
	path       => ['.', 'project_dir'],
        cache_dir  => "$ENV{HOME}/.xslate_cache",
        cache      => 1,
    },
    +{
        cache      => 0,
    },
    +{
        cache      => 1,
    },
    +{
        cache      => 0,
        path       => ['.', 'project_dir'],	
    }
);

my $xslate = Object::Container->new;
do{
    my $n = 20 * 100;
    my %result = ();

    do{
	my $raw = '(raw)';
	$result{$raw} = timethis($n, \&raw, $raw);
    };
    do{
	my $oc = 'Object::Container';
	$xslate->register('0', sub{ Text::Xslate->new(%{$options[0]}); });
	$xslate->register('1', sub{ Text::Xslate->new(%{$options[1]}); });
	$xslate->register('2', sub{ Text::Xslate->new(%{$options[2]}); });
	$xslate->register('3', sub{ Text::Xslate->new(%{$options[3]}); });
	$xslate->register('4', sub{ Text::Xslate->new(%{$options[4]}); });
	$result{$oc} = timethis($n, \&oc, $oc);
    };
    do{
	my $mcc = 'Memoize::Class::Constructor';
	$result{$mcc} = timethis($n, \&mcc, $mcc);
    };
    cmpthese \%result;
};

sub mcc{
    my $obj0 = Memoized::Text::Xslate->new(%{$options[0]});
    my $obj1 = Memoized::Text::Xslate->new(%{$options[1]});
    my $obj2 = Memoized::Text::Xslate->new(%{$options[2]});
    my $obj3 = Memoized::Text::Xslate->new(%{$options[3]});
    my $obj4 = Memoized::Text::Xslate->new(%{$options[4]});
}


sub raw{
    my $obj0 = Text::Xslate->new(%{$options[0]});
    my $obj1 = Text::Xslate->new(%{$options[1]});
    my $obj2 = Text::Xslate->new(%{$options[2]});
    my $obj3 = Text::Xslate->new(%{$options[3]});
    my $obj4 = Text::Xslate->new(%{$options[4]});
}

sub oc{    
    my $obj0 = $xslate->get('0');
    my $obj1 = $xslate->get('1');
    my $obj2 = $xslate->get('2');
    my $obj3 = $xslate->get('3');
    my $obj4 = $xslate->get('4');
}

