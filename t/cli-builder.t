use strict;
use Test::More;
use App::revealup::builder;
use App::revealup::util;

my $test_dir = App::revealup::util::share_path([qw/t/]);
ok $test_dir;
ok $test_dir->is_dir();

my $builder = App::revealup::builder->new(
    filename => './t/test.md',
);
my $html = $builder->build_html();
ok $html;

my $png = App::revealup::util::path_to_res($test_dir->child('onion.png'));
ok $png;
my @meta = @{$png->[1]};
for my $k (@meta) {
    ok 'image/png' if $k eq 'Content-Type'
}

done_testing();
