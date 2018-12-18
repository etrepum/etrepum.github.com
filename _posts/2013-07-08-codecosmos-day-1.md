---
categories:
- javascript
- teaching
- processingjs
- education
title: Why I made CodeCosmos
redirect_from:
- /javascript/teaching/processingjs/education/archives/2013/07/08/codecosmos-day-1
tags:
- javascript
- teaching
- processingjs
- processing
- education
---
I never really thought much about my career until recently. From my first internship at [Bethesda Softworks] in 1997 to my short tenure at [Facebook] in 2012 I basically just followed my interests and made changes whenever I was no longer passionate about what I was doing.

This optimization strategy served me very well, but I ended up at a local maxima. I'm very fortunate to have seen such success with [Mochi Media], but now that I'm choosing from the set of all jobs that I'm interested in and physically capable of, it's hard to even think about how to evaluate such a decision. For the past few months I've been enjoying my roles as "startup advisor" and "thinking about what to do next as an entrepreneur". Neither of which pay very well, but that's not what I'm optimizing for anymore.

The "mission statement" I've been working with is that I should leverage my opportunity to do something that is of obvious social value. The vague hypothesis I started with is that there gaps in education where software on today's platforms could help. This of course is [not at all a new idea], but I believe that there are new opportunities due to order of magnitude improvements in network connectivity, performance, and the price of suitable devices. It's also very much aligned with some of my personal interests; I enjoy building things almost as much as I love to learn.

Current web technologies make application development much easier than it used to be (whether using a browser or just embedding an engine). HTML5 APIs such as [Application Cache], [Web Workers], and [Cross-origin Resource Sharing] make it possible to quickly build client side apps that rely very little on high quality and reliable connectivity, I think this is especially important for most of the world and universally true for mobile. I taught my first class today in a school where the internet wasn't working (and no cell phone signal to get a hotspot working). If I had decided to base my course on tools from [Codecademy] or [Khan Academy], I would've failed miserably. My opinion of [Khan Academy] might change when they open source their CS tool, but that hasn't happened yet (["should be soon"], where soon is redefined as "some period of time greater than 11 months". Nearly everything is mutable in JavaScript). Even if the network was up, the school blocks YouTube so a lot of the MOOC stuff isn't going to work here anyway.

My first proof of concept is a web based JavaScript (leveraging [Processing.js]) coding environment designed for classroom use. I started teaching a week long coding course with it today, to high school students enrolled in [The College Initiative]'s non-profit summer college prep program in Marianna, Arkansas (a [very small town]). I realize that it's quite risky to try doing this from scratch with a new tool, especially without any prior teaching experience. Whether this works out well or it doesn't I expect to learn far more than the students from this experiment! I've already learned much about the current state of HTML and JavaScript open source in building this tool. I'm pretty excited about what's finally possible without having to install anything beyond a browser.

Feel free to poke around on [CodeCosmos.com] and let me know what you think. If you make something cool, you can click to publish it as a [gist] that is viewable on [bl.ocks.org]. Everything should work on Google Chrome, and might work on some other browsers, but the lab here is all Chrome so that's all I've tested so far. All of the code is up at [github.com/CodeCosmos]. I'm not at all very proud of the code, it's essentially a throw-away prototype that I'm going to refactor into something that makes more sense (and has docs, tests, robust network calls, supervised backend, etc.). There are also a number of features on my list that I'd like to implement or polish. I'll talk a bit about the architecture and the decision making process in a follow-up post. (EDIT: that post is [How I built CodeCosmos]. See also [Teaching with CodeCosmos]).

I'd like to thank my wife Margaret Ippolito ([@elektradarling]), Cat Crumpler ([@catcrumpler]; and everyone else at [The College Initiative]), Amit Pitaru ([@pitaru]), Mark Sawula ([@p5k12]), Tim Corica ([@tcorica]), Danielle Fong ([@DanielleFong]), and Bret Victor ([@worrydream]) for all personally taking the time to provide the advice and inspiration I needed to make this happen.

[Bethesda Softworks]: http://www.bethsoft.com/
[Facebook]: http://www.facebook.com/
[Mochi Media]: http://www.mochimedia.com/
[not at all a new idea]: http://en.wikipedia.org/wiki/Logo_(programming_language)#History
["should be soon"]: http://ejohn.org/blog/introducing-khan-cs/
[Processing.js]: http://processingjs.org/
[Application Cache]: http://appcachefacts.info/
[Web Workers]: http://www.whatwg.org/specs/web-apps/current-work/multipage/workers.html
[Cross-origin Resource Sharing]: http://enable-cors.org/
[Codecademy]: http://www.codecademy.com/
[Khan Academy]: http://www.khanacademy.org/
[CodeCosmos.com]: http://codecosmos.com/
[gist]: https://gist.github.com/
[github.com/CodeCosmos]: https://github.com/CodeCosmos/
[bl.ocks.org]: http://bl.ocks.org/
[The College Initiative]: http://www.thecollegeinitiative.org/
[very small town]: http://en.wikipedia.org/wiki/Marianna,_Arkansas#Demographics
[@elektradarling]: https://twitter.com/elektradarling
[@pitaru]: https://twitter.com/pitaru
[@p5k12]: https://twitter.com/p5k12
[@tcorica]: https://twitter.com/tcorica
[@worrydream]: https://twitter.com/worrydream
[@catcrumpler]: https://twitter.com/catcrumpler
[@DanielleFong]: https://twitter.com/DanielleFong
[How I built CodeCosmos]: /archives/2013/07/18/codecosmos-tech/
[Teaching with CodeCosmos]: /archives/2013/07/24/teaching-with-codecosmos/
