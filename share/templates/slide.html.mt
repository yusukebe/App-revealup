? my ($filename, $theme, $transition, $size) = @_;
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"
    />
    <link rel="stylesheet" href="revealjs/dist/reveal.css" />
    <? if($theme) { ?>
    <link rel="stylesheet" href="<?= $theme ?>" id="theme" />
    <? }else{ ?>
    <link rel="stylesheet" href="revealjs/dist/theme/black.css" id="theme" />
    <? } ?>
    <link rel="stylesheet" href="revealjs/plugin/highlight/zenburn.css" />
  </head>

  <body>
    <div class="reveal">
      <div class="slides">
        <section
          data-markdown="<?= $filename ?>"
          data-separator="^---"
          data-separator-vertical="^___"
          data-charset="utf-8"
          data-notes="^Note:"
        ></section>
      </div>
    </div>

    <script src="revealjs/dist/reveal.js"></script>
    <script src="revealjs/plugin/markdown/markdown.js"></script>
    <script src="revealjs/plugin/highlight/highlight.js"></script>
    <script src="revealjs/plugin/notes/notes.js"></script>

    <script>
      Reveal.initialize({
        width: <?= $size->{width} ?>,
        height: <?= $size->{height} ?>,
        controls: true,
        progress: true,
        history: true,
        center: true,
        plugins: [ RevealMarkdown, RevealHighlight, RevealNotes ],
        transition: '<?= $transition ?>'
      });
    </script>
  </body>
</html>
