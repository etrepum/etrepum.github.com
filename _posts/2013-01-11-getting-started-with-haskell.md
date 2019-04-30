---
categories:
- haskell
title: Getting Started with Haskell
redirect_from:
- /haskell/archives/2013/01/11/getting-started-with-haskell
tags:
- haskell
---
I've been having a lot of fun learning Haskell these past few months, but
getting started isn't quite as straight-forward as it could be. I had the
good fortune to work at the right place at the right time and was able to take
[Bryan O'Sullivan's](http://www.serpentine.com/) Haskell class at Facebook,
but it's definitely possible to get started on your own. While you can play a
bit with Haskell at [Try Haskell](http://tryhaskell.org/) you'll eventually
want to get GHC installed on your own machine.

* [Install the Haskell Platform (GHC)](#install-ghc)
* [Set up Cabal](#setup-cabal)
* [Install ghc-mod (better Emacs/Vim support)](#install-ghc-mod)
* [How to install tools with cabal sandbox](#how-to-install-tools-with-cabal-sandbox)
* [Configure GHCi](#configure-ghci)
* [Hackage is fragile, but there are (unofficial) mirrors](#hackage-mirrors)
* [Starting a project (with cabal sandbox)](#starting-a-project)
* [GHCi basics](#ghci-basics)
* [Recommended Reading](#recommended-reading)

<h1 id="install-ghc">Install the Haskell Platform (GHC)</h1>

The Haskell Platform is the Glasgow Haskell Compiler (GHC) including the
"batteries included" standard library. GHC not the only Haskell compiler,
but this is the one that you want to learn. Another implementation of note is
[Hugs](http://www.haskell.org/hugs/), which is more for teaching than for
production code.

These instructions are written for Mac OS X 10.9 using
[Homebrew](http://brew.sh) (and a recent version of Xcode),
but it should be easy to figure out how to do it on other platforms starting from
[Haskell Platform](http://www.haskell.org/platform/).

<pre class="light bash literal-block">
$ brew install ghc cabal-install
</pre>

At time of this writing, the `ghc` package is at version 7.8.4, and
`cabal-install` at 1.22.0.0. The Haskell Platform installer for all platforms
is version 2014.2.0.0.

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

<h1 id="install-ghc-mod">Install ghc-mod (better Emacs/Vim support)</h1>

[ghc-mod](http://www.mew.org/~kazu/proj/ghc-mod/en/) is what you want to install to integrate GHC with Emacs or Vim. You might also be able to use Sublime Text 2 and ghc-mod via [SublimeHaskell](https://github.com/SublimeHaskell/SublimeHaskell). I've only tried the Emacs integration so far. Vim users may want to try [hdevtools](https://github.com/bitc/hdevtools) as it's much faster and just as accurate (see [kamatsu's comment](http://www.reddit.com/r/haskell/comments/16fegr/getting_started_with_haskell/c7viysx)).

<pre class="light bash literal-block">
$ cabal install ghc-mod
</pre>

You'll obviously have to configure it for your Emacs, and I'll leave that up to you (my current [~/.emacs.d](https://github.com/etrepum/emacs.d) for reference).
There are numerous Vim plugins you might evaluate, a one-shot starter setup using ghc-mod is [haskell-vim-now](https://github.com/begriffs/haskell-vim-now) or you may look at its constituent parts to kickstart a do-it-yourself configuration.

<h1 id="how-to-install-tools-with-cabal-sandbox">How to install tools with <code>cabal sandbox</code></h1>

`cabal sandbox` is a tool that helps you isolate project dependencies, and can also be used to sandbox installation of Haskell software. It is similar in purpose to virtualenv for Python or rvm for Ruby, but the usage is a bit different. This is the tool that will save you from "Cabal Hell", where you can't install a package because some other package you have installed has conflicting dependencies.

If you want to try out a tool, but don't want to pollute your Haskell installation, you can just use `cabal sandbox`! By default `cabal sandbox` creates a `.cabal-sandbox` directory under the current working directory, for use in each of your own projects, but you can create sandboxes anywhere. In this example I'll install [darcs](http://darcs.net/) 2.8.5 (a distributed version control system written in Haskell) into ``/usr/local/Cellar/darcs/2.8.5`` and have Homebrew create the symlinks for me. On other platforms you might want to use your own directory structure, such as `/opt/local`, and manage your `PATH` instead.

<pre class="light bash literal-block">
$ mkdir -p /usr/local/Cellar/darcs/2.8.5
$ cd !$
$ cabal sandbox init --sandbox .
$ cabal install darcs-2.8.5
$ brew link --overwrite darcs
</pre>

Bam! Now darcs is on your `PATH` and you don't have to worry about version conflicts. Well, you do sadly still run into them, just not as much. Specifically, `cabal sandbox` installs packages in such a way that they are all 'top-level' in a given sandbox (and this is why we specify `--sandbox .` for `init` above, to override placement into a child `.cabal-sandbox` directory). This means that if two packages have common dependencies (VERY common), then they'll stomp on each other's symlinks to things like license files and documentation of the dependencies. It's mostly harmless to use `--overwrite` in this way, but you might want to check with `--overwrite --dry-run` first. Annoying, but probably won't ruin your day.

If you want to see what versions of a darcs are available, use `cabal info darcs` and look for the `Versions available:` section.

Other fun Haskell tools to try (in no particular order):

* [pandoc](http://johnmacfarlane.net/pandoc/) - the swiss-army knife of markup format converters (markdown, reStructuredText, org-mode, LaTeX, etc.)
* [gitit](http://gitit.net/) - a wiki backed by a git, darcs or mercurical filestore
* [pronk](https://github.com/bos/pronk) - a HTTP load testing tool, like ab or httperf, only more modern and simpler to deal with

For packages like pronk that aren't currently in Hackage, a sandbox installation will look more like this:

<pre class="light bash literal-block">
$ git clone https://github.com/bos/pronk.git /tmp/pronk-src && pushd /tmp/pronk-src
$ version=$(git rev-parse --short HEAD)
$ export CABAL_SANDBOX_CONFIG=/usr/local/Cellar/pronk/$version/cabal.sandbox.config
$ cabal sandbox init --sandbox=/usr/local/Cellar/pronk/$version
$ cabal install
$ popd && rm -rf /tmp/pronk-src && unset CABAL_SANDBOX_CONFIG
</pre>

Use `cabal sandbox` instead of just `cabal install` to build stuff whenever possible. The major trade-off is that you will spend (a lot) more time compiling packages that you already have installed somewhere else (and waste some disk), but this is almost certainly a fair trade.

We will have a further look at using Cabal sandboxes for dependency isolation of your own projects further below.

<h1 id="configure-ghci">Configure GHCi</h1>

`ghci` is the GHC interactive interpreter (REPL, similar to typing `python` or `irb` in a shell). For real documentation, see the [GHC Users Guide](https://downloads.haskell.org/~ghc/7.8.4/docs/html/users_guide/index.html) ([Chapter 2. Using GHCi][using ghci]). You'll be spending a lot of time there playing with your code, you probably want to set up a shorter prompt. It starts off looking like this:

<pre class="light haskell literal-block">
Prelude>
</pre>

Once you start importing modules the prompt keeps getting longer and you really just don't need that in your life.

<pre class="light haskell literal-block">
Prelude> :m + Data.List
Prelude Data.List> :m + Data.Maybe
Prelude Data.List Data.Maybe>
</pre>

The configuration file for this is [the .ghci file](https://downloads.haskell.org/~ghc/7.8.4/docs/html/users_guide/ghci-dot-files.html). I use a very simple ASCII prompt, some people like to make theirs look like `λ>`.

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

<h1 id="starting-a-project">Starting a project (with <code>cabal sandbox</code>)</h1>

You'd figure this out eventually, but a quick way to start out a project is
with `cabal init`, and you'll save yourself a world of dependency hell if you
adopt `cabal sandbox` from day one. Here's how you would do that for a trivial
program.

For your own projects, you may want to remove the `-n` option and let cabal
ask you which options you want to choose. The `-n` option uses all the
defaults without any prompting. We specify a license to avoid build complaints
ahead.

<pre class="light bash literal-block">
$ mkdir -p ~/src/hs-hello-world
$ cd ~/src/hs-hello-world
$ cabal init -n --is-executable --license=MIT
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
license:             MIT
license-file:        LICENSE
-- author:
-- maintainer:
-- copyright:
-- category:
build-type:          Simple
cabal-version:       >=1.10

executable hs-hello-world
  main-is:             HelloWorld.hs
  -- other-modules:
  build-depends:       base >=4.7 && <4.8
</pre>

Then create a `HelloWorld.hs`, maybe something that looks like this:

## `HelloWorld.hs`

<pre class="light haskell literal-block">
main :: IO ()
main = putStrLn "Hello, world!"
</pre>

You can build and "install" it into a local sandbox like this:

<pre class="light bash literal-block">
$ cabal sandbox init
Writing a default package environment file to
/Users/bob/src/hs-hello-world/cabal.sandbox.config
Creating a new sandbox at /Users/bob/src/hs-hello-world/.cabal-sandbox

$ cabal install
Resolving dependencies...
Notice: installing into a sandbox located at
/Users/bob/src/hs-hello-world/.cabal-sandbox
Configuring hs-hello-world-0.1.0.0...
Building hs-hello-world-0.1.0.0...
Installed hs-hello-world-0.1.0.0

$ ./.cabal-sandbox/bin/hs-hello-world
Hello, world!
</pre>

The executable is large for what it does, but it's also statically linked. You
can copy that file over to any other machine with the same OS and
architecture and it'll Just Work.

This shows explicitly where the sandbox lives and that our executable is
installed into it just like library dependencies would be. But there is a Cabal
convenience command for building your project and running an executable—`cabal
run`:

<pre class="light bash literal-block">
$ cabal configure
Resolving dependencies...
Configuring hs-hello-world-0.1.0.0...

$ cabal run
Preprocessing executable 'hs-hello-world' for hs-hello-world-0.1.0.0...
[1 of 1] Compiling Main             ( HelloWorld.hs, dist/build/hs-hello-world/hs-hello-world-tmp/Main.o )
Linking dist/build/hs-hello-world/hs-hello-world ...
Running hs-hello-world...
Hello, world!
</pre>

Here we see that a build (which you could run separately with `cabal build`)
produces artifacts in `./dist/build`. For a project with only a single
`executable`, a bare `cabal run` will execute it. An explicit `cabal run
hs-hello-world` also works, and bash completion for Cabal is available that
even completes from the target names in the project `.cabal` file (installed
automatically with Homebrew if you have the `bash-completion` package
installed). This might also save a tiny bit of time by skipping extra `install`
steps.

Since this project has no dependencies that you want to install locally, you
can take some shortcuts that you might use for testing quick one-off Haskell
programs.

Run it interpreted, no compilation step needed:

<pre class="light bash literal-block">
$ runhaskell HelloWorld.hs
Hello, world!
</pre>

<pre class="light haskell literal-block">
$ ghci
GHCi, version 7.8.4: http://www.haskell.org/ghc/  :? for help
Loading package ghc-prim ... linking ... done.
Loading package integer-gmp ... linking ... done.
Loading package base ... linking ... done.
Prelude> :load HelloWorld
[1 of 1] Compiling Main             ( HelloWorld.hs, interpreted )
Ok, modules loaded: Main.
*Main> main
Hello, world!
</pre>

And you can build it without cabal at all:

<pre class="light bash literal-block">
$ cabal clean
cleaning...

$ runhaskell Setup.hs configure
Configuring hs-hello-world-0.1.0.0...

$ runhaskell Setup.hs build
Building hs-hello-world-0.1.0.0...
Preprocessing executable 'hs-hello-world' for hs-hello-world-0.1.0.0...
[1 of 1] Compiling Main             ( HelloWorld.hs, dist/build/hs-hello-world/hs-hello-world-tmp/Main.o )
Linking dist/build/hs-hello-world/hs-hello-world ...
</pre>

The above GHCi example shows how you can load a bare module anywhere into the
REPL, but normally in a Cabal project you'll want to run `cabal repl` instead.
This starts GHCi with your project build environment set up and thus your
sandbox dependencies also available for import in the REPL. Note that our main
module is available automatically:

<pre class="light haskell literal-block">
$ cabal repl
Preprocessing executable 'hs-hello-world' for hs-hello-world-0.1.0.0...
GHCi, version 7.8.4: http://www.haskell.org/ghc/  :? for help
Loading package ghc-prim ... linking ... done.
Loading package integer-gmp ... linking ... done.
Loading package base ... linking ... done.
[1 of 1] Compiling Main             ( HelloWorld.hs, interpreted )
Ok, modules loaded: Main.
h> main
Hello, world!
</pre>

## Hackage Dependencies and Freezing

Our trivial example project doesn't have any library dependencies from Hackage.
Let's add `ansi-terminal` to spruce up our sophisticated program, and give us
an example to work with. Modify the `build-depends` section of
`hs-hello-world.cabal` as follows:

<pre class="light plain literal-block">
build-depends:       base >=4.7 && <4.8,
                     ansi-terminal == 0.6.*
</pre>

Now, add some bling to `HelloWorld.hs`:

<pre class="light haskell literal-block">
import System.Console.ANSI

main :: IO ()
main = do
    putStr "Hello, "
    setSGR [ SetColor Foreground Vivid Green ]
    putStrLn "world!"
</pre>

A configure will remind us the dependency is missing:

<pre class="light bash literal-block">
$ cabal configure
Resolving dependencies...
Configuring hs-hello-world-0.1.0.0...
cabal: At least the following dependencies are missing:
ansi-terminal ==0.6.*
</pre>

So simply install it:

<pre class="light bash literal-block">
$ cabal install
Resolving dependencies...
Notice: installing into a sandbox located at
/Users/bob/src/hs-hello-world/.cabal-sandbox
Configuring ansi-terminal-0.6.2.1...
Building ansi-terminal-0.6.2.1...
Installed ansi-terminal-0.6.2.1
Configuring hs-hello-world-0.1.0.0...
Building hs-hello-world-0.1.0.0...
Installed hs-hello-world-0.1.0.0
</pre>

And now `cabal run` should reveal a brighter world!

We've declared a fuzzy dependency on `ansi-terminal`. If this were an open
source library, this would be fine—project contributers or CI might install a
new 0.6.x version, and if something breaks you'll know it needs to be fixed to
satisfy the declared compatibility. In private production projects of course,
you probably want strict build consistency.

`cabal freeze` is here to help. Run `cabal freeze` and you'll find a new
`cabal.config` file in the project directory, which will look something like
this:

<pre class="light bash literal-block">
constraints: ansi-terminal ==0.6.2.1,
             array ==0.5.0.0,
             base ==4.7.0.2,
             bytestring ==0.10.4.0,
             deepseq ==1.3.0.2,
             ghc-prim ==0.3.1.0,
             integer-gmp ==0.5.1.0,
             old-locale ==1.0.0.6,
             rts ==1.0,
             time ==1.4.2,
             unix ==2.7.0.1
</pre>

This file locks down the exact versions of dependencies (including transitive)
installed in your development sandbox. Check this file into source control, and
you will establish build consistency throughout your team and build pipeline
using Cabal.

Refer to the [Cabal User's
Guide](https://www.haskell.org/cabal/users-guide/index.html) for more on using
Cabal and `.cabal` build definitions—like adding tests to you builds!

<h1 id="ghci-basics">GHCi Basics</h1>

Some essential GHCi tricks you'll want to know, you'll find more in
[Chapter 2. Using GHCi][using ghci].

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

<a style="float: left; width: 130px" href="http://www.amazon.com/gp/product/1593272839/ref=as_li_ss_il?ie=UTF8&tag=etrepum-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=1593272839"><img border="0" src="https://ws.assoc-amazon.com/widgets/q?_encoding=UTF8&Format=_SL160_&ASIN=1593272839&MarketPlace=US&ID=AsinImage&WS=1&tag=etrepum-20&ServiceVersion=20070822" width="121" height="160"></a>
<a href="http://www.amazon.com/gp/product/1593272839/ref=as_li_ss_tl?ie=UTF8&tag=etrepum-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=1593272839">Learn You a Haskell for Great Good!: A Beginner's Guide</a>
<img src="https://www.assoc-amazon.com/e/ir?t=etrepum-20&l=as2&o=1&a=1593272839" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
<br />
I found this one to be a great starting point, I would recommend that you
read it first. It doesn't go so deep that you feel like you REALLY understand
GHC works, but I felt pretty comfortable reading and writing Haskell after
getting through this.

<div style="clear: left"></div><br>

<a style="float: left; padding-right: 10px; width: 130px;" href="http://www.amazon.com/gp/product/0596514980/ref=as_li_ss_il?ie=UTF8&tag=etrepum-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=0596514980"><img border="0" src="https://ws.assoc-amazon.com/widgets/q?_encoding=UTF8&Format=_SL160_&ASIN=0596514980&MarketPlace=US&ID=AsinImage&WS=1&tag=etrepum-20&ServiceVersion=20070822" width="122" height="160"></a>
<a href="http://www.amazon.com/gp/product/0596514980/ref=as_li_ss_tl?ie=UTF8&tag=etrepum-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=0596514980">Real World Haskell</a>
<img src="https://www.assoc-amazon.com/e/ir?t=etrepum-20&l=as2&o=1&a=0596514980" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
<br />
This book is massive in size and scope, but is still very accessible for
beginners. It'll teach you how to do Real World things with Haskell:
writing tests, profiling, IO, concurrency, etc. I'm still working through
this one, but it's a must-read.

<div style="clear: left"></div><br>

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

[using ghci]: https://downloads.haskell.org/~ghc/7.8.4/docs/html/users_guide/ghci.html

