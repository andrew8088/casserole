require 'tilt'
require 'fileutils'
require_relative 'post'

class Site
  attr_accessor :title

  def initialize title, site_base = Dir.pwd, paths = { posts: "posts", layouts: "layouts", output: "site" }
    @output_path    = File.join site_base, paths[:output]
    @layouts_path   = File.join site_base, paths[:layouts]
    @posts_path     = File.join site_base, paths[:posts]
    @title          = title
    @archive_layout = File.join @layouts_path, "archive.erb"
    @shell          = Tilt::ERBTemplate.new File.join @layouts_path, "layout.erb"
    @archived_path  = File.join site_base, "old_posts"

    Dir.mkdir @output_path   unless Dir.exists? @output_path
    Dir.mkdir @archived_path unless Dir.exists? @archived_path
  end

  def process_new_posts
    posts = []
    Dir.glob(File.join @posts_path, "*" ).each do |file|
      posts << render_post(file)
      file = File.basename(file)
      FileUtils.mv(File.join(@posts_path, file), File.join(@archived_path, file))
    end

    posts.map { |post| post.tags }.flatten.uniq.each do |tag|
      render_tag_page tag
    end

  end

  def regenerate!

  end

  private

  def render_post post_path
    post = Post.new post_path
    File.open File.join(@output_path, post.permalink), "w" do |file|
      file.write @shell.render(Object.new, post:post, site: self) {
          Tilt::ERBTemplate.new(File.join @layouts_path, (post.type == :link) ? "link.erb" : "post.erb")
                           .render(Object.new, post:post, site:self)
      }
    end
    post
  end

  def render_tag_page tag
    posts = Dir.glob( File.join @archived_path, "*#{tag}*").map { |post| Post.new post }.sort

    File.open File.join(@output_path, "#{tag.gsub '_', '-'}.html"), "w" do |file|
      file.write @shell.render(Object.new, site: self) {
        Tilt::ERBTemplate.new(@archive_layout).render Object.new, posts: posts
      }
    end
  end

  def render_archive_page month, year

  end

  def render_index
  
  end

  def render layout, props
    @shell.render(Object.new, site: self) {
      Tilt::ERBTemplate.new(layout).render Object.new props 
    }
  end
  
end
