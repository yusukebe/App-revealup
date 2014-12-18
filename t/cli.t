use strict;
use Test::More;
use Test::TCP;
use Test::File::Contents qw/file_contents_eq/;
use Capture::Tiny qw/capture_merged/;
use LWP::UserAgent;
use FindBin;
use File::chdir;
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
        local $CWD = $FindBin::Bin;
        $cli->run('serve', 'test.md', '--port', $port);
    },
    client => sub {
        my $port = shift;
        my $ua = LWP::UserAgent->new();
        my $res = $ua->get("http://localhost:$port");
        is $res->code, 200;
        is $res->content_type, 'text/html';

        # test.bmp contains 0x0d 0x0a (CRLF)
        $res = $ua->get("http://localhost:$port/test.bmp");
        is $res->code, 200;
        is $res->content_type, 'image/x-bmp';
        is $res->content_length, 122;

        # diag sprintf("%*v02x\n", " ", $res->content);
        file_contents_eq 't/test.bmp', $res->content, { encoding => ':unix' }, 'No EOL conversion for binary file';
    },
);

done_testing();
