use strict;
use Test::More;
use Test::Fatal;
use App::revealup::cli::serve;

my $test_dir = App::revealup::cli::serve->share_path([qw/t/]);
ok $test_dir;
ok $test_dir->is_dir();

my $html = App::revealup::cli::serve->render($test_dir->child('test.md'));
ok $html;

done_testing();
