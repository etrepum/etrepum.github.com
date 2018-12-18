---
categories:
- compsci
- coursera
- mooc
- education
title: Five great Computer Science courses on Coursera
redirect_from:
- /compsci/coursera/mooc/education/archives/2013/05/07/great-coursera-courses
tags:
- compsci
- coursera
- mooc
- education
---
[Coursera](https://www.coursera.org/) is really fantastic. Like many other
entrepreneurs, I dropped out of college to work. Before Coursera,
I had never taken a real Computer Science course. I've read some of
the Computer Science classics over the years out of general and practical
interest, but I didn't take the time to do the exercises.
I'm not sure how sustainable it is for Coursera and the universities that
participate to give away first-rate courses, but I'll take it while I
can get it!

I'm not taking these courses exactly as intended. I generally just
read the slides and/or notes and do the assignments. I find that video is an
inefficient method for me to learn. I also don't spend much time in
the forums except when I think there's an issue with the material. I'd
really wish Coursera would do something a bit more innovative with
scheduling. I don't see much reason why all students should have to
start a course at the same time and take it at the same pace&hellip;
but that's a topic for another day.

Here are my favorite CS courses that I've taken on Coursera so far:

* [Algorithms: Design and Analysis, Part 1 (Stanford)](#algo)
* [Algorithms, Part I & II (Princeton)](#algs4)
* [Cryptography I (Stanford)](#crypto)
* [The Hardware/Software Interface (UW)](#hwswinterface)
* [Programming Languages (UW)](#proglang)

<h2 id="algo">Algorithms: Design and Analysis, Part 1 (Stanford)</h2>
<a href="https://www.coursera.org/course/algo"
title="Algorithms: Design and Analysis, Part 1 (Stanford)"><img
style="float:right; width:240px; height:135px"
src="/assets/images/2013-05-07/algo-small-icon.hover.png"
alt="Algorithms: Design and Analysis, Part 1 (Stanford)" /></a>
<dl>
<dt>Course URL:</dt>
<dd><a href="https://www.coursera.org/course/algo">coursera.org/course/algo</a> (6 weeks long)</dd>
<dt>Instructor:</dt>
<dd><a href="http://theory.stanford.edu/~tim/">Tim Roughgarden</a></dd>
</dl>

This is an intro theory course. The suggested readings (which I didn't do) are from
four different algorithms books. I was already familiar with most of the
algorithms in the course, with the exception of some graph algorithms such as
[Karger's Minimum Cut Algorithm](http://en.wikipedia.org/wiki/Karger%27s_algorithm)
and [Kosaraju's Two-Pass Algorithm](http://en.wikipedia.org/wiki/Kosaraju's_algorithm)
for computing Strongly Connected Components. I feel like I have a stronger
mathematical understanding of algorithms after taking this course, learning the
[Master theorem](http://en.wikipedia.org/wiki/Master_theorem) was particularly
enlightening.

Unlike many other CS courses, the programming assignments can be done in any
language. For most of the assignments there will be a description of the
problem and some data set to download, and you simply paste in correct output
to a form to verify that your implementation is correct. Not as thorough as
other courses, but the flexibility to use any language was nice. I did them
all in Haskell for practice, although I didn't go though all of the hoops to
ensure I was getting exactly the right asymptotic performance for each
algorithm (such as QuickSort, where you need to use a mutable array to get
the right performance).

The slides are very high quality and easy to understand without the videos.
He posts two versions, you'll want to get the typed ones so you don't have
to decipher any handwriting. For some of the lectures, Tim also posts detailed
and nicely rendered (LaTeX and GraphViz, probably) lecture notes that are
about 3-5 pages each.

<img
style="width: 100%; border: 1px dashed #ccc"
src="/assets/images/2013-05-07/algo-master-method.png"
alt="Algorithms: Design and Analysis slide sample" />

<h2 id="algs4">Algorithms, Part I & II (Princeton)</h2>
<a href="https://www.coursera.org/course/algs4partI"
title="Algorithms, Part I (Princeton)"><img
style="float:right; width:240px; height:135px"
src="/assets/images/2013-05-07/algs4-small-icon.hover.png"
alt="Algorithms, Part I (Princeton)" /></a>
<dl>
<dt>Course URLs:</dt>
<dd><a href="https://www.coursera.org/course/algs4partI">coursera.org/course/algs4partI</a> (6 weeks),<br/>
    <a href="https://www.coursera.org/course/algs4partII">coursera.org/course/algs4partII</a> (7 weeks),<br/>
    <a href="http://algs4.cs.princeton.edu/">Algorithms, 4th Edition</a> (<a href=" http://www.amazon.com/gp/product/032157351X?ie=UTF8&camp=213733&creative=393185&creativeASIN=032157351X&linkCode=shr&tag=etrepum-20&creativeASIN=032157351X">Amazon</a>)
</dd>
<dt>Instructors:</dt>
<dd><a href="http://www.cs.princeton.edu/~wayne/">Kevin Wayne</a>,
    <a href="http://www.cs.princeton.edu/~rs/">Robert Sedgewick</a>
</dd>
</dl>

While these are technically two separate courses they have the same
topic, instructors, and style so I have grouped them together. Their focus is
more application than theory, although it has a good basis in theory as well.
The course is based on the classic
[Algorithms, 4th Edition](http://algs4.cs.princeton.edu/) ([Amazon](http://www.amazon.com/gp/product/032157351X?ie=UTF8&camp=213733&creative=393185&creativeASIN=032157351X&linkCode=shr&tag=etrepum-20&creativeASIN=032157351X)) textbook, written by the instructors.
In these courses I learned Java (yes, I managed to basically avoid it for
this long) and implemented a number of interesting algorithms and data
structures that I hadn't done before such as
[Union Find](http://en.wikipedia.org/wiki/Disjoint-set_data_structure),
[Graham Scan](http://en.wikipedia.org/wiki/Graham_scan),
[Seam Carving](http://en.wikipedia.org/wiki/Seam_carving), and the
[Burrows-Wheeler transform](http://en.wikipedia.org/wiki/Burrows%E2%80%93Wheeler_transform).
After this course, I'm a lot better at reading Java code and its memory model,
and I have some more algorithms in my tool belt.

The programming assignments for this course are all in Java. While Java isn't
my favorite, their grading system is excellent. Assignments are graded on
correctness, memory, timing and style. They instrument the JVM such that they
can determine whether your implementation has roughly the same (or better)
time and space usage as their reference implementation. The assignments use a
standard library written by the instructors for the textbook that make it
straightforward to do things like IO without diving.into.java.namespace.hell.
The second course only has five programming assignments, the last two weeks are
mostly theory and only have review quizzes.

The slides for this course are wonderful. They're very well prepared, and have
some great historical anecdotes, and even a bit of humor. The videos for this
course were not even remotely necessary because the slides are so good.

<img
style="width: 100%; border: 1px dashed #ccc"
src="/assets/images/2013-05-07/algs4-kdtree.png"
alt="Algorithms slide sample" />

<h2 id="hwswinterface">The Hardware/Software Interface (UW)</h2>
<a href="https://www.coursera.org/course/hwswinterface"
title="The Hardware/Software Interface (UW)"><img
style="float:right; width:240px; height:135px"
src="/assets/images/2013-05-07/hwswinterface-small-icon.hover.png"
alt="The Hardware/Software Interface (UW)" /></a>
<dl>
<dt>Course URL:</dt>
<dd><a href="https://www.coursera.org/course/hwswinterface">coursera.org/course/hwswinterface</a> (8 weeks)</dd>
<dt>Instructors:</dt>
<dd><a href="http://homes.cs.washington.edu/~gaetano/">Gaetano Borriello</a>,
    <a href="http://homes.cs.washington.edu/~luisceze/">Luis Ceze</a>
</dd>
</dl>

This course covers topics at the level of C and below. It starts off with
pointer arithmetic and bit manipulation in C, and quickly goes down to
reverse engineering x86-64 assembly code with GDB. I'm only six weeks
in to this course so far, but I wanted to include it anyway because I'm
really enjoying it. The course is not related to the classic textbook
with a similar name,
[Computer Organization and Design: The Hardware/Software Interface](http://www.amazon.com/gp/product/0123747503?ie=UTF8&camp=213733&creative=393185&creativeASIN=0123747503&linkCode=shr&tag=etrepum-20&=books&qid=1367952237&sr=1-1).

The labs for this course are done in a 64-bit Linux VM. The first few
labs are in C. Their grader checks correctness and ensures that
the assignment is done within the given constraints. For example, in the
bit manipulation lab it verifies that your implementation uses only the
allowed operators for each function. The next lab is an x86-64 assembly
lab where you are given a compiled executable "bomb" and you have to reverse
engineer what the correct input to the executable is in order to "defuse" it.
I learned quite a bit about x86-64 assembly and calling conventions in that
lab.

The slides for this course are also great. Very easy to read with lots of
diagrams. I was surprised at how up to date the material is, I didn't expect
to be learning x86-64.

<img
style="width: 100%; border: 1px dashed #ccc"
src="/assets/images/2013-05-07/hwswinterface-mode.png"
alt="Hardware/Software Interface slide sample" />

<h2 id="crypto">Cryptography I (Stanford)</h2>
<a href="https://www.coursera.org/course/crypto"
title="Cryptography I (Stanford)"><img
style="float:right; width:240px; height:135px"
src="/assets/images/2013-05-07/crypto-small-icon.hover.png"
alt="Cryptography I (Stanford)" /></a>
<dl>
<dt>Course URL:</dt>
<dd><a href="https://www.coursera.org/course/crypto">coursera.org/course/crypto</a></dd>
<dt>Instructor:</dt>
<dd><a href="http://crypto.stanford.edu/~dabo/">Dan Boneh</a></dd>
</dl>

This course covers the theory and application of cryptography. Dan Boneh
does a fantastic job covering how cryptography works in theory and practice,
and does a great job touching on some of the history as well. I learned a lot
more about the math behind cryptosystems from this course.

The programming assignments in this course are all optional, for a tiny bit of
extra credit. They can be done in any language, although I'd highly recommend
one with good big integer arithmetic like Python or Haskell. I used Haskell,
with a bit of Python to verify solutions. Most of them were cryptanalysis related.
Given some cipher text generated with some known weakness, your mission is to
recover the original plain text. I didn't expect to learn any code breaking in
this course, but I had a ton of fun doing it!

The slides are excellent. The algorithms are clearly presented, and the
historical anecdotes are often paired with photos. The cryptographer's mantra
of "do not even implement crypto primitives yourself&hellip;" is present in
quite a few of the lectures alongside examples of improperly implemented crypto.

<img
style="width: 100%; border: 1px dashed #ccc"
src="/assets/images/2013-05-07/crypto-padding.png"
alt="Cryptography slide sample" />

<h2 id="proglang">Programming Languages (UW)</h2>
<a href="https://www.coursera.org/course/proglang"
title="Programming Languages (UW)"><img
style="float:right; width:240px; height:135px"
src="/assets/images/2013-05-07/proglang-small-icon.hover.png"
alt="Programming Languages (UW)" /></a>
<dl>
<dt>Course URL:</dt>
<dd><a href="https://www.coursera.org/course/proglang">coursera.org/course/proglang</a> (10 weeks)</dd>
<dt>Instructor:</dt>
<dd><a href="http://homes.cs.washington.edu/~djg/">Dan Grossman</a></dd>
</dl>

This course covers ML, Racket, and Ruby. I've worked with similar languages,
but the syntax for each of these was new to me. I'm not a big fan of any of
these languages after using them for a bit, but it was nice to learn about ML's
module system and Racket's structs. I definitely still prefer Python or
JavaScript to Ruby. I don't know what it is about Ruby's syntax and standard
library, but it's not for me.

The programming assignments for this course are done with whichever language
language the lectures are about. The novel part about the labs here isn't
that they are automatically graded for correctness, but there's a peer
review component to assess the style of your assignments. After the due date
for each assignment you have to review the work of three other students in the
class. I think this is a great way to get students ready for code review,
although it's missing that critical feedback loop where you have an opportunity
to fix the style of the code.

The course material for this class is available in both slides and summaries. I
decided to just read the summaries, so I don't have anything to say about the
slides. The summaries are written in a narrative style and are 20-30
pages per week. The formatting is very nice, looks like LaTeX. I found the
summaries to be quick and easy to read.

<img
style="width: 100%; border: 1px dashed #ccc"
src="/assets/images/2013-05-07/proglang-extending.png"
alt="Programming Languages summary text sample" />
