use strict;
use warnings;
use Test::Base;
BEGIN {
    eval q[use Sledge::TestPages;];
    plan skip_all => "Sledge::TestPages required for testing base" if $@;
};
use t::TestPages;

plan tests => 1*blocks;

run {
    my $block = shift;

    $ENV{HTTP_USER_AGENT} = $block->input;

    no strict 'refs';
    local *{"t::TestPages::dispatch_test"} = sub { ## no critic
        my $self = shift;

        is($self->session->session_id, $block->expected);
    };

    my $pages = t::TestPages->new;
    $pages->dispatch('test');
};

__END__
=== agent is pc (use cookie)
--- input chomp
Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)
--- expected chomp
SID_COOKIE
=== agent is mobile (use query)
--- input chomp
KDDI-HI31 UP.Browser/6.2.0.5 (GUI) MMP/2.0
--- expected chomp
SID_STICKY_QUERY
