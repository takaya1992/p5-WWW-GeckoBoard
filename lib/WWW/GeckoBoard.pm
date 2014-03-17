package WWW::GeckoBoard;
use 5.008005;
use strict;
use warnings;

use HTTP::Headers;
use HTTP::Request;
use LWP::UserAgent;
use JSON::XS;
use Data::Dumper;

use parent qw/Class::Accessor::Fast/;
use constant {
    BASE_URL  => 'https://push.geckoboard.com/v1/send'
};
our $VERSION = "0.01";

__PACKAGE__->mk_accessors(qw/
    api_key
/);

sub call {
    my ($self, $widget_key, $data) = @_;

    my $body = {
        api_key => $self->api_key,
        data    => $data
    };

    my $request = HTTP::Request->new(
        'POST',
        BASE_URL .'/'. $widget_key,
        HTTP::Headers->new(
            'Content_Type' => 'application/json'
        ),
        encode_json($body)
    );
    my $response = LWP::UserAgent->new()->request($request);

    my $result = eval{decode_json($response->content);};
    warn $@ if ($@);
    return $result;
}

sub number_and_secondary_value {
    my ($self, @args) = @_;
    my $options = ref $args[0] eq 'HASH' ? \%{$args[0]} : {@args};
    my $data = {
        item => [{
            value => $options->{value}
        }]
    };
    $data->{item}[0]{text}     = $options->{text} if (defined $options->{text});
    $data->{item}[0]{absolute} = $options->{absolute} if (defined $options->{absolute});
    $data->{item}[0]{type}     = $options->{type} if (defined $options->{type});
    $data->{item}[0]{prefix}   = $options->{prefix} if (defined $options->{prefix});
    $data->{item}[1]           = $options->{secondary_value} if (defined $options->{secondary_value});
    my $result = $self->call($options->{widget_key}, $data);
    return $result;
}


1;
__END__

=encoding utf-8

=head1 NAME

WWW::GeckoBoard - It's new $module

=head1 SYNOPSIS

    use WWW::GeckoBoard;

=head1 DESCRIPTION

WWW::GeckoBoard is 

=head1 LICENSE

Copyright (C) Takaya Arikawa.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takaya Arikawa E<lt>tky.c10ver@gmail.comE<gt>

=cut

