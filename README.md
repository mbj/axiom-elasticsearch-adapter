axiom-elasticsearch-adapter
=============================

[![Build Status](https://secure.travis-ci.org/mbj/axiom-elasticsearch-adapter.png?branch=master)](http://travis-ci.org/mbj/veritas-elastisearch-adapter)
[![Dependency Status](https://gemnasium.com/mbj/axiom-elasticsearch-adapter.png)](https://gemnasium.com/mbj/veritas-elasticsearch-adapter)
[![Code Climate](https://codeclimate.com/github/mbj/axiom-elasticsearch-adapter.png)](https://codeclimate.com/github/mbj/veritas-elasticsearch-adapter)

This is an [elasticsearch](http://elasticsearch.org) adapter for [axiom](http://github.com/dkubb/veritas).

It does currently feature basic read support with the ability to push restriction/limit and offsets to the database.

This project is only tested against the git version of axiom.

Do not expect a gem release soon.

Installation
------------

In your **Gemfile**

``` ruby
gem 'axiom',                       :git => 'https://github.com/dkubb/veritas'
gem 'axiom-elasticsearch-adapter', :git => 'https://github.com/mbj/veritas-elasticsearch-adapter'
```

Examples
--------

See dirty_integration_test.rb in project root.

Credits
-------

* Dan Kubb ([dkubb](https://github.com/dkubb))

Contributing
-------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile or version
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

License
-------

Copyright (c) 2012 Markus Schirp

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
