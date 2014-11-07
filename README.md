[![Build Status](https://travis-ci.org/yusukebe/App-revealup.svg?branch=master)](https://travis-ci.org/yusukebe/App-revealup)
# NAME

App::revealup - HTTP Server app for viewing Markdown texts as slides

# SYNOPSIS

    $ revealup server slide.md --port 5000

# DESCRIPTION

App::revealup is a web application module to showing Markdown with reveal.js. Markdown texts will be like a slide show if you use this revealup command.

## Sample Markdown

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

# COMMANDS

- [App::revealup::cli::server](https://metacpan.org/pod/App::revealup::cli::server)
- [App::revealup::cli::theme](https://metacpan.org/pod/App::revealup::cli::theme)

# LICENSE

Copyright (C) Yusuke Wada.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# reveal.js

reveal.js is by Hakim El Hattab, [http://hakim.se](http://hakim.se).

[https://github.com/hakimel/reveal.js/](https://github.com/hakimel/reveal.js/)

# AUTHOR

Yusuke Wada <yusuke@kamawada.com>
