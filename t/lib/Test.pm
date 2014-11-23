package Test;
use App::revealup::base;

has 'foo' => 10;
has 'bar' => 'bar';

sub method {
    my $self = shift;
    return $self->foo . $self->bar;
}

1;
