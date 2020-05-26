package Mojo::PubSub::Backend::mysql;
our $VERSION = '0.001';
# ABSTRACT: Backend module for using Mojo::mysql::PubSub with Mojo::PubSub

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SEE ALSO

L<Mojo::mysql::PubSub>, L<Mojo::PubSub>

=cut

use v5.14;
use Mojo::Base 'Mojo::EventEmitter';
use Scalar::Util qw( refaddr weaken );
use Mojo::JSON qw( to_json from_json );

=attr pubsub

The L<Mojo::mysql::PubSub> instance being used.

=cut

has pubsub => ;

#=attr _json_channels
#
# A hash of channels that should automatically encode/decode JSON.
# Mojo::mysql::PubSub does not support this, so we do it here.
#
#=cut
has _json_channels => sub { {} };

#=attr _cb_wrappers
#
# A hash of given callback refaddrs to the callback subref we gave to
# Mojo::mysql::PubSub (which properly handles to/from JSON)
#
#=cut
has _cb_wrappers => sub { {} };

sub json {
    my ( $self, $channel ) = @_;
    $self->_json_channels->{ $channel } = 1;
    return $self;
}
sub listen {
    my ( $self, $channel, $orig_cb ) = @_;
    my $wrapped_cb
        = $self->_cb_wrappers->{ refaddr $orig_cb }
        ||= sub {
            my ( $pubsub, $payload ) = @_;
            if ( $self->_json_channels->{ $channel } ) {
                $payload = from_json( $payload );
            }
            $orig_cb->( $pubsub, $payload );
        };
    return $self->pubsub->listen( $channel, $wrapped_cb );
}
sub unlisten {
    my ( $self, $channel, $orig_cb ) = @_;
    my $wrapped_cb = $self->_cb_wrappers->{ refaddr $orig_cb };
    $self->pubsub->unlisten( $channel, $wrapped_cb );
    return $self;
}
sub notify {
    return shift->pubsub->notify( @_ );
}

1;
