---
categories: [python, math, hash]
category: archives
layout: post
tags: [hash, math, python]
title: Py3k Unified Numeric Hash Proposal
---
{% include JB/setup %}

{% raw %}
There has been a recent and interesting set of discussions on python-dev
[(Decimal <-> float comparisons)][]
for what the best behavior for numeric type interoperability would be. The
most prominent "mistake" in the current implementation is that certain float
and int/long values compare equal, and certain Decimal and int/long values
compare equal, but all float and Decimal comparison operations
raise TypeError. Other operations between float and Decimal also
raise TypeError. Python 2.x behavior is such that comparison operations
between float and Decimal return nonsense results and other operations
raise TypeError.

Guido recently pronounced [(Mixing float and Decimal)][] that he'd like to
consider changing the behavior to match the principle of least surprise;
all operations for all of the numeric types should return correct results.
One of the most difficult problems to solve with such a unification is the
hash invariant:

   for all a and b such that a == b: hash(a) == hash(b).

While this is relatively simple to implement for the integer cases, it's
much tricker to do efficiently for Decimal and float (and Fraction!) because
Decimals are base 10 and float are base 2.

Note that I started writing this post yesterday after studying version 3
of the patch. I have altered the inline quotes to reflect version 4,
which contains vastly improved comments that make most of my post redundant.
However, it may still help in some way because it is an independent
explanation and it provides some Python code.

Mark Dickinson proposed a very clever algorithm with an efficient
implementation in [issue8188][], which he summarized as follows
in the comments of the patch:

>   For numeric types, the hash of a number x is based on the reduction
>   of x modulo the prime P = 2\*\*\_PyHASH\_BITS - 1.  It's designed so that
>   hash(x) == hash(y) whenever x and y are numerically equal, even if
>   x and y have different types.
>
>   A quick summary of the hashing strategy:
>
>   (1) First define the 'reduction of x modulo P' for any rational
>   number x; this is a standard extension of the usual notion of
>   reduction modulo P for integers.  If x == p/q (written in lowest
>   terms), the reduction is interpreted as the reduction of p times
>   the inverse of the reduction of q, all modulo P; if q is exactly
>   divisible by P then define the reduction to be infinity.  So we've
>   got a well-defined map
>
>      reduce : { rational numbers } -> { 0, 1, 2, ..., P-1, infinity }.
>
>   (2) Now for a rational number x, define hash(x) by:
>
>      reduce(x)   if x >= 0
>      -reduce(-x) if x < 0
>
>   If the result of the reduction is infinity (this is impossible for
>   integers, floats and Decimals) then use the predefined hash value
>   \_PyHASH\_INF instead.  \_PyHASH\_INF, \_PyHASH\_NINF and \_PyHASH\_NAN are also
>   used for the hashes of float and Decimal infinities and nans.
>
>   A selling point for the above strategy is that it makes it possible
>   to compute hashes of decimal and binary floating-point numbers
>   efficiently, even if the exponent of the binary or decimal number
>   is large.  The key point is that
>
>      reduce(x * y) == reduce(x) * reduce(y) (modulo _PyHASH_MASK)
>
>   provided that {reduce(x), reduce(y)} != {0, infinity}.  The reduction of a
>   binary or decimal float is never infinity, since the denominator is a power
>   of 2 (for binary) or a divisor of a power of 10 (for decimal).  So we have,
>   for nonnegative x,
>
>      reduce(x * 2**e) == reduce(x) * reduce(2**e) % _PyHASH_MASK
>
>      reduce(x * 10**e) == reduce(x) * reduce(10**e) % _PyHASH_MASK
>
>   and reduce(10\*\*e) can be computed efficiently by the usual modular
>   exponentiation algorithm.  For reduce(2\*\*e) it's even better: since
>   P is of the form 2\*\*n-1, reduce(2\*\*e) is 2\*\*(e mod n), and multiplication
>   by 2\*\*(e mod n) modulo 2\*\*n-1 just amounts to a rotation of bits.


The choices of P for his implementation are (2\*\*31)-1 for 32-bit platforms and
(2\*\*61)-1 for 64-bit platforms. These numbers are interesting because they are
the eighth and ninth [Mersenne prime][]
numbers. I'm not entirely sure yet if these numbers being prime is essential
or not, but it's definitely conventional for a hash modulus to be prime. A
very important feature of these numbers is that P+1 is a power of two.

One thing that wasn't immediately obvious to me was how to define modulus of
a (rational) number f such that 0 < f < 1. We know from the above that in
the floating point case we can break f into its mantissa and exponent:

    reduce(m * (2**e)) == reduce(reduce(m) * reduce(2**e))

but that leaves the cases where 0 < 2\*\*e < 1. Well, because we are working
with a modulus of P, we know that P+1 is the multiplicative identity, so
we can find some number n such that ((P+1)\*\*n) \* (2\*\*e) is an integer. We
also know that ((P+1)\*\*n) \* (2\*\*e) mod P must be non-zero because P is prime.

