package App::revealup;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.15";

1;
__END__

=encoding utf-8

=head1 NAME

App::revealup - HTTP Server app for viewing Markdown texts as slides

=head1 SYNOPSIS

    $ revealup serve slide.md --port 5000

=head1 DESCRIPTION

B<App::revealup> is package of web application modules and a command to showing Markdown with B<reveal.js>. Markdown texts will be like slide shows if you use this C<revealup> command.

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

    Note:
    This is a speaker note. It can be viewed in the speaker mode, just press S during the presentation to view notes and other useful information.

=head1 COMMANDS

=over

=item C<serve>

    $ revealup serve markdown.md --theme night.css

C<serve> command launch the HTTP server for the showing slides on your web browser.

SEE MORE: L<App::revealup::cli::serve>

=item C<export>

    $ revealup export theme --base beige.css --output style.css

C<export> command generate the file such as a CSS for theme and a HTML for the slides.

SEE MORE: L<App::revealup::cli::export>

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
