# Minifacture

[factory_girl][1] for [minitest][2].

[1]: https://github.com/thoughtbot/factory_girl
[2]: https://github.com/seattlerb/minitest

``` ruby
Factory.define :user do |f|
  f.name 'John Doe'                            # String.
  f.login 'johndoe%d'                          # Sequence.
  f.email '%{login}@example.com'               # Interpolate.
  f.password f.password_confirmation('foobar') # Chain.
end

Factory.define :post do |f|
  f.user { Factory :user }                     # Blocks, if you must.
end
```


## Install

``` ruby
# Gemfile
group :test do
  gem 'minifacture'
end
```

``` sh
$ bundle
```

``` ruby
# test/test_helper.rb
require 'factories' # If you define your factories in test/factories.rb
```


## Use

To get a `User` instance that's not saved:

``` ruby
u = Factory.build :user
```

To get a `User` instance that's saved:

``` ruby
u = Factory.create :user
```

Shorthand for create:

``` ruby
u = Factory :user
```


### Methods

Methods can customize a factory's object as it is being built.

Take a simple class:

``` ruby
class User
  attr_accessor :name
  attr_accessor :email
end
```

And a simple factory:

``` ruby
Factory.define :user do
end
```

Use:

``` ruby
u = Factory :user, name: 'Alice', email: 'alice@example.com'
u.name  # => "Alice"
u.email # => "alice@example.com"
```

This initializes the object, then calls the object's `name=` method and
`email=` method.


### Blocks

Blocks can use any Ruby code:

``` ruby
Factory.define :user do |f|
  f.name { %w[Alice Bob Carol].choice }
  f.email { "#{%w[alice bob carol].choice}@example.com" }
end
```

Use:

``` ruby
u = Factory :user
u.name  # => "Bob"
u.email # => "carol@example.com"
```

Blocks can use a parameter to access the object as it is being built:

``` ruby
Factory.define :user do |f|
  f.name { %w[Alice Bob Carol].choice }
  f.email { |u| "#{u.name.downcase}@example.com" }
end
```

Use:

``` ruby
u = Factory :user
u.name  # => "Bob"
u.email # => "bob@example.com"
```


### Methods + Blocks

When you use methods and blocks together, the methods are called, then the
blocks:

``` ruby
user = Factory :user, name: 'Eve'
user.name  # => "Eve"
user.email # => "eve@example.com"
```

This initializes the object, then calls the object's `name=` method, then
processes the factory attribute `email` which calls the block.


### Namespacing

If your model is namespaced, or does not correspond directly with the symbol,
you can explicitly declare which class to use:

```ruby
Factory.define :post, class: BlogEngine::Post do
  # ...
end
```


## License

(The MIT License)

© 2010–2012 Stephen Celis <stephen@stephencelis.com>.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
