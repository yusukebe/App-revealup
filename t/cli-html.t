use strict;
use warnings;
use Test::More;
use App::revealup::cli;
use Path::Tiny;

my $md = path('./t', 'test.md');
my $path = path('./t', 'output.html');
$path->remove();
ok !$path->exists();
my $cli = App::revealup::cli->new();
$cli->run("export", "html", $md, "--output", $path);
ok $path->exists();
like $path->slurp, qr!t/test\.md!;
$path->remove();

done_testing;
