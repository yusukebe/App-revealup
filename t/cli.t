use strict;
use Test::More;
use Test::TCP;
use Capture::Tiny qw/capture/;
use LWP::UserAgent;
use FindBin;
use App::revealup::cli;

my $cli = App::revealup::cli->new();
ok $cli;

subtest 'no arguments' => sub {
    my ($stdout, $stderr, $exit) = capture { $cli->run('') };
    ok $stdout;
};

subtest 'command not found' => sub {
    my ($stdout, $stderr, $exit) = capture { $cli->run('command_not_found') };
    ok $stdout;
};

test_tcp(
    server => sub {
        my $port = shift;
        $cli->run('server', "$FindBin::Bin/test.md", '--port', $port);
        exit;
    },
    client => sub {
        my $port = shift;
        my $ua = LWP::UserAgent->new();
        my $res = $ua->get("http://localhost:$port");
        is $res->code, 200;
        is $res->content_type, 'text/html';
    }
);

done_testing();
