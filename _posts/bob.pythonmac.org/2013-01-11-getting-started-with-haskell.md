---
categories: [haskell]
category: archives
layout: post
tags: [haskell]
title: Getting Started with Haskell
---
{% include JB/setup %}

I've been having a lot of fun learning Haskell these past few months, but
getting started isn't quite as straight-forward as it could be. I had the
good fortune to work at the right place at the right time and was able to take
[Bryan O'Sullivan's](http://www.serpentine.com/) Haskell class at Facebook,
but it's definitely possible to get started on your own. While you can play a
bit with Haskell at [Try Haskell](http://tryhaskell.org/) you'll eventually
want to get GHC installed on your own machine.

* [Install the Haskell Platform (GHC)](#install-ghc)
* [Set up Cabal](#setup-cabal)
* [Install Cabal-dev (sandbox build tool)](#install-cabal-dev)
* [Install ghc-mod (better Emacs/Vim support)](#install-ghc-mod)
* [How to install tools with cabal-dev](#how-to-install-tools-with-cabal-dev)
* [Configure GHCi](#configure-ghci)
* [Hackage is fragile, but there are (unofficial) mirrors](#hackage-mirrors)
* [Starting a project (with cabal-dev)](#starting-a-project)
* [GHCi basics](#ghci-basics)
* [Recommended Reading](#recommended-reading)

<h1 id="install-ghc">Install the Haskell Platform (GHC)</h1>

The Haskell Platform is the Glasgow Haskell Compiler (GHC) including the
"batteries included" standard library. GHC not the only Haskell compiler,
but this is the one that you want to learn. Another implementation of note is
[Hugs](http://www.haskell.org/hugs/), which is more for teaching than for
production code.

These instructions are written for Mac OS X 10.8 using
[Homebrew](http://mxcl.github.com/homebrew/) (and a recent version of Xcode),
but it should be easy to figure out how to do it on other platforms starting from
[Haskell Platform](http://www.haskell.org/platform/). The current version of
Haskell Platform at this time is 2012.4.0.0.

<pre class="light bash literal-block">
$ brew install haskell-platform
</pre>

<h1 id="setup-cabal">Set up Cabal</h1>

[Cabal](http://www.haskell.org/cabal/) is Haskell's
*Common Architecture for Building Applications and Libraries*. In combination
with [Hackage](http://hackage.haskell.org/) it is similar in purpose to tools
such as CPAN for Perl, pip for Python, or gem for Ruby. You'll probably be
disappointed, but it's not that bad.

When you end up installing packages with cabal, it will install them
to `~/.cabal/` and the scripts will go into `~/.cabal/bin/`. You
should go ahead and add this to your PATH environment
variable now. Something like this will suffice, but it depends on how
you like to set up your shell profile:

<pre class="light bash literal-block">
$ echo 'export PATH=$HOME/.cabal/bin:$PATH' >> ~/.bashrc
</pre>

Before doing anything else with cabal, you'll need to bootstrap the
list of available packages. You'll want to run this occasionally,
particularly before installing or upgrading new packages.

<pre class="light bash literal-block">
$ cabal update
</pre>

At this point you'll have a `~/.cabal/config` that doesn't have
library-profiling turned on. You'll likely want this later, and if you don't
do it now then you'll have to rebuild everything later. To turn it on edit
`~/.cabal/config` and change
`-- library-profiling: False` to
`library-profiling: True`.

<pre class="light bash literal-block">
$ for f in ~/.cabal/config; do \
    cp $f $f.old && \
    sed -E 's/(-- )?(library-profiling: )False/\2True/' < $f.old > $f; \
done
</pre>

Before installing anything else, you'll need to install the Cabal installer:

<pre class="light bash literal-block">
$ cabal install cabal-install
</pre>

<h1 id="install-ghc-mod">Install ghc-mod (better Emacs/Vim support)</h1>

[ghc-mod](http://www.mew.org/~kazu/proj/ghc-mod/en/) is what you want to install to integrate GHC with Emacs or Vim. You might also be able to use Sublime Text 2 and ghc-mod via [SublimeHaskell](https://github.com/SublimeHaskell/SublimeHaskell). I've only tried the Emacs integration so far. Vim users may want to try [hdevtools](https://github.com/bitc/hdevtools) as it's much faster and just as accurate (see [kamatsu's comment](http://www.reddit.com/r/haskell/comments/16fegr/getting_started_with_haskell/c7viysx)).

<pre class="light bash literal-block">
$ cabal install ghc-mod
</pre>

You'll obviously have to configure it for your Emacs, and I'll leave that up to you (my current [~/.emacs.d](https://github.com/etrepum/emacs.d) for reference).

<h1 id="install-cabal-dev">Install Cabal-dev (sandbox build tool)</h1>

[Cabal-dev](https://github.com/creswick/cabal-dev) is a tool that helps you sandbox installation of Haskell software. It is similar in purpose to virtualenv for Python or rvm for Ruby, but the usage is quite a bit different. This is the tool that will save you from "Cabal Hell", where you can't install a package because some other package you have installed has conflicting dependencies.

Use `cabal-dev` instead of just `cabal` to build stuff whenever possible. The major trade-off is that you will spend (a lot) more time compiling packages that you already have installed somewhere else (and waste some disk), but this is almost certainly a fair trade.

Normally installing cabal-dev would be a simple `cabal install cabal-dev`, but until [cabal-dev #74](https://github.com/creswick/cabal-dev/issues/74) is fixed, you'll need to build and install from source:

<pre class="light bash literal-block">
$ git clone https://github.com/creswick/cabal-dev.git /tmp/cabal-dev-src && \
    (cd /tmp/cabal-dev-src; cabal install) && \
    rm -rf /tmp/cabal-dev-src
</pre>

There's some work in progress for adding
[Sandboxed Builds and Isolated Environments](http://hackage.haskell.org/trac/hackage/wiki/SandboxedBuildsAndIsolatedEnvironments)
support to cabal-install, so the cabal-dev material here will likely
bit rot in a few months (years?).

<h1 id="how-to-install-tools-with-cabal-dev">How to install tools with cabal-dev</h1>

If you want to try out a tool, but don't want to pollute your Haskell installation, you can just use cabal-dev! By default, cabal-dev's sandbox is `./cabal-dev`, but you can put it anywhere. In this example I'll install [darcs](http://darcs.net/) 2.8.2 (a distributed version control system written in Haskell) into ``/usr/local/Cellar/darcs/2.8.2`` and have Homebrew create the symlinks for me. On other platforms you might want to use your own directory structure and manage your `PATH` instead. 

<pre class="light bash literal-block">
$ cabal-dev install -s /usr/local/Cellar/darcs/2.8.2 darcs-2.8.2
$ brew link --overwrite darcs
</pre>

Bam! Now darcs is on your `PATH` and you don't have to worry about version conflicts. Well, you do sadly still run into them, just not as much. Specifically, cabal-dev installs packages in such a way that they are all 'top-level' in a given sandbox. This means that if two packages have common dependencies (VERY common), then they'll stomp on each other's symlinks to things like license files and documentation of the dependencies. It's mostly harmless to use `--overwrite` in this way, but you might want to check with `--overwrite --dry-run` first. Annoying, but probably won't ruin your day.

If you want to see what versions of a darcs are available, use `cabal info darcs` and look for the `Versions available:` section.

Other fun Haskell tools to try (in no particular order):

* [pandoc](http://johnmacfarlane.net/pandoc/) - the swiss-army knife of markup format converters (markdown, reStructuredText, org-mode, LaTeX, etc.)
* [gitit](http://gitit.net/) - a wiki backed by a git, darcs or mercurical filestore
* [pronk](https://github.com/bos/pronk) - a HTTP load testing tool, like ab or httperf, only more modern and simpler to deal with

For packages like pronk that aren't currently in Hackage, a cabal-dev installation will look more like this:

<pre class="light bash literal-block">
$  git clone https://github.com/bos/pronk.git /tmp/pronk-src && \
    (cd /tmp/pronk-src; \
     cabal-dev install -s /usr/local/Cellar/pronk/$(git rev-parse --short HEAD)) && \
    rm -rf /tmp/pronk-src
</pre>

<h1 id="configure-ghci">Configure GHCi</h1>

`ghci` is the GHC interactive interpreter (REPL, similar to typing `python` or `irb` in a shell). For real documentation, see the [GHC Users Guide](http://www.haskell.org/ghc/docs/7.4.2/html/users_guide/index.html) ([Chapter 2. Using GHCi](http://www.haskell.org/ghc/docs/7.4.2/html/users_guide/ghci.html)) . You'll be spending a lot of time there playing with your code, you probably want to set up a shorter prompt. It starts off looking like this:

<pre class="light haskell literal-block">
Prelude>
</pre>

Once you start importing modules the prompt keeps getting longer and you really just don't need that in your life.

<pre class="light haskell literal-block">
Prelude> :m + Data.List
Prelude Data.List> :m + Data.Maybe
Prelude Data.List Data.Maybe> 
</pre>

The configuration file for this is [the .ghci file](http://www.haskell.org/ghc/docs/7.4.2/html/users_guide/ghci-dot-files.html). I use a very simple ASCII prompt, some people like to make theirs look like `λ>`.

<pre class="light bash literal-block">
echo ':set prompt "h> "' >> ~/.ghci
</pre>

You could also issue the `:set prompt "h> "` command each time you use GHCi, but that gets old.

<pre class="light haskell literal-block">
$ ghci
h> putStrLn "Hello World!"
Hello World!
h>
</pre>

<h1 id="hackage-mirrors">Hackage is fragile, but there are (unofficial) mirrors</h1>

Sadly, Hackage isn't currently the pinnacle of reliability. I don't know what the problem
is, but hopefully they do something about it soon. There is a workaround (see also
[Working around Hackage Outages](http://comonad.com/reader/2012/hackage-mirror/)),
you can just use the repo from hdiff at
[hdiff.luite.com](http://hdiff.luite.com/) or from
[hackage.csc.stanford.edu](http://hackage.scs.stanford.edu/).

Change this line in `~/.cabal/config`:
<pre class="light plain literal-block">
remote-repo: hackage.haskell.org:http://hackage.haskell.org/packages/archive
</pre>

To something like this:

<pre class="light plain literal-block">
-- TODO When hackage is back up, set back to hackage.haskell.org!
-- remote-repo: hackage.haskell.org:http://hackage.haskell.org/packages/archive
remote-repo: hdiff.luite.com:http://hdiff.luite.com/packages/archive
-- remote-repo: hackage.csc.stanford.edu:http://hackage.scs.stanford.edu/packages/archive
</pre>

After you've changed your remote-repo setting, you'll need to update the package list

<pre class="light bash literal-block">
$ cabal update
</pre>

Don't forget to change it back later!

<h1 id="starting-a-project">Starting a project (with cabal-dev)</h1>

You'd figure this out eventually, but a quick way to start out a project is to
just go ahead and start off with cabal-dev. Here's how you would do that
for a trivial program.

For your own projects, you may want to remove the `-n` option and let cabal
ask you which options you want to choose. The `-n` option uses all the
defaults without any prompting.

<pre class="light bash literal-block">
$ mkdir -p ~/src/hs-hello-world
$ cd ~/src/hs-hello-world
$ touch LICENSE
$ cabal init -n --is-executable
</pre>

This will generate a `Setup.hs` and `hs-hello-world.cabal`. The next step is to
change the `main-is:` line so it knows what source file to build your
executable from. The end result should look something like this:

## `hs-hello-world.cabal`

<pre class="light plain literal-block">
-- Initial hs-hello-world.cabal generated by cabal init.  For further 
-- documentation, see http://haskell.org/cabal/users-guide/

name:                hs-hello-world
version:             0.1.0.0
-- synopsis:            
-- description:         
license:             AllRightsReserved
license-file:        LICENSE
-- author:              
-- maintainer:          
-- copyright:           
-- category:            
build-type:          Simple
cabal-version:       >=1.8

executable hs-hello-world
  main-is:             HelloWorld.hs
  -- other-modules:       
  build-depends:       base ==4.5.*
</pre>

Then create a HelloWorld.hs, maybe something that looks like this:

## `HelloWorld.hs`

<pre class="light haskell literal-block">
main :: IO ()
main = putStrLn "Hello, world!"
</pre>

You can build and "install" it into a local sandbox like this:

<pre class="light bash literal-block">
$ cabal-dev install
Resolving dependencies...
Configuring hs-hello-world-0.1.0.0...
Building hs-hello-world-0.1.0.0...
Preprocessing executable 'hs-hello-world' for hs-hello-world-0.1.0.0...
Installing executable(s) in /Users/bob/src/hs-hello-world/cabal-dev//bin
Installed hs-hello-world-0.1.0.0
$ ./cabal-dev/bin/hs-hello-world
Hello, world!
</pre>

The executable is large for what it does, but it's also statically linked. You
can copy that file over to any other machine with the same OS and
architecture and it'll Just Work.

You might save a tiny bit of time by skipping the install step:

<pre class="light bash literal-block">
$ cabal-dev configure
Resolving dependencies...
Configuring hs-hello-world-0.1.0.0...
$ cabal-dev build
Building hs-hello-world-0.1.0.0...
Preprocessing executable 'hs-hello-world' for hs-hello-world-0.1.0.0...
[1 of 1] Compiling Main             ( HelloWorld.hs, dist/build/hs-hello-world/hs-hello-world-tmp/Main.o )
Linking dist/build/hs-hello-world/hs-hello-world ...
$ ./dist/build/hs-hello-world/hs-hello-world
Hello, world!
</pre>

Since this project has no dependencies that you want to install locally, you
can take some shortcuts.

Run it interpreted, no compilation step needed:

<pre class="light bash literal-block">
$ runghc HelloWorld.hs
Hello, world!
</pre>

<pre class="light haskell literal-block">
$ ghci
GHCi, version 7.4.2: http://www.haskell.org/ghc/  :? for help
Loading package ghc-prim ... linking ... done.
Loading package integer-gmp ... linking ... done.
Loading package base ... linking ... done.
Prelude> :load HelloWorld
[1 of 1] Compiling Main             ( HelloWorld.hs, interpreted )
Ok, modules loaded: Main.
*Main> main
Hello, world!
</pre>

And you can build it without cabal-dev (or cabal) at all:

<pre class="light bash literal-block">
$ runghc Setup.hs configure
Configuring hs-hello-world-0.1.0.0...
$ runghc Setup.hs build
Building hs-hello-world-0.1.0.0...
Preprocessing executable 'hs-hello-world' for hs-hello-world-0.1.0.0...
[1 of 1] Compiling Main             ( HelloWorld.hs, dist/build/hs-hello-world/hs-hello-world-tmp/Main.o )
Linking dist/build/hs-hello-world/hs-hello-world ...
</pre>

But for a more complicated project, you can use `cabal-dev ghci` (after `cabal-dev configure && cabal-dev build`).
Note that it loads your executable's source into the interpreter automatically:

<pre class="light haskell literal-block">
$ cabal-dev ghci

on the commandline:
    Warning: -O conflicts with --interactive; -O ignored.
GHCi, version 7.4.2: http://www.haskell.org/ghc/  :? for help
Loading package ghc-prim ... linking ... done.
Loading package integer-gmp ... linking ... done.
Loading package base ... linking ... done.
Ok, modules loaded: Main.
h> main
Hello, world!
</pre>

<h1 id="ghci-basics">GHCi Basics</h1>

Some essential GHCi tricks you'll want to know, you'll find more in
[Chapter 2. Using GHCi](http://www.haskell.org/ghc/docs/7.4.1/html/users_guide/ghci.html).

## `:t` shows the type of an expression

<pre class="light haskell literal-block">
h> :t main
main :: IO ()
h> :t map
map :: (a -> b) -> [a] -> [b]
h> :t map (+1)
map (+1) :: Num b => [b] -> [b]
</pre>

## `:i` shows information about a name (function, typeclass, type, ...)

<pre class="light haskell literal-block">
h> :i Num
class Num a where
  (+) :: a -> a -> a
  (*) :: a -> a -> a
  (-) :: a -> a -> a
  negate :: a -> a
  abs :: a -> a
  signum :: a -> a
  fromInteger :: Integer -> a
  	-- Defined in `GHC.Num'
instance Num Integer -- Defined in `GHC.Num'
instance Num Int -- Defined in `GHC.Num'
instance Num Float -- Defined in `GHC.Float'
instance Num Double -- Defined in `GHC.Float'
h> :info map
map :: (a -> b) -> [a] -> [b] 	-- Defined in `GHC.Base'
h> :info Int
data Int = ghc-prim:GHC.Types.I# ghc-prim:GHC.Prim.Int#
  	-- Defined in `ghc-prim:GHC.Types'
instance Bounded Int -- Defined in `GHC.Enum'
instance Enum Int -- Defined in `GHC.Enum'
instance Eq Int -- Defined in `ghc-prim:GHC.Classes'
instance Integral Int -- Defined in `GHC.Real'
instance Num Int -- Defined in `GHC.Num'
instance Ord Int -- Defined in `ghc-prim:GHC.Classes'
instance Read Int -- Defined in `GHC.Read'
instance Real Int -- Defined in `GHC.Real'
instance Show Int -- Defined in `GHC.Show'
</pre>

## `:m` add a module to the scope

<pre class="light haskell literal-block">
h> :m + Data.List
h> sort [10,9..1]
[1,2,3,4,5,6,7,8,9,10]
</pre>

## `:l` load a module, `:r` to reload

<pre class="light haskell literal-block">
h> :! echo 'hello = print "hello"' > Hello.hs
h> :l Hello
[1 of 1] Compiling Main             ( Hello.hs, interpreted )
Ok, modules loaded: Main.
h> hello
"hello"
h> :! echo 'hello = print "HELLO"' > Hello.hs
h> :r
[1 of 1] Compiling Main             ( Hello.hs, interpreted )
Ok, modules loaded: Main.
h> hello
"HELLO"
</pre>

<h1 id="recommended-reading">Recommended Reading</h1>

These are the books and sites that I found particularly useful while
trying to learn Haskell myself.

## Books

<a style="float: left; width: 130px" href="http://www.amazon.com/gp/product/1593272839/ref=as_li_ss_il?ie=UTF8&tag=etrepum-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=1593272839"><img border="0" src="http://ws.assoc-amazon.com/widgets/q?_encoding=UTF8&Format=_SL160_&ASIN=1593272839&MarketPlace=US&ID=AsinImage&WS=1&tag=etrepum-20&ServiceVersion=20070822" width="121" height="160"></a>
<a href="http://www.amazon.com/gp/product/1593272839/ref=as_li_ss_tl?ie=UTF8&tag=etrepum-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=1593272839">Learn You a Haskell for Great Good!: A Beginner's Guide</a>
<img src="http://www.assoc-amazon.com/e/ir?t=etrepum-20&l=as2&o=1&a=1593272839" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
<br />
I found this one to be a great starting point, I would recommend that you
read it first. It doesn't go so deep that you feel like you REALLY understand
GHC works, but I felt pretty comfortable reading and writing Haskell after
getting through this.
<div style="float: clear"></div>

<a style="float: left; padding-right: 10px; width: 130px;" href="http://www.amazon.com/gp/product/0596514980/ref=as_li_ss_il?ie=UTF8&tag=etrepum-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=0596514980"><img border="0" src="http://ws.assoc-amazon.com/widgets/q?_encoding=UTF8&Format=_SL160_&ASIN=0596514980&MarketPlace=US&ID=AsinImage&WS=1&tag=etrepum-20&ServiceVersion=20070822" width="122" height="160"></a>
<a href="http://www.amazon.com/gp/product/0596514980/ref=as_li_ss_tl?ie=UTF8&tag=etrepum-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=0596514980">Real World Haskell</a>
<img src="http://www.assoc-amazon.com/e/ir?t=etrepum-20&l=as2&o=1&a=0596514980" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
<br />
This book is massive in size and scope, but is still very accessible for
beginners. It'll teach you how to do Real World things with Haskell:
writing tests, profiling, IO, concurrency, etc. I'm still working through
this one, but it's a must-read.
<div style="float: clear"></div>

## Sites

* [CS240h: Functional Systems in Haskell](http://www.scs.stanford.edu/11au-cs240h/)
  was a Haskell class at Stanford taught by
  [David Mazières](http://www.scs.stanford.edu/~dm/) and
  [Bryan O'Sullivan](http://www.serpentine.com/). It's similar
  (but larger in scope) to the class I took at Facebook. The lecture notes and
  syllabus here are fantastic, go through them!
* [Real World Haskell](http://book.realworldhaskell.org/)
* [Learn You a Haskell](http://learnyouahaskell.com/)
* [haskell.org](http://www.haskell.org/) is a great entry point, you can find
  all of the links in this list and MANY more from there. Plan to spend a lot
  of time browsing this wiki!
* [H-99](http://www.haskell.org/haskellwiki/H-99:_Ninety-Nine_Haskell_Problems)
  has a bunch of little problems to work on, much like the Euler project.
  These should be pretty straightforward to do after reading LYAH.
* [Typeclassopedia](http://www.haskell.org/haskellwiki/Typeclassopedia)
  is a great resource for learning about many of the prominent
  typeclasses in the Haskell Platform
* [Hoogle](http://www.haskell.org/hoogle/) is a Haskell API search engine
  that supports searching by type signature! I spend a lot of time
  with this one
* [Hayoo!](http://holumbus.fh-wedel.de/hayoo/hayoo.html) is another Haskell API
  search engine, worth a shot if you can't find what you're looking
  for on Hoogle
* [HWN](http://www.haskell.org/haskellwiki/HWN) is a weekly Haskell
  newsletter that gives you the highlights of the mailing lists,
  stackoverflow, reddit, etc.
* [Haskell :: Reddit](http://www.reddit.com/r/haskell/) is the
  subreddit for Haskell
* [stackoverflow - haskell](http://stackoverflow.com/questions/tagged/haskell)
  The questions tagged Haskell on stackoverflow are often worth
  reading (although to be honest I usually end up here from HWN)
* [C9 Lectures: FP Fundamentals](http://channel9.msdn.com/Series/C9-Lectures-Erik-Meijer-Functional-Programming-Fundamentals/Lecture-Series-Erik-Meijer-Functional-Programming-Fundamentals-Chapter-1)
  13 lectures on Functional Programming Fundamentals (in Haskell) by
  Dr. Erik Meijer (I haven't watched them yet, but they were
  [suggested by Adam Breen](https://www.facebook.com/etrepum/posts/10151380112306253?comment_id=26337628&offset=0&total_comments=1)).

## IRC

* #haskell on Freenode is where you'll find a few hundred people
   interested in Haskell at any given time. Great place for help.

## Suggestions?

I plan to try and keep this current based on suggestions. Let me know if I'm
missing anything of note! I'm not trying to be comprehensive, I think the
Haskell wiki does a far better job of that. These are just intended to be
highlights.
