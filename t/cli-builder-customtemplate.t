use strict;
use Test::More;
use App::revealup::builder;
use App::revealup::util;

my $test_dir = App::revealup::util::share_path([qw/t/]);
ok $test_dir;
ok $test_dir->is_dir();

my $builder = App::revealup::builder->new(
    template => './t/test.html.mt',
    filename => './t/test.md',
);
my $html = $builder->build_html();

like $html, qr|CUSTOM TEMPLATE:\n./t/test.md|;

done_testing();
