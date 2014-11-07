use strict;
use Test::More;
use App::revealup::cli::server;
use App::revealup::util;

my $test_dir = App::revealup::util::share_path([qw/t/]);
ok $test_dir;
ok $test_dir->is_dir();

my $html = App::revealup::cli::server->render($test_dir->child('test.md'));
ok $html;

my $png = App::revealup::util::path_to_res($test_dir->child('onion.png'));
ok $png;
my @meta = @{$png->[1]};
for my $k (@meta) {
    ok 'image/png' if $k eq 'Content-Type'
}

done_testing();
