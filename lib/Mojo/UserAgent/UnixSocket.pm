package Mojo::UserAgent::UnixSocket;
use Carp 'carp';
use Mojo::Base 'Mojo::UserAgent';
use IO::Socket::UNIX;

our $VERSION = '1.0';

has 'unix_diversion';

sub _connect {
  my ($self, $loop, $peer, $tx, $handle, $cb) = @_;
  $handle //= IO::Socket::UNIX::Wrapper->new(Peer => $self->unix_diversion);
  $self->SUPER::_connect($loop, $peer, $tx, $handle, $cb);
}

package IO::Socket::UNIX::Wrapper;
use parent 'IO::Socket::UNIX';

sub sockhost { 'localhost' }
sub sockport { -1 }
sub peerhost { 'localhost' }
sub peerport { -1 }

1;

=encoding utf8

=head1 NAME

Mojo::UserAgent::UnixSocket - User Agent connections over UNIX sockets.

=head1 VERSION

0.01

=head1 SYNOPSIS

  use Mojo::UserAgent::UnixSocket;

  my $ua = Mojo::UserAgent::UnixSocket->new;
  say $ua->get('unix:///var/run/docker.sock/images/json?all=true')->res->body;

=head1 DESCRIPTION

L<Mojo::UserAgent::UnixSocket> transparently enables L<Mojo::UserAgent> to interact with services listening on Unix domain sockets.

Any invocation that works with L<Mojo::UserAgent> should also work here.

It expects URLs in the following format (the .sock is required, pending a clever patch):

  unix://<path-to-socket>.sock/<url-path>

For example, talking to the L<Docker|http:www.//docker.io/> daemon, whose socket is (typically) located at C</var/run/docker.sock>:

  unix:///var/run/docker.sock/images/nginx/json

=head1 SEE ALSO

L<HTTP::Tiny::UNIX>, L<Mojo::UserAgent>

=cut

