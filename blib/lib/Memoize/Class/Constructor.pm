package Memoize::Class::Constructor;

use common::sense;
use JSON::Any qw(XS DWIW Syck JSON);

sub keygen{ JSON::Any->objToJson(@_); }

=head1 NAME
    
Memoize::Class::Constructor - aaaa

=cut

=head1 VERSION

Version 0.01

=cut

use version;
our $VERSION = qv('0.01');

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Memoize::Class::Constructor;

    my $foo = Memoize::Class::Constructor->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 instance
    
    
    
=cut

my %_instance = (); 

sub new{
    my $key = keygen(\@_); 
    
    $_instance{$key} // ($_instance{$key} = shift->SUPER::new(@_)); 
}

=head2 has_instance
    
    
    
=cut

sub has_instance { 
    defined $_instance{keygen(\@_)};
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
