package App::revealup::cli;
use strict;
use warnings;
use Try::Tiny;
use Pod::Usage;
use App::revealup::cli::serve;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self;
}

sub run {
    my ($self, @args) = @_;

    local @ARGV = @args;
    my @commands;
    push @commands, @ARGV;
    my $command = shift @commands;

    if($command) {
        my $klass = sprintf("App::revealup::cli::%s", lc($command));
        no warnings 'ambiguous';
        if(eval "require $klass;1;"){
            $klass->run(@commands);
        }
    }
    system "perldoc App::revealup";
}

1;
