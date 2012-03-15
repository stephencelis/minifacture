require './miniskirt'
require 'test/unit'

class MiniskirtTest < Test::Unit::TestCase
  def test_should_define_factories
    factories = Miniskirt.instance_variable_get :@factories

    assert factories["user"]
    assert factories["blog_entry"]
  end

  def test_should_build_object
    user = Factory.build :user
    assert_instance_of User, user
    assert user.new_record?
  end

  def test_should_create_object
    user = Factory.create :user
    assert_instance_of User, user
    assert !user.new_record?
  end

  def test_should_create_object_with_shorthand
    user = Factory :user
    assert !user.new_record?
  end

  def test_should_assign_attributes
    user = Factory.create :user
    assert_not_nil user.login
    assert_not_nil user.email
    assert_not_nil user.password
    assert_not_nil user.password_confirmation
  end

  def test_should_chain_attributes
    user = Factory.create :user
    assert_equal user.password, user.password_confirmation
  end

  def test_should_override_attributes_on_the_fly
    user = Factory.create :user, :login => (login = "janedoe"),
      :email => (email = "janedoe@example.com"),
      :password => (password = "password"),
      :password_confirmation => (password_confirmation = "passwrod")

    assert_equal login, user.login
    assert_equal email, user.email
    assert_equal password, user.password
    assert_equal password_confirmation, user.password_confirmation

    user = Factory.create :user

    assert_not_equal login, user.login
    assert_not_equal email, user.email
    assert_not_equal password, user.password
    assert_not_equal password_confirmation, user.password_confirmation
  end

  def test_should_sequence
    user1 = Factory.create :user
    user2 = Factory.create :user
    assert_equal user1.login.sub(/\d+$/) { |n| n.to_i.succ.to_s }, user2.login
  end

  def test_should_interpolate
    user = Factory.create :user
    assert_equal "#{user.login}@example.com", user.email
  end

  def test_should_inherit
    admin = Factory.create :admin
    assert_equal 'admin', admin.login
    assert_equal 'admin@example.com', admin.email
  end

  def test_should_alias
    blog_entry = Factory.create :blog_entry
    assert_equal 'admin', blog_entry.user.login
  end

  def test_should_accept_class_as_symbol
    assert_nothing_raised do
      guest = Factory.create :guest
    end
  end

  def test_objects_should_not_corrupt_attribute_templates
    factories = Miniskirt.instance_variable_get(:@factories)
    assert_not_equal DefaultSettings.object_id, factories["guest"].__attrs__["settings"].object_id
  end

  def test_factories_should_not_corrupt_attribute_templates
    alice = Factory.build :guest
    bob = Factory.build :guest

    assert_not_equal DefaultSettings.object_id, alice.object_id, "Object from factory should not reference to template object"

    alice.settings["eyes"] = "brown"

    assert_equal "gray", bob.settings["eyes"]
  end
end

class Mock
  @@maximum = nil
  def self.maximum(column)
    @@maximum
  end

  def initialize
    yield self
  end

  def save!
    @@maximum = @@maximum.to_i + 1 unless @saved
    @saved = true
  end

  def new_record?
    !@saved
  end
end

class User < Mock
  attr_accessor :login, :email, :password, :password_confirmation, :settings
end

class Post < Mock
  attr_accessor :user
end

Miniskirt.define :admin, :parent => :user do |f|
  f.login "admin"
end

Miniskirt.define :user do |f|
  f.login "johndoe%d"
  f.email "%{login}@example.com"
  f.password f.password_confirmation("foobarbaz")
end

Miniskirt.define :blog_entry, :class => Post do |f|
  f.user { Miniskirt :admin }
end

DefaultSettings = {
  "hair" => "green",
  "eyes" => "gray"
}

Miniskirt.define :guest, :class => :user do |f|
  f.login "guest"
  f.settings DefaultSettings
end