require 'test/unit'
require_relative '../post'

class PostText < Test::Unit::TestCase

  @@filename = "some/path/to/2011-05-03-this_is_a_descript-tag-another_tag-awesome.txt"
  @@post     = Post.new @@filename

  def test_date
    assert defined? @@post.date, "date property defined"
  end

  def test_date_property_is_date_object
    assert @@post.date.is_a?(Date), "date property is a date"
  end

  def test_tags
    assert defined? @@post.tags, "tags property defined"
  end

  def test_tags_property_is_array_object
    assert @@post.tags.is_a?(Array), "tags property is an array"
  end
end
