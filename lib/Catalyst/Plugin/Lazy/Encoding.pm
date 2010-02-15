package Catalyst::Plugin::Lazy::Encoding;

use Moose::Role;
use Carp ();
use 5.008003;
use Encode 2.21 qw/find_encoding/;
use Data::Recursive::Encode;
use namespace::autoclean;

our $VERSION = '0.01';

has _encoding => (
    is  => 'rw',
    isa => 'Any',
    default => sub { find_encoding 'utf8' },
    trigger => sub {
        $_[0]->{_encoding} = find_encoding $_[1] or die Carp::croak "Unknown encoding '$_[1]'";
    },
);

before setup_finalize => sub {
    my $c = shift;
    my $conf = $c->config;
    my $enc = exists $conf->{encoding} ? delete $conf->{encoding} : 'utf8';
    $conf->{encoding} = $enc;
};

before finalize => sub {
    my $c = shift;

    my $body = $c->res->body;
    return unless defined $body;
    
    # Only touch text-like contents
    return unless $c->res->content_type =~ /^text|xml$|javascript$/;
    
    $c->res->body( $c->encoding->encode($body) ) if ref \$body eq 'SCALAR';
};

after prepare_uploads => sub {
    my $c = shift;
    my $enc = $c->encoding;
    
    for my $key (qw/ parameters query_parameters body_parameters /) {
        $c->request->{$key} = Data::Recursive::Encode->decode($enc->name, $c->request->{$key});
    }
    for my $value (values %{$c->request->uploads}) {
        for (ref($value) eq 'ARRAY' ? @{$value} : $value) {
            $_->{filename} = $enc->decode($_->{filename});
        }
    }
};

no Moose::Role;
sub encoding {
    my $c = shift;
    my $enc = shift;
    return $c->_ecnoding($enc) if $enc;
    return $c->_encoding || $c->_encoding( $c->config->{encoding} );
}

1;
__END__

=head1 NAME

Catalyst::Plugin::Lazy::Encoding - auto decode request param and auto encode response body.

=head1 SYNOPSIS

  package MyApp;
  use Moose;
  use namespace::autoclean;
  
  use Catalyst::Runtime 5.80;
  
  use Catalyst qw/Lazy::Encoding/;
  
  extends 'Catalyst';
  
  __PACKAGE__->config(
      encoding => 'utf8', # default
  );
  
  __PACKAGE__->setup();
  
  1;

=head1 DESCRIPTION

Catalyst::Plugin::Lazy::Encoding is transparently encode/decode response/parameters.
Response body encoding and request parameters decoding.

=head1 METHOD

=over

=item finalize

Encodes body into encoding.

=item prepare_uploads

Decodes parameters, query_parameters, body_parameters and filenames in file uploads into a sequence of logical characters.

=item setup_flinalize

=item encofing

  $c->encoding( 'euc-jp' );

=back

=head1 AUTHOR

xaicron E<lt>xaicron {at} cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
