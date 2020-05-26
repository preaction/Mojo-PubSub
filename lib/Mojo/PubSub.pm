package Mojo::PubSub;
our $VERSION = '0.001';
# ABSTRACT: Compatibility layer for PubSub systems in Mojo modules

=head1 SYNOPSIS

    # Use Postgres to handle pub/sub for a Mojo::mysql connection
    my $pubsub = Mojo::PubSub->new( Pg => 'postgresql://postgres@/test' );
    my $db = Mojo::mysql->new( 'mysql://username@/test' );
    $db->pubsub( $pubsub );

    $db->pubsub->listen( 'updates', sub {
        my ( $pubsub, $payload ) = @_;
        say "Got an update: " . $payload;
    } );
    $db->pubsub->notify( updates => 'Updated table <users>' );
    # "Got an update: Updated table <users>"

=head1 DESCRIPTION

=head2 Supported Backends

These modules are the actual messaging modules that handle the publish/subscribe
pattern.

=over

=item L<Mojo::Pg::PubSub> - L<Mojo::PubSub::Backend::Pg>

    my $pubsub = Mojo::PubSub->new( Pg => 'postgresql://postgres@/test' );
    my $pubsub = Mojo::PubSub->new( Pg => Mojo::Pg->new( ... ) );

=item L<Mojo::mysql::PubSub> - L<Mojo::PubSub::Backend::mysql>

    my $pubsub = Mojo::PubSub->new( mysql => 'mysql://username@/test' );
    my $pubsub = Mojo::PubSub->new( mysql => Mojo::mysql->new( ... ) );

=back

=head2 Supported Frontends

This module (C<Mojo::PubSub>) is a compatibility interface and
implements the methods needed to work with these frontend objects.

=over

=item L<Mojo::Pg>

    my $db = Mojo::Pg->new( ... );
    $db->pubsub( $pubsub );

=item L<Mojo::mysql>

    my $db = Mojo::mysql->new( ... );
    $db->pubsub( $pubsub );

=back

If future frontend modules require different APIs, roles can be added to
this module to support them.

=head1 SEE ALSO

=cut

use v5.14;
use Mojo::Base 'Mojo::EventEmitter';

=attr backend

The L<Mojo::PubSub::Backend> subclass that is handling this instance.

=cut

has backend => ;

=method json

Active automatic JSON encoding and decoding with L<Mojo::JSON/to_json>
and L<Mojo::JSON/from_json> for a channel.

=cut

sub json {
    #my ( $self, $channel ) = @_;
    my $self = shift;
    $self->backend->json( @_ );
    return $self;
}

=method listen

Subscribe to a channel. Automatic decoding of JSON text to Perl values can be
activated with L</json>.

=cut

sub listen {
    #my ( $self, $channel, $cb ) = @_;
    shift->backend->listen( @_ );
    return $_[-1];
}

=method unlisten

Unsubscribe from a channel.

=cut

sub unlisten {
    #my ( $self, $channel, $cb ) = @_;
    my $self = shift;
    $self->backend->unlisten( @_ );
    return $self;
}

=method notify

Send a message to a channel. Automatic encoding of Perl values to JSON text can be
activated with L</json>.

=cut

sub notify {
    #my ( $self, $channel, $data ) = @_;
    my $self = shift;
    $self->backend->notify( @_ );
    return $self;
}

1;

