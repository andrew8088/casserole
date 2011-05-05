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
    raw_posts = Dir.glob(File.join @@site_path, "posts", "*").entries.size
    posts = @@site.process_new_posts.size
    assert_equal raw_posts, posts, "Same number of posts added as available"
  end

  def test_site_should_render_tag_pages
    Dir.glob(File.join @@site_path, "posts", "*").each do |f|
      File.delete f
    end
    
    File.open File.join(@@site_path, "posts", "2012-01-31-some_slug#{Time.now.strftime "%M%S"}-tag_one-tag_two.txt"), "w" do |f|
      f.write "##the title #{Time.now}\n\nthe content goes here"
    end


    @@site.process_new_posts
    assert_equal Dir.glob(File.join @@site_path, "site", "tag", "{tag-one,tag-two}.html").size, 2, "site generates tag pages"
  end


  def test_site_should_regenerate
    posts_size = Dir.glob( File.join @@site_path, "old_posts", "*" ).size + Dir.glob( File.join @@site_path, "posts", "*").size
    @@site.regenerate!
    processed_posts = Dir.glob( File.join @@site_path, "site", "*.html" ).map { |p| p.split("/").last }
    processed_posts.delete "index.html"
    assert_equal posts_size, processed_posts.size, "site regenerates correctly"
  end
end
