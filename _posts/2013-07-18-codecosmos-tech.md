---
categories:
- javascript
- teaching
- processingjs
- education
title: How I built CodeCosmos
redirect_from:
- /javascript/teaching/processingjs/education/archives/2013/07/18/codecosmos-tech
tags:
- javascript
- teaching
- processingjs
- processing
- education
---
This is the continuation to [Why I made CodeCosmos]. If you're interested
in why I bothered to do this in the first place, start there. This
post is just about the software itself, there's more about how I used
it to teach a class in [Teaching with CodeCosmos].

[Why I made CodeCosmos]: /archives/2013/07/08/codecosmos-day-1/
[Teaching with CodeCosmos]: /archives/2013/07/24/teaching-with-codecosmos/

<abbr title="too long; didn't read">TL;DR</abbr>: this is the open
source "stack" I used to build the first version of CodeCosmos. I've
left out a few things that are in the code but were not actually used
in the course. I may decide to elaborate further on some of these
areas in future posts, but probably not until after I get around to
refactoring some of the code.

<style scoped>ul li em a { font-weight: bold; }</style>
* *[Planning](#planning)*
* *[Editing](#editing)*: [CodeMirror], [JSHint]
* *[Sandbox](#sandbox)*: [Processing.js], [Esprima], [Estraverse], [Escodegen]
* *[Web app](#web)*: [AngularJS], [Font.js], [jQuery], [JSZipTools], [Underscore]
* *[Persistence](#persistence)*: [PouchDB], [CouchDB], [follow], [request], [node-static]
* *[Hosting](#hosting)*: My laptop, [Github Pages], [Iris Couch], [nodejitsu]
* *[Build tools](#build)*: [Grunt]&#32;(with a few grunt-contrib tasks), [Bower]
* *[CSS and Fonts](#css)*: [Pure], [Font Awesome], [Kontrapunkt Bold], [Source Code Pro], [Ubuntu Regular]
* *[Post-mortem](#postmortem)*

<a id="planning" name="planning"></a>
# Planning

When I set out to teach the programming class at [The College Initiative],
I thought I'd be spending most of my time figuring out how to write a
lesson plan and then just executing on that. I was wrong. After evaluating
all of the free to use browser based learning platforms for programming
that I could find, I was unable to find one that suited my needs.

I was looking for:

* A decent browser based code editor with live linting.
* I wanted to use a pragmatic programming language, not something like [Scratch].
  My students are old enough to work, I want them to try a language that they
  might see in the workplace. I'd make an exception for a better teaching
  language for Computer Science. Maybe a [Scheme] dialect that transpiles cleanly
  to JavaScript. Especially if it could give smarter error messages given some
  type inference. If such a language exists, I was unable to find it.
* [Processing.js] support or something very much like it. I wanted the course
  to be visual, interactive, and more project based than lesson based. I think
  that "Hello World" is only exciting for students that are already genuinely
  interested in programming. I had a class full of students whose primary
  interest was getting into college. This was not a
  <abbr title="Science, Technology, Engineering, and Mathematics">STEM</abbr>
  program.
* Some robustness in the face of connectivity issues, which definitely
  rules out anything that relies heavily on streaming video.
* Persistence, both offline and online.
* The ability to detect scenarios such as infinite loops and return control to
  the editor. Doesn't have to be 100% reliable, but should work well.
* As little backend as possible if I had to modify it and run it myself.
* Chrome support. I knew the lab was going to have Chrome, and I use Chrome
  as my primary browser. Cross-browser support can come later.

What I found:

* [CodeHS] - Too many hoops to jump through to get access to their free pilot.
  Didn't evaluate.
* [Codecademy] - Decent JavaScript platform. The biggest problem here is that they
  basically just run the code as-is, with no watchdog-like functionality to catch
  infinite loops. No promise of an open source version for on-premise support.
* [Khan Academy] - Nice JavaScript platform, but it's not yet possible for third
  parties to develop CS lessons. Their CS program isn't open source yet (despite
  being live for nearly a year), so I couldn't simply fix it to suit my needs.
* [repl.it] - OK JavaScript platform. I would've had to write a lot of code to make
  it possible to use something like Processing.js from a Web Worker. The sandboxing
  is great, but I would have to write a lot more code. I'd also have to build
  the code editing portion, which I was ok with.
* [WeScheme] - I liked the idea, but it relied on having Racket running on the
  server which I deemed unacceptable. Something like WeScheme but fully-hosted
  in the browser would be interesting. Their [Bootstrap] curriculum looks great.
* A handful of pastebin-like code editors (such as [codepen.io], [tributary.io],
  [jsbin.com]). All of them had a very straightforward execution model.
  
None of them had offline support. One of the open source pastebin-like code
editors might have been a good base, but I decided that it would be easier
to build something from lower-level components than to reverse engineer and
strip down a larger application.

It turned out that making it work offline (or at least easy to host on-premise)
is a must for the kind of environment I was in. Schools in low income
communities in rural America have a hard enough time with reliable
connectivity during the school year, and it's
so much worse in the summer. The air conditioning didn't even
work in the computer lab. This was very unpleasant on the hot and humid summer
afternoons, even before the lab was full of students and busy computers.

[The College Initiative]: http://www.thecollegeinitiative.org/
[Scratch]: http://scratch.mit.edu/
[Scheme]: http://en.wikipedia.org/wiki/Scheme_(programming_language)
[Processing.js]: http://processingjs.org/
[Codecademy]: http://www.codecademy.com/
[Khan Academy]: https://www.khanacademy.org/
[CodeHS]: http://codehs.com/
[repl.it]: http://repl.it/
[WeScheme]: http://www.wescheme.org/
[Bootstrap]: http://www.bootstrapworld.org/
[codepen.io]: http://codepen.io/
[jsbin.com]: http://jsbin.com/
[tributary.io]: http://tributary.io/

<a id="editing" name="editing"></a>
# Editing

<img
    src="/assets/images/2013-07-18/codecosmos-tree.png"
    width="100%"
    title="CodeCosmos editor" />
I've found that over the years that a good editor can make picking up a
language easier and more fun. By a good editor, I mean one that is augmented
to understand some of the semantics of the language you're editing. Syntax
highlighting, bracket matching, and continuous linting were what I expected.
I also needed it to have a good API for extensibility.
From what I could find, [Ace] and [CodeMirror] are the best choices for
performant code editors in JavaScript.

I chose CodeMirror mostly because it was easier to find a [linting example]
that did nearly everything I wanted it to, and because [WebKit adopted it]
for their inspector. I would've tested out Ace if I had noticed any major
problems with CodeMirror, but I didn't have a bad time. Ace's website doesn't
have any example that includes more than syntax highlighting, so it would've
been a lot more work to figure that out. I knew it was possible, because
Khan Academy CS uses Ace, but CodeMirror was simply easier to start with.

The linting is performed by [JSHint], with code very similar to the
addon used by the linting example that ships with CodeMirror, but I
made some modifications:
linting runs in a Web Worker, runs a callback when done, and has a
hook that lets me modify the names it recognizes as global. Linting
in a Web Worker was inspired by what I saw when reverse engineering
Khan Academy CS.

CodeMirror seems like it was a good choice. None of the students reported
performance problems. I was able to observe a bug somewhere in CodeMirror
and/or the addons that I am using. I'll be trying to reproduce and fix it
over the next few days. Basically, under some conditions, the editor
gets confused about where the end of a given line is... which makes editing
very painful until you find a way to rewrite that line that doesn't confuse
the editor.

[Ace]: http://ajaxorg.github.io/ace
[CodeMirror]: http://codemirror.net/
[JSHint]: http://jshint.com/
[linting example]: http://codemirror.net/demo/lint.html
[WebKit adopted it]: https://www.webkit.org/blog/2518/state-of-web-inspector/#source-code

<a id="sandbox" name="sandbox"></a>
# Sandbox

<img
    src="/assets/images/2013-07-18/codecosmos-sandbox.png"
    width="100%"
    title="CodeCosmos editor" />

The most novel part of CodeCosmos is the sandbox. I'm loosely using
the term sandbox to refer to the execution environment for the
student-written code. It's not really sandboxed in the strictest
sense of the word. The goal is just to protect the users
from themselves, not other malicious users, which is just fine because
I haven't even implemented any sort of code sharing/collaboration yet.

You can't have nice things if you crank [iframe sandboxing] up to 11,
and you really can't have nice things if you limit execution to a
Web Worker. These aren't necessarily fundamental limitations, but in
such a restricted environment I certainly wouldn't be able to make
good use of [Processing.js]. I did not have the time to build something
like Processing.js that would work in such a restricted environment.
I may go this route in the future, the communication doesn't currently
depend on the editor and sandbox having the same origin.

I really wanted to use Processing.js because I knew other educators
that had success with it, and I knew that I could rely on some
Processing books to help the students and give me some ideas for
lesson plans. The books I brought with me to the lab were:

* [The Nature of Code]
* [Form+Code]
* [Getting Started with Processing]
* [The Computational Beauty of Nature] - not Processing-specific, as it
  predates Processing, but interesting nonetheless

After reverse engineering some of Khan Academy CS I saw that they were
using a Web Worker with a mock version of Processing.js to
run the code once and see if anything bad happens (too many calls, or
blocks for too long), and then it runs it as-is in JavaScript. There
are plenty of scenarios where this isn't going to work, especially
when event handlers are involved, but it did seem to work fine for
them.

I developed what I believe to be a more robust and ultimately simpler
solution. I use [esprima] to get an AST from the student code,
[estraverse] make some relatively cheap transformations that give me
an escape hatch for bad code, and then [escodegen] to convert it
back into JavaScript code that I can create a function out of.

The generated function adds a counter variable, and the transformation
injects code to check and increment the counter every time a
student-written loop is iterated or a student-written function is
invoked. No transformations are done to the JavaScript libraries such
as Processing.js. If the check exceeds some threshold, an exception is
thrown (that Processing.js doesn't catch) and execution of the student
code is stopped. There are of course ways that this could be
circumvented, but I haven't seen a scenario where that happens when
not explicitly trying to do so. The counter is currently
cleared with a [requestAnimationFrame] timer.

The transform also adds some wrappers to catch errors and pass them to
the editor, and the transform renames functions in such a way to give
better name and line number information to the student when things go
wrong (especially for function expressions that they did not
explicitly name). I'll probably elaborate a bit on this part of the
code once I get a chance to refactor it.

[esprima]: http://esprima.org/
[estraverse]: https://github.com/Constellation/estraverse
[escodegen]: https://github.com/Constellation/escodegen
[iframe sandboxing]: http://www.whatwg.org/specs/web-apps/current-work/multipage/the-iframe-element.html#attr-iframe-sandbox
[requestAnimationFrame]: http://www.w3.org/TR/animation-timing/#the-WindowAnimationTiming-interface
[The Nature of Code]: http://www.amazon.com/Nature-Code-Simulating-Natural-Processing/dp/0985930802/?tag=etrepum-20
[Form+Code]: http://www.amazon.com/Form-Code-Design-Architecture-Briefs/dp/1568989377/?tag=etrepum-20
[Getting Started with Processing]: http://www.amazon.com/Getting-Started-with-Processing-ebook/dp/B00DBIEYX2/?tag=etrepum-20
[The Computational Beauty of Nature]: http://www.amazon.com/Computational-Beauty-Nature-Explorations-Adaptation/dp/0262561271/?tag=etrepum-20

<a id="web" name="web"></a>
# Web App

The web app started off as a bunch of framework-free JavaScript code
on top of CodeMirror. That quickly became unmanageable, so I added
[AngularJS]. I also considered [React] and [Ember], but chose
AngularJS mostly because (performance aside) I've had good experiences
with templating languages that are HTML/DOM based, and I knew I wanted
something with easy to use data bindings. The templating needs of this
app were minimal so I wasn't swayed by the potential performance
advantages of React. AngularJS also seems to have the most hype, and
more startups that I've talked to recently are using it, so I wanted
to take the opportunity to familiarize myself with it.

I added [jQuery] a bit later when I wanted to do some event handling
and animation that would've been a bit awkward with (what I knew of)
AngularJS. I may remove the jQuery dependency or replace it with
[Zepto] later, but I chose to go with what I knew for the first version.

[Font.js] was added when I noticed some CodeMirror editing
problems. If
CodeMirror happened to load before the [Source Code Pro] font did,
then its metrics would be off until it was refreshed. [Font.js] made
it easy to get notified when the font was loaded so I could make this
refresh happen. I originally tried [Web Font Loader] but I prefer how
Font.js will allow me to use the font CSS as-is and still get the
events. Font.js is more unobtrusive.

[JSZipTools] is used to facilitate the Backup button in the UI. I'm
using it to dump a copy of the local database into a compressed zip
file in-memory, and the [createObjectURL] API is used to make it
downloadable without any server-side code.

[Underscore] was added very late and is currently used sparingly.
I added it once I realized that I was implementing a handful of its
features (such as [debounce]). I'm also a huge fan of the functional
programming style, even in imperative languages, so it's slowly
being added in other places that make sense.

Overall I'm pretty happy with all these choices. I do have my plate
full of refactorings that I should do now that I have a much better
understanding of how AngularJS works. The AngularJS documentation
could use a ton of work. It's not the worst I've seen, but it's
certainly not sufficient to develop an understanding of what's going
on under the hood, and it's far from complete. The other refactoring
I'd like to do is split it all up into more discrete components that
I can weave together more coherently with a loader such as [RequireJS].

[AngularJS]: http://angularjs.org/
[Font.js]: https://github.com/Pomax/Font.js
[jQuery]: http://jquery.com/
[JSZipTools]: https://github.com/ukyo/jsziptools
[Underscore]: http://underscorejs.org/
[Ember]: http://emberjs.com/
[React]: http://facebook.github.io/react/
[Zepto]: http://zeptojs.com/
[createObjectURL]: http://www.w3.org/TR/FileAPI/#dfn-createObjectURL
[debounce]: http://underscorejs.org/#debounce
[RequireJS]: http://requirejs.org/
[Web Font Loader]: https://github.com/typekit/webfontloader

<a id="persistence" name="persistence"></a>
# Persistence

<img
    src="/assets/images/2013-07-18/codecosmos-persistence.png"
    width="100%"
    title="CodeCosmos load menu" />
For persistence I wanted to be able to save documents locally in [Web Storage]
(or, ideally, [IndexedDB] by default with a fallback), and I wanted to be able
to push them somewhere. I wanted to ensure that it was easy to self-host and
replicate, so I chose [CouchDB] for the server. A future version might use
something else, but CouchDB is certainly the simplest solution for my modest
requirements.

Given CouchDB for server-side persistence, the client-side solutions I
considered were [hood.ie] and [PouchDB]. [hood.ie] looks interesting, but seems
a bit too heavy on server-side node.js, and it's also very alpha. I've had some
awareness of PouchDB for a long while, and even though it's still beta, it's
much more mature hood.ie. I did find some bugs in PouchDB, but I was able to
fix or find workarounds for all of them.

PouchDB + CouchDB seemed to work just fine. I didn't have any reports of lost
work, but most of the projects started and ended on the same day. In the future
I'd like to use something like [Operational Transformation] or
[Differential Synchronization] near the persistence layer to facilitate
conflict resolution and real-time collaboration. I'd also like to have the
capability to push and pull from Git, in lieu of or in addition to CouchDB.
I'll probably be paying close attention to the progress of [JS-Git].

CodeCosmos uses a database-per-user data model, both in PouchDB and CouchDB.
This makes it very easy to implement the PouchDB side. I can do a simple
full-table scan for a user's data and just display it all. This is also the
best way to lock things down in CouchDB, as it's very simple to implement
per-database ACLs without having to write any [Document Update Handlers].

Unfortunately, CouchDB does not natively support the per-user database model.
You have to roll your own daemon to watch for new documents in `_users` and
create databases. I didn't expect that I would have to deploy any services,
but I quickly put together [codecosmos-node] to implement this. I built
this in node.js because it was easy to do on top of the [follow] and [request]
libraries.

Sessions are stored in [Web Storage]'s `localStorage`. Not a lot of security
here yet, as I'm still using basic auth. The neat thing about `localStorage`
and PouchDB is that changes from one tab or browser window are immediately
propagated to other tabs via events. I'm not using any libraries here,
the APIs are rather simple and I didn't need to do any polyfills since
the app is Chrome-only.

<a id="hosting" name="hosting"></a>
# Hosting

CodeCosmos.com is currently hosted by [GitHub Pages], with a database on
[Iris Couch] and the daemon that creates databases is hosted on [nodejitsu].
I'm not happy with any of these, and I didn't actually use any of this
infrastructure in class. I don't like [GitHub Pages] because I can't enable
SSL. I don't like [Iris Couch] because it is unresponsive very often, although
it is very nice to have a hosted CouchDB with CORS support (which is why I
couldn't try [Cloudant]). I don't like [nodejitsu] because I just don't
have enough experience to trust it. I had scenarios where codecosmos-node
stopped creating databases and required a restart. I'm not sure whether to
blame node.js, nodejitsu, follow, or Iris Couch, but I'd be much happier
with something in Erlang or Haskell where it is far easier to reason about
failure scenarios.

For the class, everything was hosted on the LAN from my laptop with
[CouchDBX]&#32;(what you get when you download CouchDB for Mac OS X),
codecosmos-node to create databases, and a static file webserver. The first
day I used mochiweb as the webserver, but I later added static file serving
to codecosmos-node using [node-static] so that I had fewer things to keep
running. I would replicate this all to the hosted CouchDB with a small script
([replicate-once]), because CouchDB has no built-in functionality to replicate
all databases from one server to another.

I intend to migrate all of this stuff over to [Rackspace Cloud], as they're
very generously providing free service for open source projects. I'll probably
just make some minor modifications to CouchDB so that I can get rid of
codecosmos-node.

[CouchDB]: http://couchdb.apache.org/
[hood.ie]: http://hood.ie/
[PouchDB]: http://pouchdb.com/
[Web Storage]: http://www.w3.org/TR/webstorage/ 
[IndexedDB]: http://www.w3.org/TR/2013/CR-IndexedDB-20130704/
[Web Workers]: http://www.whatwg.org/specs/web-apps/current-work/multipage/workers.html
[Operational Transformation]: http://en.wikipedia.org/wiki/Operational_transformation
[Differential Synchronization]: http://neil.fraser.name/writing/sync/
[JS-Git]: https://github.com/creationix/js-git
[codecosmos-node]: https://github.com/CodeCosmos/codecosmos-node/blob/master/bin/codecosmos-node
[Document Update Handlers]: http://wiki.apache.org/couchdb/Document_Update_Handlers
[follow]: https://github.com/iriscouch/follow
[request]: https://github.com/mikeal/request
[nodejitsu]: https://www.nodejitsu.com/
[Iris Couch]: http://www.iriscouch.com/
[Cloudant]: https://cloudant.com/
[node-static]: https://github.com/cloudhead/node-static
[CouchDBX]: http://couchdb.apache.org/#download
[GitHub Pages]: http://pages.github.com/
[replicate-once]: https://github.com/CodeCosmos/codecosmos-node/blob/master/bin/replicate-once
[Rackspace Cloud]: http://www.rackspace.com/cloud/

<a id="build" name="build"></a>
# Build tools

It's hardly worth mentioning because the app hardly relies on it,
but I decided to use [Grunt] for the build/lint phases. I'm using a
few grunt-contrib packages for jshint, watch, copy, and
csslint. There's a custom task to build the appcache file because I
couldn't be bothered to find the right module to do something so
simple. 

I used Grunt mostly because I was already using [Bower] and it seemed
like a lot of the JavaScript dependencies of the app were using one or
both of these tools. Bower is used to fetch the dependencies that are
compatible with Bower. The other dependencies are simply included in
the app because I'm not getting enough value with Bower to go through
the hassle of wrapping them with Bower-compatible repositories.

[Grunt]: http://gruntjs.com/
[Bower]: http://bower.io/

<a id="css" name="css"></a>
# CSS and Fonts

I'm not very good at CSS, but I have enough experience to know that
less is more. I had a little experience tinkering with [Pure], so I
chose as a CSS framework. I'm not making great use of it, and may
decide later to swap it out for something else or just hand-code what
I need, but it's working alright for now. I hope to give the app a
responsive layout once I decide it's time to support more
browsers. Ideally, I would like CodeCosmos to work well on iOS and
Android tablets in addition to modern desktop browsers.

I chose the [Source Code Pro] font for the editor, which I think
looks pretty great. I knew I wanted to use a web font because
the monospace fonts used by Mac and Windows are so different, and
after looking at some of the coding fonts I liked this one the best.

I don't recall where I first saw [Font Awesome], but it was an easy
choice for all of the iconography in the menus. The type in the menus
is [Ubuntu Regular]. [Kontrapunkt Bold] is used for the "CodeCosmos" logotype
in the menu.

For the login screen, I blatantly ripped off the look of Twitter's.
The source material for the background images came from [HubbleSite],
but I did some processing on them in [Acorn] first (mostly just gamma
correction and brightness before resizing and compressing them for
web use).

<img
    src="/assets/images/2013-07-18/codecosmos-login.jpg"
    width="100%"
    title="CodeCosmos login screen" />
<img
    src="/assets/images/2013-07-18/twitter-login.jpg"
    width="100%"
    title="Twitter login screen" />


[Pure]: http://purecss.io/
[Font Awesome]: http://fontawesome.io/
[Kontrapunkt Bold]: http://www.kontrapunkt.com/type
[Ubuntu Regular]: http://font.ubuntu.com/
[Source Code Pro]: https://blogs.adobe.com/typblography/2012/09/source-code-pro.html
[Acorn]: http://www.flyingmeat.com/acorn/
[HubbleSite]: http://hubblesite.org/gallery/album/

<a id="postmortem" name="postmortem"></a>
# Post-mortem

Overall, I think the libraries I chose worked out pretty well. I
really wish I had another week or two prior to the course to tweak
the UI for usability and to build out an in-app reference for the subset of
Processing.js that we used. I have a bug or two in CodeMirror to track
down, and there's a lot of work I can do to clean up the web app code
and to make the persistence more robust. I'd also like to swap out the
hosting choices with [Rackspace Cloud].

Top priority right now is to do some more follow-up with the students,
and to write the post about my experience actually teaching the course!
