package Ebay::Api::OAuth;

use strict;
use warnings;
use utf8;

use MIME::Base64 qw/encode_base64/;
use JSON::XS qw/decode_json/;
use Carp 'croak';

use base qw/Ebay::Api/;

sub get_application_token {
    my ($self, %opt) = @_;
    ref($opt{'-scopes'}) eq 'ARRAY' or croak "You must specify param '-scopes' as arrayref";

    my $res = $self->{ua}->post($self->__get_endpoint(),
        %{$self->__generate_request_headers()},
        'Content'   => 'grant_type=client_credentials&scope=' . $self->__get_scopes_str($opt{'-scopes'}),
    );
    croak "Can't get_application_code. Code: '" . $res->code . "' Response: '" . $res->decoded_content . "'" if $res->code ne '200';
    my $json = eval {decode_json($res->decoded_content)};
    return $json;
}

sub __generate_request_headers {
    my ($self) = @_;
    my %headers = (
        'Content-Type'      => 'application/x-www-form-urlencoded',
        'Authorization'     => 'Basic ' . encode_base64(join(':', $self->{'client_id'}, $self->{'client_secret'}), ''),
    );
    return \%headers;
}

1;
