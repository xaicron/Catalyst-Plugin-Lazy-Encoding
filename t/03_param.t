use strict;
use warnings;
use utf8;
use URI::Escape qw/uri_escape/;
use Encode;
use HTTP::Request::Common qw/GET POST/;
use FindBin qw/$Bin/;
use lib "$Bin/lib";
use Catalyst::Test 'TestApp';
use Test::More;

my $decode_str = 'ほげ';
my $encode_str = encode_utf8 $decode_str;
my $escape_str = uri_escape $encode_str;

check_parameter(GET "/?foo=$escape_str");
check_parameter(POST '/', ['foo' => $encode_str]);
check_parameter(POST '/',
    Content_Type => 'form-data',
    Content => [
        'foo' => [
            "$Bin/03_param.t",
            $encode_str,
        ]
    ],
);

sub check_parameter {
    my ( undef, $c ) = ctx_request(shift);
    is $c->res->output => 'it works';

    my $foo = $c->req->param('foo');
    ok utf8::is_utf8($foo);
    is $foo => $decode_str;

    my $other_foo = $c->req->method eq 'POST'
        ? $c->req->upload('foo')
            ? $c->req->upload('foo')->filename
            : $c->req->body_parameters->{foo}
        : $c->req->query_parameters->{foo};
    ok utf8::is_utf8($other_foo);
    is $other_foo => $decode_str;
}

done_testing;
