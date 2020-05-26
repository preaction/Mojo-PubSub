package Mojo::PubSub::Backend::Pg;
our $VERSION = '0.001';
# ABSTRACT: Backend module for using Mojo::Pg::PubSub with Mojo::PubSub

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SEE ALSO

L<Mojo::Pg::PubSub>, L<Mojo::PubSub>

=cut

use v5.14;
use Mojo::Base 'Mojo::EventEmitter';

=attr pubsub

The L<Mojo::Pg::PubSub> instance being used.

=cut

has pubsub => ;

sub json {
    return shift->pubsub->json( @_ );
}
sub listen {
    return shift->pubsub->listen( @_ );
}
sub unlisten {
    return shift->pubsub->unlisten( @_ );
}
sub notify {
    return shift->pubsub->notify( @_ );
}

1;
