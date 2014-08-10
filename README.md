This is the source for bob.ippoli.to!

I use [Jekyll] to help us generate bob.ippoli.to because that's
what [GitHub Pages] uses. This lets us build a site with a lot of
pages without having to repeat so much over and over.

It uses the following JavaScript, CSS, and font libraries to make the
site work well and look good:
* [jQuery]
* [SyntaxHighlighter]
* [Jekyll Bootstrap] - although this is mostly vestigial

The site depends on the following third party services:
* [Disqus] - for comments
* [Google Analytics]

# Setup

Install [Jekyll] by opening Terminal and typing the following command:

```bash
gem install jekyll
```

# HACKING

Open a Terminal and change to the directory where you've checked out
`etrepum.github.com`, then run this command to start the [Jekyll]
preview server:

```bash
jekyll serve --watch --safe
```

This will run a webserver on your computer at http://127.0.0.1:4000/
and automatically rebuild the site when you make changes to the files.
You will have to reload the pages in your browser to see the changes.

# Creating a post

To write a post, create a file in `_posts/` with
the naming scheme `YYYY-MM-DD-title.{html,md}` with the appropriate
[YAML Front Matter]. A small example post would look like this:

*2014-08-10-minimal-post.md*
```markdown
---
categories: [example]
tags: [example]
title: Minimal post example
---
This is a minimal post.
```

[Jekyll]: http://jekyllrb.com/
[GitHub Pages]: https://pages.github.com/
[jQuery]: http://jquery.com/
[SyntaxHighlighter]: http://alexgorbatchev.com/SyntaxHighlighter/
[Jekyll Bootstrap]: http://jekyllbootstrap.com/
[YAML Front Matter]: http://jekyllrb.com/docs/frontmatter/
[Disqus]: https://disqus.com/
[Google Analytics]: http://www.google.com/analytics/
