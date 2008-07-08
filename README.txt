Treehouse
    by Nathan Witmer
    http://github.com/aniero/treehouse

== DESCRIPTION:

Simple node and visitor definitions for Treetop grammars.

== FEATURES/PROBLEMS:

* Simple node definition syntax for defining an AST
* Simple visitor definition to walk an AST

== SYNOPSIS:

  $ cat examples/simple_assignment.rb
  ...
  $ ruby examples/simple_assignment.rb
  ----- AST -----
  #<SimpleAssignment::AST::Assignment:0x12529b0
   @lhs=#<SimpleAssignment::AST::Literal:0x1252974 @value="foo">,
   @rhs=#<SimpleAssignment::AST::Literal:0x1252910 @value="bar">>

  ----- visitor output -----
  {"foo"=>"bar"}
  
== REQUIREMENTS:

* treetop
* attributes

== INSTALL:

* sudo gem install aniero-treehouse -s http://gems.github.com

== LICENSE:

(The MIT License)

Copyright (c) 2008 FIXME (different license?)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
