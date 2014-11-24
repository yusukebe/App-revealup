use strict;
use warnings;
use Test::More;
use App::revealup::cli;
use Path::Tiny;

subtest 'basic' => sub {
    my $path = path('./t', 'output.css');
    $path->remove();
    ok !$path->exists();
    my $cli = App::revealup::cli->new();
    $cli->run("export", "theme", "--output", $path);
    ok $path->exists();
    $path->remove();
};

subtest 'for compatibility' => sub {
    my $path = path('./t', 'output.css');
    $path->remove();
    ok !$path->exists();
    my $cli = App::revealup::cli->new();
    $cli->run("theme", "generate", "--output", $path);
    ok $path->exists();
    $path->remove();
};

done_testing();
