FbFriends
=================================================

FbFriends is a jQuery plugin for picking Facebook friends from a dialog.
Check out the [demos and
documentation](http://icambron.github.com/fbfriends).

### Changelog

* 2012/1/14 - Added an `includeMe` option that adds the current user to
  the list so they can pick themselves.

* 2012/12/26 - Added `additionalFields` option. **Breaking change**: the callbacks are now passed the object returned by FB as-is, which is a bit different than what FbFriends was passing before. Specifically, if you were using `friend.picture`, you need `friend.picture.data.url` now.

### Building/Contributing

FbFriends is written in [CoffeeScript](http://coffeescript.org/) and [Less](http://lesscss.org/). You can find the source files in `/src`; the output directory is `/files`.

To get started, fork the repository, clone it, and run:

```
npm install
```

To build just run

```
make
```

### License (MIT)

Copyright (c) 2012 Isaac Cambron

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
