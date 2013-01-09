---
categories: [python, simplejson, python3]
category: archives
layout: post
tags: [python, simplejson, python3]
title: simplejson now for Python 3.3 (and Python 2.5+!)
---
{% include JB/setup %}

[simplejson](http://github.com/simplejson/simplejson)
([documentation](http://simplejson.readthedocs.org/en/latest/))
is a simple, fast, complete, correct and extensible
[JSON](http://json.org/)
([RFC 4627](http://www.ietf.org/rfc/rfc4627.txt)) encoder/decoder for
Python 2.5+ and Python 3.3+.  It is pure Python code with no
dependencies, but features an optional C extension for speed-ups.

[simplejson 3](http://pypi.python.org/pypi/simplejson)
came out just a few weeks ago. Hard to believe that I released the
first version in December 2005, over 7 years ago! Python sure has
changed a lot since then, Python 2.4 was current at the time.

I put a bit more work than usual into this release since there
finally seems to be some real demand for a Python 3.3 port. In the
process I did a little clean-up of the C code and beefed up the test
coverage. There was a pull request to take care of Python 3
compatibility a few years ago
([#8](https://github.com/simplejson/simplejson/pull/8)), but I was
hesitant to accept it because it seemed like it might make some
unwanted behavior changes to Python 2.x support and add to the
maintenance burden. I didn't end up using this patch, but it served as
a wonderful reference.

A number of things have changed since then that made me change my
mind about supporting Python 3. Basically, Python 3.3 is much more
memory efficient for text processing, and it's easier than ever to
write code that works in both Python 2.x and Python 3.x without any
preprocessor (see also:
[What's New In Python 3.3](http://docs.python.org/3/whatsnew/3.3.html)):

* [PEP 393](http://www.python.org/dev/peps/pep-0393/):
  Flexible String Representation really changes the game for
  string processing in Python. In Python 2.x I put a lot of effort
  into making it possible to use the `str` (bytes) type whenever
  possible to conserve memory. Python 3.3's `str` (text) type
  can use 8-bit, 16-bit, or 32-bit per code point storage based
  on the contents of the string.
   
* Python 3.3 supports `u''` string syntax, so fewer changes are
  necessary to support both Python 2.x and 3.3
  
* [Travis-CI](https://travis-ci.org/) made it easy (and free!) for me
  to run the
  [simplejson tests](https://travis-ci.org/simplejson/simplejson)
  against multiple Python versions after every commit, even on a
  branch. Currently, it tests simplejson on CPython 2.5, 2.6, 2.7, 3.3,
  and PyPy.

* [python3porting.com](http://python3porting.com/) had basically
  everything I needed to know about porting between Python 2 and
  Python 3. The strategy I used for porting is covered in
  [Supporting Python 2 and 3 without 2to3 conversion](http://python3porting.com/noconv.html).
  I decided to implement a small compatibility library myself instead
  of using [six](http://pypi.python.org/pypi/six) only because I
  did not want to add dependencies to the project. If simplejson
  already had dependencies, I'd have taken that route.

If anyone is interested in helping out, simplejson could always use
some better benchmarks and performance improvements. It could also use
some better PyPy-specific optimizations. I'd be happy to review any
pull requests. Another project that I'd recommend would be to backport
simplejson 3 to Python 3's json library for Python 3.4. I'm not really
using Python much these days, but I'm happy to help provide code
review or general advice for anyone who is interested.
