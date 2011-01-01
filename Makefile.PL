use inc::Module::Install;

name     'Memoize-Class-Constructor';
all_from 'lib/Memoize/Class/Constructor.pm';
author   q{Kenta Sato <kenta.sato.1990@gmail.com>};
license  'perl';

build_requires 'Test::More';
requires 'common::sense';
requires 'Data::MessagePack';
requires 'Sub::Install';

auto_install;

WriteAll;

