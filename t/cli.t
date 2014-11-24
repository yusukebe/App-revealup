use strict;
use Test::More;
use Test::TCP;
use Capture::Tiny qw/capture_merged/;
use LWP::UserAgent;
use FindBin;
use App::revealup::cli;

my $cli = App::revealup::cli->new();
ok $cli;

subtest 'no arguments' => sub {
    my ($merged, @result) = capture_merged { $cli->run() };
    ok $merged;
};

subtest 'command not found' => sub {
    my ($merged, @result) = capture_merged { $cli->run('command_not_found') };
    ok $merged;
};

test_tcp(
    server => sub {
        my $port = shift;
        $cli->run('serve', "$FindBin::Bin/test.md", '--port', $port);
    },
    client => sub {
        my $port = shift;
        my $ua = LWP::UserAgent->new();
        my $res = $ua->get("http://localhost:$port");
        is $res->code, 200;
        is $res->content_type, 'text/html';
    },
);

done_testing();
