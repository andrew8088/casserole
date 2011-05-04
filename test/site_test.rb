require 'test/unit'
require_relative '../site'

class SiteTest < Test::Unit::TestCase

  @@site_path = File.join Dir.pwd, "test", "test_site" 
  @@site = Site.new "Shaky Takes", @@site_path

  def test_site_created
    assert_equal @@site.class, Site, "site object is a Site"
  end

  def test_site_should_move_posts_after_processing
    @@site.process_new_posts
    ds_store = File.join @@site_path, "posts", ".DS_Store" 
    File.delete ds_store if File.exists? ds_store
    assert_equal Dir.entries(File.join @@site_path, "posts").size, 2, "processeed posts are moved"
  end

  def test_site_should_render_posts
    raw_posts = Dir.glob(File.join @@site_path, "posts", "*.txt").entries.size
    slugs = @@site.process_new_posts.size
    assert_equal raw_posts, slugs, "Same number of posts added as available"
  end

end
