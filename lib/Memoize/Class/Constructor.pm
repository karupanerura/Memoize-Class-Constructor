package Memoize::Class::Constructor;

use strict;
use warnings;
use utf8;
use Carp;

use Data::MessagePack;
use Sub::Install qw(install_sub reinstall_sub);

sub keygen{ Data::MessagePack->pack(@_); }

my %_options = (
    -target => sub{
	my($class, $caller, $value) = @_;
	
	_export_memoize($caller, $value // 'new');
    },
    -import => sub{
	my($class, $caller, $value) = @_;
	
	install_sub(+{
	    code => \&memoize_constructor,
	    into => $caller,
	    as   => $value // 'memoize_constructor',
	});
    },
    -keygen => sub{
	my($class, $caller, $value) = @_;
	
	if(ref($value) eq 'CODE'){
	    reinstall_sub(+{
		code => $value,
		into => $class,
		as   => 'keygen',
	    });
	}else{
	    croak(q|You must throw code reference if you want to use '-keygen' option.|);
	}
    },
);

sub import{
    my $class = shift;
    
    while(scalar(@_)){
	my $arg = shift;

	if($arg =~ m/^-/io){
	    my $value = shift;

	    map{
		if($arg eq $_){	    
		    $_options{$arg}->($class, scalar(caller(0)), $value);
		    next;
		}
	    } (keys %_options);
	}else{
	    memoize_constructor($arg, @_);
	    last;
	}
    }
}

# JSON::Any->objToJson(@_);

=head1 NAME
    
Memoize::Class::Constructor - Make constructor functions faster by trading space for time

=cut

=head1 VERSION

Version 0.01

=cut

use version;
our $VERSION = qv('0.01');

=head1 SYNOPSIS

You can choose to use convenient interface for you.

    use Class;
    use Class2;
    use Class3;
    use Class4;
    use Memoize::Class::Constructor (
          Class,                     # memoize target is 'Class::new'.
          {Class2 => 'constructor'}, # memoize target is 'Class2::constructor'.
          {
             Class3 => 'instance',
             Class4 => 'new2',
	  }, # memoize target is 'Class3::instance' and 'Class4::new2'.
    );
    
    ...
    
or 

    use Class;
    use Class2;
    use Class3;
    use Class4;
    use Memoize::Class::Constructor (-import => memoize_constructor);
    
    memoize_constructor(
          Class,                     # memoize target is 'Class::new'.
          {Class2 => 'constructor'}, # memoize target is 'Class2::constructor'.
          {
             Class3 => 'instance',
             Class4 => 'new2',
	  }, # memoize target is 'Class3::instance' and 'Class4::new2'.
    );

    ...
    
or

    package Your::Class;
    use Memoize::Class::Constructor (-target => 'new'); # memoize target is 'Your::Class::new'.

    ...

=head1 SUBROUTINES/METHODS

=head2 
    
    memoize_constructor
    
=cut

my %_instance;

sub memoize_constructor{
    map{
	if(ref $_ eq 'HASH'){
	    my $hash_ref = $_;
	    map{
		_export_memoize($_, $hash_ref->{$_});
	    } keys %$hash_ref;
	}else{
	    _export_memoize($_, 'new');
	}
    } @_;
}

sub _export_memoize{
    my($target_package, $constructor_name) = @_;
    my $default_contructor = $target_package->can($constructor_name)
	or croak("Can't find method '$target_package\::$constructor_name'");

    reinstall_sub(+{
	code => sub {
	    my $key = Memoize::Class::Constructor::keygen(\@_); 
	    
	    $_instance{$key} // ($_instance{$key} = $default_contructor->(@_));
	},
	into => $target_package,
	as   => $constructor_name,
    });
}


=head1 AUTHOR

Kenta Sato, C<< <kenta.sato.1990 at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-class-singleton-eachargs at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Memoize-Class-Constructor>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Memoize::Class::Constructor

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Memoize-Class-Constructor>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Memoize-Class-Constructor>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Memoize-Class-Constructor>

=item * Search CPAN

L<http://search.cpan.org/dist/Memoize-Class-Constructor/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Kenta Sato.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Memoize::Class::Constructor
