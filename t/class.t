use strict;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib";
use Test;

my $test = Test->new(
    message => 'hello',
    hey => '',
);

ok $test;
isa_ok $test, 'Test';
is $test->foo, 10;
is $test->bar, 'bar';
is $test->method, '10bar';
is $test->message, 'hello';

done_testing;
