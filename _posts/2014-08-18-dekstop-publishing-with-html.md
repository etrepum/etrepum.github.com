---
categories: [javascript, haskell, missionbit]
tags: [javascript, haskell, missionbit]
title: Desktop Publishing with HTML
---

A convenient hack I've been using for the past few years is to leverage
web development tools for desktop publishing. Maybe there's some expensive
and/or clunky software that can do these sorts of tasks well… but nothing I've
found does a great job when you have to create a template that's rendered
in a few different ways from data. I've done this sort of thing a handful of
times recently for [Mission Bit] as we often print documents such as thank you
letters and labels.

[CSS] allows you to precisely define the layout of the document. It's a bit
awkward, but it works. I've had good luck with using [flexbox] for layout.
You'll want to use [page-break-after] and/or [page-break-inside] to control
where the page breaks should or should not be. No need to worry too much about
standards here, just make it work for you in the browser that you intend to
use.

[SVG] provides for great print-quality graphics, whether you're generating
a bar code for an asset tag programmatically or simply including a nice logo.

You can use anything you want, even "server-side" code, to generate the
HTML for display. As long as you can render it in a browser, even a headless
one such as [wkhtmltopdf], you can print it. I've even used Haskell for this
([laptop-labels] generates our asset tags), but typically in-browser
Javascript is good enough for my needs. [d3] in particular has great
functionality out of the box for dealing with the [CSV] formatted data that is
easy to export from a spreadsheet or database. 

I don't have any code in particular to share here, but that's the point.
The only code you have to write is specific to generating your document.
You don't need a massive CSS dependency to bootstrap getting something printed
on a page. Next time you have to print something out, see if you can reproduce
it in vanilla HTML rather than mucking about with Google Docs, Word, or Pages.
I've certainly found it to be a lot more sane this way.

[Mission Bit]: http://www.missionbit.com/
[flexbox]: https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Flexible_boxes
[d3]: http://d3js.org/
[wkhtmltopdf]: http://wkhtmltopdf.org/
[SVG]: https://developer.mozilla.org/en-US/docs/Web/SVG
[CSS]: https://developer.mozilla.org/en-US/docs/Web/CSS
[CSV]: https://github.com/mbostock/d3/wiki/CSV
[page-break-after]: https://developer.mozilla.org/en-US/docs/Web/CSS/page-break-after
[page-break-inside]: https://developer.mozilla.org/en-US/docs/Web/CSS/page-break-inside
[laptop-labels]: https://github.com/MissionBit/laptop-labels/blob/master/Labels.hs
