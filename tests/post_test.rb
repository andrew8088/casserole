require 'test/unit'
require_relative '../post'

class PostText < Test::Unit::TestCase

  @@filename = File.join Dir.pwd, "tests", "2011-05-03-sample_post-tag-another_tag-final_tag.txt"
  @@post     = Post.new @@filename

  def test_date
    assert defined? @@post.date, "date property defined"
  end

  def test_date_property_is_date_object
    assert_equal @@post.date.class, Date, "date property is a date"
  end

  def test_tags
    assert defined? @@post.tags, "tags property defined"
  end

  def test_tags_property_is_array_object
    assert @@post.tags.is_a?(Array), "tags property is an array: #{@@post.tags}"
  end

  def test_post_title
    assert defined? @@post.title, "title property defined"
  end

  def test_post_title_is_a_string
    assert @@post.title.is_a?(String), "title property is a string"
  end
  def test_post_title_has_no_leading_pound
    assert_no_match /^#/, @@post.title, "title property does not start with a hash"
  end
  def test_post_content
    assert defined? @@post.content, "content property definfed"
  end
  def test_post_content_is_a_string
    assert_equal @@post.content.class, String, "content property is a string"
  end

end
