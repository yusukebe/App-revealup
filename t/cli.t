use strict;
use Test::More;
use Test::Fatal;
use App::revealup::cli;

my $cli = App::revealup::cli->new();
ok $cli;
ok !exception { $cli->run(qw/serve test.md --dry-run/) };
ok exception { $cli->run(qw/not-available-method --dry-run/) };

done_testing();