We can demonstrate that reduce(x) where x = 2\*\*e is quite a trivial
task for a typical CPU as follows (k is log2(P+1), which is 61 or 31).
All of the following expressions mod P are equivalent to x mod P.

    (x * (P+1)**n)              # multiplicative identity
    (x * (2**k)**n)             # P+1 == 2**k
    (x * (2**(k*n))             # (a**b)**c == a**(b*c)
    ((2**e) * (2**(k*n)))       # x == 2**e
    (2**(e + (k * n)))          # (a**b)*(a**c) == a**(b+c)
    (2**((e + (k * n)) % k))    # 2**k is identity, so exponent is mod k
    (2**(e % k))                # (k * n) % k == 0
    1 << (e % k)                # a * (2**b) == a << b

In Python the naive algorithms would be as follows (ignoring inf and NaN):

    from math import frexp

    # Doesn't matter whether we use 61 or 31.
    HASH_SHIFT = 61
    HASH_MODULUS = (2 ** HASH_SHIFT) - 1

    def hash_int(n):
        if n == 0:
            return 0
        elif n < 0:
            rval = -((-n) % HASH_MODULUS)
            return -2 if rval == -1 else rval
        else:
            return n % HASH_MODULUS

    def hash_float(f):
        if f == 0.0:
            return 0
        elif f < 0.0:
            rval = -hash_float(-f)
            return -2 if rval == -1 else rval
        # m = mantissa (float), e = exponent of 2 (integer)
        m, e = frexp(f)
        # "arbitrarily" process 28 bits at a time. For a normal float,
        # this loop will iterate no more than twice since the mantissa
        # is 53 bits in a 64-bit IEEE-754 double.
        # After the loop, n will be some integer such that n ** e = f
        n = 0
        BITS = 28
        while m:
            m *= (2.0 ** BITS)
            e -= BITS
            m_floor = int(m)
            n = (n << BITS) | m_floor
            m -= m_floor
        # see above "proof" for this definition of reduce(2**e)
        return hash_int(hash_int(n) << (e % HASH_SHIFT))

You might notice the strange intentional mapping of -1 to -2, the reason for
this is simply that the convention of Python's C API is such that return
values of -1 mean that an exception may have occurred (and a global variable
must be checked). If -1 is never returned on success then there are no
false positives so the general case is faster. Essentially Python is trading
this known worst case for a potential hash collision, which is probably the
right call.

If you read the actual C implementation there are a few additional math tricks
at play, the most important of which is this implementation of long_hash from
longobject.c:

    static long
    long_hash(PyLongObject *v)
    {
        unsigned long x;
        Py_ssize_t i;
        int sign;

        i = Py_SIZE(v);
        switch(i) {
        case -1: return v->ob_digit[0]==1 ? -2 : -(sdigit)v->ob_digit[0];
        case 0: return 0;
        case 1: return v->ob_digit[0];
        }
        sign = 1;
        x = 0;
        if (i < 0) {
            sign = -1;
            i = -(i);
        }
        while (--i >= 0) {
            /* Here x is a quantity in the range [0, _PyHASH_MASK); we
               want to compute x * 2**PyLong_SHIFT + v->ob_digit[i] modulo
               _PyHASH_MASK.

               The computation of x * 2**PyLong_SHIFT % _PyHASH_MASK
               amounts to a rotation of the bits of x.  To see this, write

                 x * 2**PyLong_SHIFT = y * 2**_PyHASH_BITS + z

               where y = x >> (_PyHASH_BITS - PyLong_SHIFT) gives the top
               PyLong_SHIFT bits of x (those that are shifted out of the
               original _PyHASH_BITS bits, and z = (x << PyLong_SHIFT) &
               _PyHASH_MASK gives the bottom _PyHASH_BITS - PyLong_SHIFT
               bits of x, shifted up.  Then since 2**_PyHASH_BITS is
               congruent to 1 modulo _PyHASH_MASK, y*2**_PyHASH_BITS is
               congruent to y modulo _PyHASH_MASK.  So

                 x * 2**PyLong_SHIFT = y + z (mod _PyHASH_MASK).

               The right-hand side is just the result of rotating the
               _PyHASH_BITS bits of x left by PyLong_SHIFT places; since
               not all _PyHASH_BITS bits of x are 1s, the same is true
               after rotation, so 0 <= y+z < _PyHASH_MASK and y + z is the
               reduction of x*2**PyLong_SHIFT modulo _PyHASH_MASK. */
            x = ((x << PyLong_SHIFT) & _PyHASH_MASK) |
                (x >> (_PyHASH_BITS - PyLong_SHIFT));
            x += v->ob_digit[i];
            if (x >= _PyHASH_MASK)
                x -= _PyHASH_MASK;
        }
        x = x * sign;
        if (x == (unsigned long)-1)
            x = (unsigned long)-2;
        return (long)x;
    }

In order to understand this better we'll translate this to Python first, but
to do that we need to understand the layout of integers in py3k. In py3k
integers are represented as a sequence of zero or more digits, where a
digit is 2\*\*sys.int\_info.bits\_per\_digit bits wide, and the least
significant digit is first in the array. I'm not aware of any Python function
to see integers at this level so we'll craft our own way to "disassemble" an
integer in the way that the C implementation will see it. Instead of tracking
the sign and size as one integer we will track the sign on its own and use
the length of the list to track size.

    import sys
    # Doesn't matter whether we use 61 or 31.
    HASH_SHIFT = 61
    # The modulus can be used as a bit mask, all bits are set
    HASH_MODULUS = (2 ** HASH_SHIFT) - 1

    def disassemble_int(i):
        bits_per_digit = sys.int_info.bits_per_digit
        bit_mask = (1 << bits_per_digit) - 1
        if i < 0:
            sign = -1
            i *= -1
        else:
            sign = 1
        digits = []
        # see reassemble_int for inverse of this operation
        while i:
            digits.append(i & bit_mask)
            i >>= bits_per_digit
        return sign, digits

    def reassemble_int(sign, digits):
        # demonstrate similar method for just reassembling the integer
        bits_per_digit = sys.int_info.bits_per_digit
        if sign == -1:
            return -reassemble_int(1, digits)
        size = len(digits)
        if size == 0:
            return 0
        elif size == 1:
            # just an optimization for small numbers
            return digits[0]
        x = 0
        # traverse digits from most to least significant
        # n = bits_per_digit
        # d[i] = digit with index of i
        # x = d[0] + d[1]*(2**n) + ... + d[i]*(2**(n*i))
        # x = d[0] + (2**n)*(d[1] + (2**n)*(d[2] + ...))
        # x = d[0] + (d[1] + ((d[2] + (...)) << n) << n
        for digit in reversed(digits):
            x = x << bits_per_digit
            x += digit
        return x

    def hash_long(sign, digits):
        bits_per_digit = sys.int_info.bits_per_digit
        if sign == -1:
            rval = -hash_long(1, digits)
            return -2 if rval == -1 else rval
        size = len(digits)
        if size == 0:
            return 0
        elif size == 1:
            # just an optimization for small numbers
            # since we assume bits_per_digit < HASH_SHIFT
            return digits[0]
        x = 0
        # traverse digits from most to least significant
        for digit in reversed(digits):
            # rotate the bottom HASH_SHIFT bits left by bits_per_digit,
            # in effect this multiplies by 2**bits_per_digit mod HASH_MODULUS
            x = (((x << bits_per_digit) & HASH_MODULUS) |
                 (x >> (HASH_SHIFT - bits_per_digit)))
            x += digit
            # If the addition overflowed we compensate by decrementing, which
            # preserves the value mod HASH_MODULUS.
            if x > HASH_MODULUS:
                x -= HASH_MODULUS
        return x

Now that we have a Python implementation the only trick left to decipher is
why the heck are these equivalent for our choices of modulus P
(k is log2(P+1), which is 61 or 31):

    x * (2**n) % P
    ((x << n) & P) | (x >> (k - n))

I think that one way to "prove" that multiplying by a power of 2 in mod P is
equivalent to bit rotation of a k bit integer would be to decompose x into
binary digits as follows (k is log2(P+1)):

    for all x such that 0 <= x < P, x == x % P
    any x mod P can be decomposed into binary digits (d[0] * 2**0 + d[1] * 2**1 + ... + d[k-1] * 2**(k-1))
    # 2**k is a multiplicative identity mod P
    2**k mod P == 2**0 == 1
    # just decompose x into binary digits
    x * (2**0) mod P == (d[0] * 2**(0) + d[1] * 2**(1) + ... + d[k-1] * 2**(k-1))
    # show multiply by 2 is a bit rotate left of k bits
    x * (2**1) mod P == (d[0] * 2**(1) + d[1] * 2**(2) + ... + d[k-1] * 2**(0))
    # generalize into n multiplications of 2
    x * (2**n) mod P == (d[0] * 2**((0 + n) % k) + d[1] + 2**((1 + n) % k) + ... + d[k-1] * 2**((k - 1 + n) % k))
    x * (2**n) mod P == (d[0] * 2**((0 + n) % k) + d[1] + 2**((1 + n) % k) + ... + d[k-1] * 2**((-1 + n) % k))

I'm definitely not Tim Peters or even a mathematician but I found this problem
interesting enough to dive into, especially because Guido didn't find this
obvious either [(Objects/longobject.c)][]. I think I've covered it in sufficient depth for me to believe
that it works and the patch is good, but if I'm missing something please let
me know!

[(Decimal <-> float comparisons)]: http://mail.python.org/pipermail/python-dev/2010-March/thread.html#98437 "[Python-Dev] Decimal <-> float comparisons in py3k."
[(Mixing float and Decimal)]: http://mail.python.org/pipermail/python-dev/2010-March/thread.html#98575 "[Python-Dev] Mixing float and Decimal -- thread reboot"
[(Objects/longobject.c)]: http://codereview.appspot.com/660042/diff/19001/11011#newcode2577 "Objects/longobject.c - Issue 660042: Compatible numeric hashes - Code Review"
[issue8188]: http://bugs.python.org/issue8188 "issue8188"
[Mersenne prime]: http://en.wikipedia.org/wiki/Mersenne_prime "Mersenne prime"
{% endraw %}
