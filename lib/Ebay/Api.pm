package Ebay::Api;

use strict;
use warnings;
use utf8;

use Carp 'croak';
use LWP::UserAgent;
use URI::Encode;
use LWP::ConsoleLogger::Everywhere ();

# List of endpoints url
# 0 - sandbox
# 1 - production
my $ENDPOINT = {
        'get_application_token'  =>  [
            'https://api.sandbox.ebay.com/identity/v1/oauth2/token',
            'https://api.ebay.com/identity/v1/oauth2/token',
        ],
};

my $STAGE = $ENV{'STAGE'} ? lc ($ENV{'STAGE'}) : 'sandbox';

sub new {
    my ($class, %opt) = @_;
    my $self = {};
    $self->{'client_id'}            = $opt{'-client_id'}         // croak "You must specify '-client_id' param";
    $self->{'client_secret'}        = $opt{'-client_secret'}     // croak "You must specify '-client_secret' param";
    $self->{'endpoint'}             = $ENDPOINT;
    $self->{'ua'}                   = LWP::UserAgent->new(
        'agent'         => "Ebay bidder perl",
    );

    bless $self, $class;
    return $self;
}

sub __get_endpoint {
    my ($self, %opt) = @_;
    my $func;
    if ($opt{'-caller'}) {
        $func = $opt{'-caller'};
    }
    else {
        $func = (caller(1))[3];
        $func =~ s/^.+:://;
    }

    my $endpoint = $self->{'endpoint'}->{$func} // croak "Can't get endpoint for func '$func'";
    return $STAGE eq 'sandbox' ? $endpoint->[0] : $endpoint->[1];
}

sub __get_scopes_str {
    my ($self, $scopes) = @_;
    ref($scopes) eq 'ARRAY' or croak "Param scopes must be reference to ARRAY";
    return URI::Encode->new({encode_reserved => 1})->encode( join(' ', @$scopes) );
}

1;
