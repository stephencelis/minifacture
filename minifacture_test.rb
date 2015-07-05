require './minifacture'
require 'minitest/autorun'

class MinifactureTest < Minitest::Test
  def test_should_define_factories
    factories = Minifacture.class_variable_get :@@attrs
    refute_nil factories["user"]
    refute_nil factories["blog_entry"]
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
    refute_nil user.login
    refute_nil user.email
    refute_nil user.password
    refute_nil user.password_confirmation
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

    refute_equal login, user.login
    refute_equal email, user.email
    refute_equal password, user.password
    refute_equal password_confirmation, user.password_confirmation
  end

  def test_should_sequence
    user1 = Factory.create :user
    user2 = Factory.create :user
    assert_equal user1.login.sub(/\d+$/) { |n| n.to_i.succ.to_s }, user2.login
  end

  def test_should_sequence_with_parent
    user  = Factory.create :user
    admin = Factory.create :admin
    assert_equal user.login, 'johndoe1'
    assert_equal admin.login, 'admin2'
  end

  def test_should_interpolate
    user = Factory.create :user
    assert_equal user.email, "#{user.login}@example.com"
  end

  def test_should_inherit
    admin = Factory.create :admin
    assert_equal 'admin1', admin.login
    assert_equal 'admin1@example.com', admin.email
  end

  def test_should_alias
    blog_entry = Factory.create :blog_entry
    assert_equal 'admin1', blog_entry.user.login
  end

  def test_should_accept_class_as_symbol
    guest = Factory.create :guest
  end

  def teardown
    counts = Minifacture.class_variable_get(:@@counts)
    counts.each { |k,_| counts[k] = 0 }
  end
end

class Mock
  def save!() @saved = true end
  def new_record?() !@saved end
end

class User < Mock
  attr_accessor :login, :email, :password, :password_confirmation
end

class Post < Mock
  attr_accessor :user
end

Minifacture.define :admin, :parent => :user do |f|
  f.login "admin%d"
end

Minifacture.define :user do |f|
  f.login "johndoe%d"
  f.email "%{login}@example.com"
  f.password f.password_confirmation("foobarbaz")
end

Minifacture.define :blog_entry, :class => Post do |f|
  f.user { Minifacture :admin }
end

Minifacture.define :guest, :class => :user do |f|
  f.login "guest"
end
