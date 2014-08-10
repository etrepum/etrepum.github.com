---
categories: [javascript, teaching, processingjs, education]
tags: [javascript, teaching, processingjs, processing, education]
title: Teaching with CodeCosmos
---
<style scoped>
.imgright { float: right; margin-left: 1em; margin-bottom: 0.5em; width: 40%; clear: right; }
.imgright2 { float: right; margin-left: 1em; margin-bottom: 0.5em; width: 25%; clear: right; }
.imgfull { width: 100%; clear: both; }
.clear { clear: both; }
.img4 { float: left; width: 24%; margin-left: 1%; }
.img2 { float: left; width: 48%; margin-left: 2%; }
sup { vertical-align: super; font-size: smaller; }
sup a { margin-left: 0.2em; }
sup a:before { content: "["; }
sup a:after { content: "]"; }
blockquote:before { position: absolute; display: block; content: "\201C"; font-size: 300%; left: 0; top: 0.25em; color: #777; }
blockquote { position: relative; font-style: italic; padding-left: 1.75em;}
blockquote p { margin-bottom: 0; }
blockquote cite:before { content: "\2014" }
blockquote cite { font-size: 75%; }
aside { font-size: smaller; }
h1 { clear: both; }
ol { margin-left: 1em; }
</style>

This is the continuation to [Why I made CodeCosmos] and [How I built CodeCosmos].
If you're interested in why I bothered to do this, or the technical details of
the app, start there. This post is about my experience using CodeCosmos to teach
an intro coding class.

[Why I made CodeCosmos]: /archives/2013/07/08/codecosmos-day-1/
[How I built CodeCosmos]: /archives/2013/07/18/codecosmos-tech/

* *[Prologue](#prologue)*
* *[Monday](#monday)*, *[Tuesday](#tuesday)*, *[Wednesday](#wednesday)*, *[Thursday](#thursday)*, *[Friday](#friday)*
* *[Epilogue](#epilogue)*
* *[Footnotes](#footnotes)*

<h1><a id="prologue" name="prologue" href="#prologue">Prologue</a></h1>

<blockquote cite="http://www.cs.utexas.edu/users/EWD/transcriptions/EWD07xx/EWD709.html">
<p>It does not suffice to hone your own intellect (that will join you in your grave), you must teach others how to hone theirs.</p>
<cite>E.W. Dijkstra (<a href="https://twitter.com/DijkstraQuotes/status/357546511841763329">@DijkstraQuotes</a>)</cite>
</blockquote>

<a href="https://www.facebook.com/photo.php?fbid=10151575635106253"
  title="My EG7 badge">
<img src="/assets/images/2013-07-24/61523_10151575635106253_749096641_n.jpg"
  class="imgright"
  alt="My EG7 badge">
</a>

I've been doing some research on CS education since I left Facebook last year.
I took some [Coursera courses], read some books<sup id="cite_ref-1"><a href="#cite_note-1">1</a></sup>,
started curating [@DijkstraQuotes] (after discovering the
[EWD Archive]), and started chatting
about education with friends and new people I'd meet. I had no real
experience teaching anyone other than myself, and no expertise in any
other facet of education.

I attended [EG 7] back in April and met
[Cat Crumpler]<sup id="cite_ref-2"><a href="#cite_note-2">2</a></sup>.
She's the COO of [The College Initiative], a
non-profit after school program that prepares disadvantaged
students for life after high school and ensures that they have the
opportunity to attend and graduate from college. A few weeks later she
asked me to come teach their students how to code. I was certainly not
prepared to actually teach at this point and was very much hesitant
at first, but she was persistent and eventually succeeded in convincing me
to do it. The rationale was that it would be a good opportunity for the
students even if I wasn't great at teaching. I really just didn't have
a good enough excuse not to do it.

So&hellip; I had less than two months to come up with some kind of lesson plan to
teach a computer lab full of students. I had no prior experience teaching
and the students had no prior experience with coding. I settled on the
premise that I would just try and inspire the students to want to learn more
about programming. I hypothesized that the best way to do that was to leave
the formal Computer Science out of it. I wanted to give them a fun project-based 
learning environment where they would essentially be teaching
themselves. I'd also spend a bit of the time we had on videos to give the students
some background on why coding is awesome with some historical context. A bit
more about that process is in the previous two posts: [Why I made CodeCosmos]
and [How I built CodeCosmos].

[EG 7]: http://www.the-eg.com/
[Coursera courses]: /archives/2013/05/07/great-coursera-courses/
[@DijkstraQuotes]: https://twitter.com/DijkstraQuotes
[EWD Archive]: http://www.cs.utexas.edu/users/EWD/
[Cat Crumpler]: https://twitter.com/catcrumpler
[The College Initiative]: http://www.thecollegeinitiative.org/

<h1><a id="monday" name="monday" href="#monday">Monday</a></h1>
<a href="https://www.facebook.com/photo.php?fbid=272865049520270"
   title="The Courier-Index front-page featuring Jamie and me">
<img src="/assets/images/2013-07-24/946585_272865049520270_623477349_n.jpg"
    class="imgright"
    alt="The Courier-Index front-page featuring Jamie and me"/>
</a>

I arrived at Lee Senior High School about two hours before class,
tired<sup id="cite_ref-3"><a href="#cite_note-3">3</a></sup>, but
thinking that I had plenty of time to prepare the day's lesson. I did not.
The school did not have working internet that day, and I wasn't well
prepared for that scenario. When doing local development I used
`python -mSimpleHTTPServer` to serve the files, but I was horrified
when I discovered that it only works when the internet is
up<sup id="cite_ref-4"><a href="#cite_note-4">4</a></sup>!

I didn't have the luxury of cellular
coverage<sup id="cite_ref-5"><a href="#cite_note-5">5</a></sup>,
so solving these problems had to be done with my jet-lagged brain and
whatever I could find on my laptop. Fortunately I had Erlang
installed and mochiweb available to get a static file webserver up really
quickly. This doesn't actually involve writing any code or configuring
anything, since the template does this out of the box. CouchDB and the
other code I needed to make it work was also on my laptop. The biggest
snag was that I needed to fiddle with some CouchDB configuration to
enable CORS and permit the Authorization header. Unfortunately I didn't
take good notes on how I did that with IrisCouch, but fortunately I
remembered where to look in `couch_httpd_cors.erl` to deduce it.

I was well prepared with the videos. I had "cached" the m4v files I planned
to play because  I wanted to have high quality versions regardless of the
school's bandwidth. This turned out to be especially important because the
school's connectivity was sub-par even when the internet was working.
They also blocked all of the sites that the videos were hosted from,
so I would've had a bad time if I did not have a local copy of the videos.

<a href="http://www.youtube.com/watch?v=nKIu9yen5nc"
   title="code.org - What most schools don't teach">
<img src="/assets/images/2013-07-24/vid-code-org.jpg"
     class="imgright video"
     alt="code.org - What most schools don't teach"/>
</a>
<a href="http://www.youtube.com/watch?v=ahM_70Fvckw"
   title="me, circa 1992">
<img src="/assets/images/2013-07-24/vid-me-1992.jpg"
     class="imgright video"
     alt="me, circa 1992"/>
</a>
I showed [code.org]'s "[What most schools don't teach]" first. I think this
video really resonated with the students, especially what [Chris Bosh] had
to say. Since that video shared a lot of stories about how other coders
got their start, I shared one of [me circa 1992] "showing the kids what a
computer with OS/2 can do". Mind you, I was about 11 at the time. There was
a bit of Q&A afterwards with the sort of questions that you might expect:
"how much do programmers make",
"how do you get a job at one of these companies", and my favorite was something
along the lines of "how does programming actually benefit society". I can
certainly see why they would ask that kind of
question<sup id="cite_ref-6"><a href="#cite_note-6">6</a></sup> after
watching that video.

The challenge for the first day was simple, use Processing to draw your
name or initials using lines. I showed them how to get on CodeCosmos by
having them point their browser to my laptop's IP address, stepped them through
how the UI works, and pointed them at some built-in example code that draws
"LINE" using the line method of Processing.js. The goal was to get them
familiar with a bit of JavaScript syntax, the coordinate system, and accustomed
to playing around rather than following step by step instructions.
Some students finished quickly went ahead and played with some of the
other examples that I had prepared, others decided to go further with
the challenge. One student spelled out her entire name. That was a lot of lines!

<img src="/assets/images/2013-07-24/challenge-monday-line.png"
    class="imgfull"
    alt="Lines &amp; coordinates"/>

Note that I did not take the time to explain anything at all about programming
or CS. I wanted to show them that they could discover it for themselves.
Remixing code that I typed in from the back of magazines, books, or downloaded
from BBS's was how I started.

After most of them were well on their way, I showed them a trick that would
make it easier to compose drawings: they could apply an affine transform to
each group of drawing commands, so that they could easily copy and paste
a letter and change one point rather than N. I didn't explain the linear
algebra or even call it an affine transform, I just hand-waved a bit and
said that the [pushMatrix()] and [popMatrix()] business was like managing a
stack of playing cards<sup id="cite_ref-7"><a href="#cite_note-7">7</a></sup>,
and calling [translate()] was rougly equivalent to moving the paper that you're
drawing to before you start drawing.

<a href="http://alchemymemphis.com/"
   title="Dinner &amp; drinks at Alchemy in Memphis">
<img src="/assets/images/2013-07-24/alchemy-drinks.jpg"
    style="max-height: 225px; float: right; clear: both"
    alt="Dinner &amp; drinks at Alchemy in Memphis"/>
</a>

Post-class festivities included dinner &amp; drinks at [Alchemy] in Memphis.
Highly recommend it if you ever find yourself in the neighborhood! Everything
there was great, especially the shrimp &amp; grits and the bread pudding. I
spent some time thinking about what to prepare for Tuesday, but didn't
do a very good job sleeping or preparing a coherent lesson plan.

[code.org]: http://www.code.org/
[What most schools don't teach]: https://www.youtube.com/watch?v=nKIu9yen5nc
[Chris Bosh]: http://en.wikipedia.org/wiki/Chris_Bosh
[me circa 1992]: http://www.youtube.com/watch?v=ahM_70Fvckw
[pushMatrix()]: http://processingjs.org/reference/pushMatrix_/
[popMatrix()]: http://processingjs.org/reference/popMatrix_/
[translate()]: http://processingjs.org/reference/translate_/
[Alchemy]: http://alchemymemphis.com/

<h1><a id="tuesday" name="tuesday" href="#tuesday">Tuesday</a></h1>

<a href="http://www.youtube.com/watch?v=eBV14-3LT-g"
   title="PBS Off Book - The Art of Creative Coding">
<img src="/assets/images/2013-07-24/vid-art-of-creative-coding.jpg"
    class="imgright video"/>
</a>
On Tuesday I started off class with [The Art of Creative Coding].
I wanted to show them the amazing stuff that's at the intersection of art,
design and software development using similar software and techniques to what
we're doing in class.

<a href="https://www.facebook.com/photo.php?fbid=271796256293816"
   title="Helping a student sort out a syntax error in her code">
<img src="/assets/images/2013-07-24/585_271796256293816_431985305_n.jpg"
    alt="Helping a student sort out a syntax error in her code"
    class="imgright" />
</a>

The challenge for the day was to draw the Olympic Rings with code. In my
sleep-deprived stupor I made the rookie mistake of not doing the challenge
first myself to ensure that I showed the students everything they needed to
know in order to be successful. I thought I had covered all of the bases by
showing them a little bit about how the RGB colorspace works with [stroke()]
and [fill()], and how to use [arc()] (including a refresher on radians and
the unit circle).

The goals were to familiarize them with drawing order, colors, and how to
solve a tricky problem, since the rings overlap in a way that requires a
non-obvious solution. Since I hadn't solved this myself, I failed to realize
that the functions I had showed them were necessary but not sufficient to
put together a simple solution to this challenge.

<a href="http://en.wikipedia.org/wiki/File:Olympic_Rings.svg"
   title="Olympic Rings">
   <img src="/assets/images/2013-07-24/Olympic_Rings.svg"
        style="clear: both; margin-left: auto; margin-right: auto; width: 50%; display: block;"
        alt="Olympic Rings"/>
</a>

<a href="https://www.facebook.com/photo.php?fbid=272092032930905"
   title="Ashlee discovering how to make yellow from RGB components during the Olympic Rings challenge">
<img src="/assets/images/2013-07-24/941238_272092032930905_2019553029_n.jpg"
    class="imgright"
    alt="Ashlee discovering how to make yellow from RGB components during the Olympic Rings challenge"/>
</a>

After a while struggling with that problem, I moved on to something I thought
would be easier and a little more exciting. I had them play with the time-based
animation example and the new challenge was to get it to ping-pong back and
forth instead of just moving from left to right. I showed them how the [sin()]
function can be used to do this, since it is periodic. Before I had showed them
the trick, one student put together a clever solution that used a divide
somewhere that had a similar effect (with a much more erratic speed). A few of
the students had a lot of fun trying other functions to control the movement,
and others decided to change what was being drawn.

<a href="https://www.facebook.com/photo.php?fbid=10151721359976253"
   title="Jim Neely's Interstate BBQ in Memphis">
<img src="/assets/images/2013-07-24/1069390_10151721359976253_1227452275_n.jpg"
    alt="Jim Neely's Interstate BBQ in Memphis"
    class="imgright" />
</a>

After class we went to [Jim Neely's Interstate Barbecue] in Memphis,
which was awesome. I'm not normally a big fan of the sweet Memphis-style BBQ,
but this was delicious. I highly recommend
it<sup id="cite_ref-8"><a href="#cite_note-8">8</a></sup>! That night I worked
out the Olympic Rings challenge myself and discovered what was missed and
got some much needed rest.

[The Art of Creative Coding]: http://www.youtube.com/watch?v=eBV14-3LT-g
[arc()]: http://processingjs.org/reference/arc_/
[fill()]: http://processingjs.org/reference/fill_/
[stroke()]: http://processingjs.org/reference/stroke_/
[strokeWeight()]: http://processingjs.org/reference/strokeWeight_/
[sin()]: http://processingjs.org/reference/sin_/
[Jim Neely's Interstate Barbecue]: http://www.interstatebarbecue.com/

<h1><a id="wednesday" name="wednesday" href="#wednesday">Wednesday</a></h1>

<div class="clear">
<a href="https://www.youtube.com/watch?v=uBbVbqRvqTM"
   title="Great Minds - Ada Lovelace">
<img src="/assets/images/2013-07-24/vid-ada-lovelace.jpg"
     class="img4 video"
     alt="Great Minds - Ada Lovelace"/>
</a>
<a href="https://www.youtube.com/watch?v=Btqro3544p8"
   title="Great Minds - Alan Turing">
<img src="/assets/images/2013-07-24/vid-alan-turing.jpg"
     class="img4 video"
     alt="Great Minds - Alan Turing"/>
</a>
<a href="https://www.youtube.com/watch?v=dhh8Ao4yweQ"
   title="Don Knuth - The Electronic Coach">
<img src="/assets/images/2013-07-24/vid-don-knuth.jpg"
     class="img4 video"
     alt="Don Knuth - The Electronic Coach"/>
</a>
<a href="https://www.youtube.com/watch?v=Ki_Af_o9Q9s"
   title="Challenges of Getting to Mars: Curiosity's Seven Minutes of Terror">
<img src="/assets/images/2013-07-24/vid-jpl-curiosity.jpg"
     class="img4 video"
     alt="Challenges of Getting to Mars: Curiosity's Seven Minutes of Terror"/>
</a>
</div>
<div class="clear"></div>

<a href="https://www.facebook.com/photo.php?fbid=272093619597413"
   title="Brasha is stoked that she got the colors and pattern right for the Olympic rings">
<img src="/assets/images/2013-07-24/21399_272093619597413_58531329_n.jpg"
    class="imgright"
    alt="Brasha is stoked that she got the colors and pattern right for the Olympic rings" />
</a>

On Wednesday I showed videos on [Ada Lovelace], [Alan Turing], and
[The Electronic Coach] to give the students some more background
on the the early history of programming and computer science. I also showed
[Challenges of Getting to Mars: Curiosity's Seven Minutes of Terror]
to show them that coding is used to do some truly awesome things. I was
lucky enough to have toured JPL
recently<sup id="cite_ref-9"><a href="#cite_note-9">9</a></sup>
so I was well prepared to answer the questions that they had
about Curiosity's mission.

I started off by showing the class how [strokeWeight()] makes it much
easier to solve Olympic rings challenge, and had them go ahead and
take a second shot at it. The students really seemed to enjoy being
able to solve a problem they struggled with the day before.

<a href="http://instagram.com/p/bnKEm9nD6W/"
    title="TCI staff night out at Ground Zero!">
<img src="/assets/images/2013-07-24/21385_4993070635857_656989762_n.jpg"
    class="imgright"
    alt="TCI staff night out at Ground Zero!">
</a>

After most of the students had solved the Olympic Rings challenge we
moved on to a simple Physics simulation. I walked them through making
a ball bounce at the bottom of the screen (using Euler integration)
and their challenge was to make the ball also bounce off the
sides of the screen. None of them had any exposure to Physics or
Calculus before, so we didn't have any deep discussions about the
formulas, but most of them were very successful in implementing it
even though the equations and the use of conditionals were new
to them.

After class we went to Clarksdale, MS for pizza and the [Ground Zero Blues Club].
We didn't run into Morgan Freeman<sup id="cite_ref-10"><a href="#cite_note-10">10</a></sup>.

[Ada Lovelace]: https://www.youtube.com/watch?v=uBbVbqRvqTM
[Alan Turing]: https://www.youtube.com/watch?v=Btqro3544p8
[The Electronic Coach]: https://www.youtube.com/watch?v=dhh8Ao4yweQ
[Challenges of Getting to Mars: Curiosity's Seven Minutes of Terror]: https://www.youtube.com/watch?v=Ki_Af_o9Q9s
[Ground Zero Blues Club]: http://www.groundzerobluesclub.com/

<h1><a id="thursday" name="thursday" href="#thursday">Thursday</a></h1>

<div class="clear">
<a href="http://www.youtube.com/watch?v=RQ_HdHSpDEg"
    title="CareerRx - A Day in the Life of a Computer Programmer">
<img src="/assets/images/2013-07-24/vid-computer-programmer.jpg"
     class="img4 video"
     alt="CareerRx - A Day in the Life of a Computer Programmer" />
</a><a href="https://www.youtube.com/watch?v=BES9EKK4Aw4 "
    title="Coding with Notch">
<img src="/assets/images/2013-07-24/vid-coding-with-notch.jpg"
     class="img4 video"
     alt="Coding with Notch" />
</a><a href="https://www.youtube.com/watch?v=RBdOolaisIc"
   title="Time Magazine - Graffiti Meets the Digital Age">
<img src="/assets/images/2013-07-24/vid-graffiti-meets-the-digital-age.jpg"
     class="img4 video"
     alt="Time Magazine - Graffiti Meets the Digital Age"/>
</a><a href="https://www.youtube.com/watch?v=75Ju0eM5T2c"
   title="Donald Knuth - My Advice to Young People">
<img src="/assets/images/2013-07-24/vid-donald-knuth-advice.jpg"
     class="img4 video"
     alt="Donald Knuth - My Advice to Young People">
</a>
</div>
<div class="clear"></div>

<a href="https://www.facebook.com/photo.php?fbid=272586392881469"
   title="Note the Graffiti Research Lab t-shirt :)">
<img src="/assets/images/2013-07-24/941227_272586392881469_1113510962_n.jpg"
     class="imgright2"
     alt="Note the Graffiti Research Lab t-shirt :)"/>
</a>

<a href="https://www.facebook.com/photo.php?fbid=272578132882295"
   title="Jordan managed to make his Sierpinski triangle look like it's 3D">
<img src="/assets/images/2013-07-24/578361_272578132882295_17954676_n.jpg"
     class="imgright2"
     alt="Jordan managed to make his Sierpinski triangle look like it's 3D"/>
</a>

<a href="https://www.facebook.com/photo.php?fbid=272577056215736"
   title="Fractals in the classroom">
<img src="/assets/images/2013-07-24/970404_272577056215736_462365543_n.jpg"
     class="imgright2"
     alt="Fractals in the classroom"/>
</a>

<a href="https://www.facebook.com/photo.php?fbid=10151725200766253"
    title="Catfish lover parking only - all others will be pan-fried (at Fat Baby's Catfish House in Cleveland)">
<img src="/assets/images/2013-07-24/969738_10151725200766253_130031342_n-square.jpg"
     class="imgright2"
     alt="Catfish lover parking only - all others will be pan-fried (at Fat Baby's Catfish House in Cleveland)"/>
</a>

On Thursday we watched [A Day in the Life of a Computer Programmer] to
see what programming propaganda looked like in the early 90s,
[Coding with Notch] to watch a game developer work,
[Graffiti Meets the Digital Age] to throw in a bit of counterculture
via the Graffiti Research Lab, and a short clip of
Donald Knuth's [My Advice to Young People] mostly just to
see if anyone recognized him from [The Electronic Coach].

The first half of class was spent playing with fractals and
recursion. I gave them a [Sierpinski Triangle] example to play
with, and their challenge was to figure out how to make it
colorful. The tricky part here is that there's no obvious
index variable that they could use to choose a color.

Most of the students discovered that they could change the
colors at each point of recursion, which generally ended up
with a nice tri-color pattern. A few also discovered that
the coordinates of the triangle could be used to make
a gradient. Several of them went a little nuts with it and
made some very cool looking designs!

One of the most common questions I was asked during this
assignment, after they changed the fill color, was
"how do I change the color of the white
triangles?" It wasn't obvious to all of them that the
"white triangles" were the negative space, where no drawing
took place.

After the fractal challenge, I gave them a final assignment:
use CodeCosmos to make a design to be printed on
custom a t-shirt or poster, and I'd get it shipped out to them
if they finish. This is open-ended, I wanted them to be able
to continue to work on this at home, so I'll be following up
with them over the next couple weeks.

After class we went to [Fat Baby's Catfish House] in Cleveland, MS.
I have never eaten so much catfish in my life. It was fantastic,
even the bread had catfish in
it<sup id="cite_ref-11"><a href="#cite_note-11">11</a></sup>!

[A Day in the Life of a Computer Programmer]: http://www.youtube.com/watch?v=RQ_HdHSpDEg
[Coding with Notch]: https://www.youtube.com/watch?v=BES9EKK4Aw4
[Graffiti Meets the Digital Age]: https://www.youtube.com/watch?v=RBdOolaisIc
[My Advice to Young People]: https://www.youtube.com/watch?v=75Ju0eM5T2c
[Sierpinski Triangle]: https://en.wikipedia.org/wiki/Sierpinski_triangle
[Fat Baby's Catfish House]: http://www.fatbabyscatfishhouse.com/

<h1><a id="friday" name="friday" href="#friday">Friday</a></h1>

<div class="clear">
<a href="http://www.apple.com/ios/videos/#developers"
   title="Making a difference. One app at a time.">
<img src="/assets/images/2013-07-24/vid-ios-developers_endstate.jpg"
     class="img2 video"
     alt="Making a difference. One app at a time."/>
</a>
<a href="http://vimeo.com/7395079"
   title="Trillions">
<img src="/assets/images/2013-07-24/vid-trillions-cropped.jpg"
     class="img2 video"
     alt="Trillions"/>
</a>
</div>
<div class="clear"></div>

<a href="https://www.facebook.com/photo.php?fbid=10151719747726253"
   title="The Nature of Code (and other programming books)">
<img src="/assets/images/2013-07-24/993051_10151719747726253_1827182736_n.jpg"
     class="imgright"
     alt="The Nature of Code (and other programming books)"/>
</a>
<a href="https://www.facebook.com/photo.php?fbid=10151726640286253"
    title="Fantastic thank you card from the students">
<img src="/assets/images/2013-07-24/969338_10151726640286253_1988588723_n.jpg"
     class="imgright"
     alt="Fantastic thank you card from the students"/>
</a>
<a href="https://www.facebook.com/photo.php?fbid=272928776180564"
    title="TCI students and staff after our last day of coding class">
<img src="/assets/images/2013-07-24/1005752_272928776180564_364959941_n.jpg"
     class="imgright"
     alt="TCI students and staff after our last day of coding class"/>
</a>

The last videos we watched were Apple's
[Making a difference. One app at a time.] and MAYA Design's
[Trillions]. I think Apple's video does a great job at showing how
the work that programmers do can very directly improve quality of life
for others. I think Trillions does a good job presenting some of
today's computing challenges at a very high level.

I spent the last day trying to have short one-on-one conversations
with all of the students while they worked on their final assignments.
I gave each of them my card, made it clear to them that I'd be happy
to help them out if they contact me, and chatted briefly about what
they liked and what I could improve on in the next course. Nearly
all of the students suggested that there ought to be some built-in
reference material in the app, so that's high on my list for next
time.

I brought several
books<sup id="cite_ref-12"><a href="#cite_note-12">12</a></sup>
with me each day for the class (and myself) to use for reference
and inspiration. Some of the students seemed to enjoy them, so
I decided to raffle them off to anyone in the class who was
interested. Six of the students signed up, so I put together
a little program at the end to use the PRNG in JavaScript to
do random selection without replacement from the list of students.
One lucky student chose my copy of [The Nature of Code], and she was
very excited to learn that it was a signed by the author,
[Daniel Shiffman], who we had seen in [The Art of Creative Coding].
I didn't want the two students who "lost" the raffle to go home
disappointed, so I told them that they could choose from any of 
the books and I'd have it shipped to them. Both of the students
took me up on that offer and received their books last week.

I received a really fantastic [thank you card] from the students,
and many of them included me in their
shout-outs<sup id="cite_ref-13"><a href="#cite_note-13">13</a></sup>, 
which made it all totally worthwhile. We also did a group photo outside
the school.

That night the staff celebrated in Memphis. We had some drinks on a
rooftop bar at sunset, enjoyed a nice dinner, and then checked out
some of the Beale street festivities. Not really my scene, but it was
worth checking out.

[Making a difference. One app at a time.]: http://www.apple.com/ios/videos/#developers
[Trillions]: http://vimeo.com/7395079
[The Nature of Code]: http://www.amazon.com/The-Nature-Code-Simulating-Processing/dp/0985930802?tag=etrepum-20
[Daniel Shiffman]: http://www.shiffman.net/
[thank you card]: https://www.facebook.com/photo.php?fbid=10151726640286253

<h1><a id="epilogue" name="epilogue" href="#epilogue">Epilogue</a></h1>
<a href="https://www.facebook.com/photo.php?fbid=10151726866646253"
    title="Madison Hotel's rooftop bar in Memphis at sunset">
<img src="/assets/images/2013-07-24/1001874_10151726866646253_1491639192_n.jpg"
     class="imgright"
     alt="Madison Hotel's rooftop bar in Memphis at sunset"/>
</a>
<a href="https://www.facebook.com/photo.php?fbid=10151728747961253"
    title="Gus's Fried Chicken in Memphis">
<img src="/assets/images/2013-07-24/1005284_10151728747961253_1719802718_n.jpg"
     class="imgright"
     alt="Gus's Fried Chicken in Memphis"/>
</a>

I sent the TCI 2013 scholars a [follow-up email] with some information
about how to submit their t-shirt project, what they learned, and
where they can learn more. After finishing this post I'll be figuring
out how to get high quality output out of their code, and where to get
them printed. My tentative plan is to use [Spreadshirt] or
[Custom Ink] but I'd be interested to hear about other
options.

After all that business I'll get back to hacking! There's some
housekeeping to do, such as migrating to [Rackspace Cloud], and
after that there's just a ton of refactoring, testing, writing docs,
submitting patches upstream, fixing bugs, making it work
cross-browser and on tablets, etc.

If you're interested in using CodeCosmos, having me speak about it
somewhere, or even having me teach a class, I'm definitely open to
that sort of thing. I'm based in San Francisco, but willing to travel just
about anywhere for the right reasons (especially if it's not
out-of-pocket). Just get in touch!

[follow-up email]: http://codecosmos.com/tci2013/follow-up-email.html
[Spreadshirt]: http://www.spreadshirt.com/
[Custom Ink]: http://www.customink.com/
[Rackspace Cloud]: http://www.rackspace.com/cloud

<h1><a name="footnotes" href="#footnotes" id="footnotes">Footnotes</a></h1>
<aside id="footnotes">
<ol>
<li id="cite_note-1">
    LOGO books:
        <a href="http://www.amazon.com/Mindstorms-Children-Computers-Powerful-Ideas/dp/0465046746/?tag=etrepum-20">Mindstorms</a>,
        <a href="http://www.amazon.com/Childrens-Machine-Rethinking-School-Computer/dp/0465010636/?tag=etrepum-20">The Children's Machine</a>,
        <a href="http://www.amazon.com/Turtle-Geometry-Mathematics-Artificial-Intelligence/dp/0262510375/?tag=etrepum-20">Turtle Geometry</a>.<br>
    Scratch book:
        <a href="http://www.amazon.com/Super-Scratch-Programming-Adventure-Program/dp/1593274092/?tag=etrepum-20">Super Scratch Programming Adventure</a>
    <a href="#cite_ref-1">&#x21a9;</a>
</li>
<li id="cite_note-2">
Of course, she was not the <em>only</em> awesome person that I met at EG! Also, Cat is terrible at Twitter. Her <a href="http://www.linkedin.com/pub/cat-crumpler/1b/3b9/737">LinkedIn profile</a> is more interesting. How sad is that?
<a href="#cite_ref-2">&#x21a9;</a>
</li>
<li id="cite_note-3">
I really had a heck of a time actually getting to Memphis. There are no direct
flights from any airport in the SF bay area. And well, there was a plane crash
at SFO the day before I needed to depart from that same airport. My departing
flight was canceled. I barely managed to get there on time, but only because I
have a fantastic travel agent and I was willing to sacrifice sleep to, and throw
money at, this problem.
<a href="#cite_ref-3">&#x21a9;</a>
</li>
<li id="cite_note-4">
Python's SimpleHTTPServer is a minimal wrapper over BaseHTTPServer, which logs
every request to the console. The stupid part is that it does a synchronous
reverse DNS lookup so that it looks prettier. This is even dumber than you
might think, since reverse DNS is often out of sync with reality. Logging the
IP address as-is (or nothing at all) would make a heck of a lot more sense for
such a low-level library! Remember kids: friends don't let friends use network
servers from the Python standard library. If you're using Python, the best
of breed solution is <a href="http://twistedmatrix.com/">Twisted</a>. If you
have Twisted installed, you can run a much better web server with
`twistd -n web --path . --port 8000`. I didn't even think of this solution
at the time.
<a href="#cite_ref-4">&#x21a9;</a>
</li>
<li id="cite_note-5">
Neither AT&T nor Clear (Sprint) have any sort of coverage in that building.
I could've gone to the parking lot to get a bar or two. That would not have
been very efficient!
<a href="#cite_ref-5">&#x21a9;</a>
</li>
<li id="cite_note-6">
Some of these companies and people <em>are</em> doing good, but that's not
really their primary focus&hellip; except for Bill Gates, who is a hell of a
philantropist these days. Sadly, that's not really the first thing that comes
to mind when most people think of Bill Gates.
<a href="#cite_ref-6">&#x21a9;</a>
</li>
<li id="cite_note-7">
The students were all very familiar with playing cards, because a large number
of them would play Camps every day at lunch. From what I understand, Camps is
a regional variation of <a href="http://www.wikihow.com/Play-Kent">Kent</a>.
<a href="#cite_ref-7">&#x21a9;</a>
</li>
<li id="cite_note-8">
I also tried the one at Memphis International Airport because it was near
my gate and my flight was delayed. It's better than most airport food, but
as you might expect, it pales in comparison to the real thing.
<a href="#cite_ref-8">&#x21a9;</a>
</li>
<li id="cite_note-9">
The tour of JPL was thanks to <a href="http://directedplay.com/">Dan Goods</a>,
who I also met at EG7. It was <em>really amazing</em>, and I highly recommend
visiting JPL if you ever get the chance!
<a href="#cite_ref-9">&#x21a9;</a>
</li>
<li id="cite_note-10">
<a href="http://en.wikipedia.org/wiki/Morgan_Freeman">Morgan Freeman</a>
is one of the owners of Ground Zero Blues Club. His mug is
plastered all over
<a href="http://www.groundzerobluesclub.com">groundzerobluesclub.com</a>.
<a href="#cite_ref-10">&#x21a9;</a>
</li>
<li id="cite_note-11">
My best description of catfish bread is that it tastes like cheesy
garlic bread if you were to somehow add catfish to that.
<a href="#cite_ref-11">&#x21a9;</a>
</li>
<li id="cite_note-12">
These are the books I brought to class every day:
<a href="http://www.amazon.com/The-Nature-Code-Simulating-Processing/dp/0985930802?tag=etrepum-20">The Nature of Code: Simulating Natural Systems with Processing</a>,
<a href="http://www.amazon.com/Getting-Started-Processing-Casey-Reas/dp/144937980X?tag=etrepum-20">Getting Started with Processing</a>,
<a href="http://www.amazon.com/The-Computational-Beauty-Nature-Explorations/dp/0262561271?tag=etrepum-20">The Computational Beauty of Nature</a>,
<a href="http://www.amazon.com/Form-Code-Design-Architecture-Briefs/dp/1568989377?tag=etrepum-20">Form+Code in Design, Art, and Architecture</a>
<a href="#cite_ref-12">&#x21a9;</a>
</li>
<li id="cite_note-13">
There was a box in the classroom where students would submit notes of
gratitude or thanks (not anonymously). At the end of each week,
these shout-outs are read aloud to everyone in the class.
<a href="#cite_ref-13">&#x21a9;</a>
</li>
</ol>
</aside>
