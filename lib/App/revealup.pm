package App::revealup;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.14";

1;
__END__

=encoding utf-8

=head1 NAME

App::revealup - HTTP Server app for viewing Markdown texts as slides

=head1 SYNOPSIS

    $ revealup server slide.md --port 5000

=head1 DESCRIPTION

App::revealup is a web application module to showing Markdown with reveal.js. Markdown texts will be like a slide show if you use this revealup command.

=head2 Sample Markdown

    ## This is Title
    
    Description... The horizontal slide separator characters are '---'
    
    ---
    
    ## This is second title
    
    The vertical slide separator characters are '___'
    
    ___
    
    ## This is a third title

    ---

    ## This is a forth title
    <!-- .slide: data-background="#f70000" data-transition="page" -->
    
    You can add slide attributes like above.


=head1 COMMANDS

=over 4

=item L<App::revealup::cli::server>

=item L<App::revealup::cli::theme>

=back

=head1 LICENSE

Copyright (C) Yusuke Wada.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 reveal.js

reveal.js is by Hakim El Hattab, L<http://hakim.se>.

L<https://github.com/hakimel/reveal.js/>

=head1 AUTHOR

Yusuke Wada E<lt>yusuke@kamawada.comE<gt>

=cut
