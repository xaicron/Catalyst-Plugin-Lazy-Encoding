package TestApp::Controller::Root;
use utf8;
use Encode qw/encode_utf8 decode_utf8/;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->res->body('it works');
    $c->res->content_type($self->content_type);
}

sub utf8 :Local {
    my ($self, $c) = @_;
    my $data = 'ほげ';
    $c->res->body($data);
    $c->res->content_type($self->content_type);
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

#sub end : ActionClass('RenderView') {}

sub content_type {
    return 'text/plain; charset=UTF-8';
}

__PACKAGE__->meta->make_immutable;

1;
