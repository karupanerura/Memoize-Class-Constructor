#!/usr/bin/perl
use common::sense;
use lib '../lib';
use Benchmark qw(cmpthese timethese);
use Storable;
use Text::Xslate;
use Memoize::Class::Constructor (-keygen => \&Storable::freeze, -import);

cmpthese timethese(1,
  {
      'Memoize::Class::Constructor' => \&mcc,
      '(raw)' => \&raw,
  }
);

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


sub mcc{
    memoize_constructor('Text::Xslate');
    foreach(0 .. 10000){
	my $obj0 = Text::Xslate->new(%{$options[0]});
	my $obj1 = Text::Xslate->new(%{$options[1]});
	my $obj2 = Text::Xslate->new(%{$options[2]});
	my $obj3 = Text::Xslate->new(%{$options[3]});
	my $obj4 = Text::Xslate->new(%{$options[4]});
    }
}


sub raw{
    foreach(0 .. 10000){
	my $obj0 = Text::Xslate->new(%{$options[0]});
	my $obj1 = Text::Xslate->new(%{$options[1]});
	my $obj2 = Text::Xslate->new(%{$options[2]});
	my $obj3 = Text::Xslate->new(%{$options[3]});
	my $obj4 = Text::Xslate->new(%{$options[4]});
    }
}
