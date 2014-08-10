---
categories: [javascript]
category: archives
layout: post
tags: [javascript]
title: Browser Tab Visible Event
---
{% include JB/setup %}

Sadly there's no web standard that I could find to determine when a tab
becomes visible. My use case was to delay loading of Flash content until
the tab is visible for the first time. Safari seems to do this by default,
but none of the other browsers do.

Chrome is the absolute worst offender here, it does not fire
window.onmouseover until the mouse has been moved over the page and it
does not fire window.onfocus until you switch to that tab... so if the
tab was started as a foreground tab, you will not get this event. The
only way I managed to detect a tab being active was to poll
the window.screenX and window.screenY properties. They are always
0 for a background tab. There is an obvious false positive if the
browser happens to be in the screen origin, but in that case a
window.onmouseover event will fire once the mouse has moved.

Safari is slightly less bad because it will fire window.onmouseover
immediately when the tab is active. This works great but was a less
obvious find than window.onfocus.

Firefox and IE8 have the least surprising behavior in that they fire
window.onfocus immediately whenever a tab becomes visible, even if
it was the foreground tab. I think this was the very first browser
compatibility experiment where I've spent less time with IE than
any other browser, although to be fair I didn't test anything
other than IE8.

For maximum compatibility/longevity I've just provided some raw
JavaScript code here. No framework. Feel free to translate this
into a snippet or plugin for the framework of your choice. I'd
also be interested if someone else does the testing for other
browsers such as Opera and older versions of IE.

Tested with:

* Google Chrome 5.0.342.9 (Mac)
* Safari 4.0.5 (Mac)
* Firefox 3.6.3 (Mac)
* Internet Explorer 8.0.6001.18702

<pre><code>var timer = null;
function tabVisible() {
    if (timer) clearInterval(timer);
    timer = null;
    window.onfocus = null;
    window.onmouseover = null;
    /* your code to dispatch event here */
}
// Firefox, IE8
window.onfocus = tabVisible;
// Safari
window.onmouseover = tabVisible;
// dirty hack for Chrome
if (navigator.userAgent.indexOf(' Chrome/') != -1) {
    function dirtyChromePoll() {
        if (window.screenX || window.screenY) tabVisible();
    }
    timer = setInterval(dirtyChromePoll, 100);
}
</code></pre>

