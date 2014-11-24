package App::revealup::cli;
use App::revealup::base;

# For compatibility.
has 'command_map' => {
    server => 'serve',
    theme => 'export',
};

sub run {
    my ($self, @args) = @_;

    local @ARGV = @args;
    my @commands;
    push @commands, @ARGV;
    my $command = shift @commands;

    if($command) {
        my $new_command = $self->command_map->{$command};
        $command = $new_command if $new_command;
        my $klass = sprintf("App::revealup::cli::%s", lc($command));
        no warnings 'ambiguous';
        if(eval "require $klass;1;"){
            my $instance = $klass->new();
            $instance->run(@commands);
            return;
        }
    }
    system "perldoc App::revealup";
}

1;
