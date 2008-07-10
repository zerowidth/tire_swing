Treehouse
    by Nathan Witmer
    http://github.com/aniero/treehouse

== DESCRIPTION:

Simple node and visitor definitions for Treetop grammars.

== FEATURES/PROBLEMS:

* Simple node definition syntax for defining an AST
* Simple visitor definition to walk an AST

== SYNOPSIS:

Given a treetop grammar:

  grammar SimpleAssignment
    rule assignment
      lhs:variable space* "=" space* rhs:variable <create_node(:assignment)>
    end
    rule variable
      [a-z]+ <create_node(:variable)>
    end
    rule space
      [ ]+
    end
  end

You can use Treehouse to define nodes for the grammar:

  module SimpleAssignment
    include Treehouse::NodeDefinition

    node :assignment, :lhs, :rhs
    node :variable, :value => :text_value
  end

When you parse the grammar and call .build, it will return an AST using the nodes you defined, auto-building everything
for you:

  ast = Parser.parse("foo = bar").build

  ast.class #=> SimpleAssignment::Assignment
  ast.lhs.class #=> SimpleAssignment::Variable
  ast.lhs.value #=> "foo"

You can also define visitors for an AST:

  module SimpleAssignment
    include Treehouse::VisitorDefinition

    visitor :hash_visitor do
      visits Assignment do |a|
        hash = {}
        hash[ visit(lhs) ] = visit(rhs)
        hash
      end
      visits Variable do |v|
        v.value
      end
    end
  end

  SimpleAssignment::HashVisitor.visit(ast) #=> {"foo" => "bar"}

  See examples/simple_assignment.rb for the full code.

== REQUIREMENTS:

* treetop
* attributes
* active_support

== INSTALL:

* sudo gem install aniero-treehouse -s http://gems.github.com

== LICENSE:

(The MIT License)

Copyright (c) 2008 Nathan Witmer

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
