
=head1 DESCRIPTION

This tests the L<Mojo::PubSub::Backend::mysql> module which uses L<Mojo::mysql::PubSub>.

Set the C<TEST_ONLINE_MYSQL> environment variable to a L<Mojo::mysql>
connect string to run this script.

To make a local MySQL server:

    # In another terminal
    $ mysqld --initialize --datadir=db
    $ mysqld --skip-grant-tables --datadir=db

    # In the current terminal
    $ mysqladmin create test
    $ export TEST_ONLINE_MYSQL=mysql://localhost/test

B<NOTE>: The only way to kill the MySQL from the other terminal is to
use C<kill(1)> from the first terminal.

=head1 SEE ALSO

L<Mojo::mysql>, L<Mojo::PubSub>

=cut

use Mojo::Base '-strict';
use Test::More;

BEGIN {
    eval { require Mojo::mysql; Mojo::mysql->VERSION( 1 ); 1 }
        or plan skip_all => 'Mojo::mysql >= 1.0 required for this test';
    plan skip_all => 'set TEST_ONLINE_MYSQL to enable this test'
        unless $ENV{TEST_ONLINE_MYSQL};
}

use Mojo::mysql;
my $mojodb = Mojo::mysql->new($ENV{TEST_ONLINE_MYSQL});




done_testing;
