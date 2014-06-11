use strict;
use Test::More;
use App::revealup::cli::theme;
use Path::Tiny;

my $path = path('./t', 'output.css');

$path->remove();
ok !$path->exists();
App::revealup::cli::theme->run('generate', "--output", $path);
ok $path->exists();
$path->remove();

done_testing();
