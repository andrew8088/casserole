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

    render_index 

    posts.map { |post| post.date.strftime("%Y %m") }.flatten.uniq.each do |year_month|
      render_archive_page *year_month.split
    end
    
    posts
  end

  def regenerate!
    FileUtils.rm_rf @output_path
    Dir.mkdir  @output_path

    Dir.glob( File.join @archived_path, "*" ).each do |file|
      FileUtils.mv file, File.join(@posts_path, File.basename(file))
    end
    process_new_posts
  end

  private

  def render_post post_path
    post = Post.new post_path
    File.open File.join(@output_path, post.permalink), "w" do |file|
      file.write post.render
    end
    post
  end

  def render_tag_page tag
    posts = Dir.glob( File.join @archived_path, "*#{tag}*").map { |post| Post.new post }.sort

    tag_dir = File.join @output_path, "tag"
    Dir.mkdir tag_dir unless Dir.exists? tag_dir

    File.open File.join(@output_path, "tag", "#{tag.gsub '_', '-'}.html"), "w" do |file|
      file.write render(@archive_layout, posts: posts)
    end
  end

  def render_archive_page year, month
    posts = Dir.glob( File.join @archived_path, "#{year}-#{month}*").map { |post| Post.new post }.sort
    
    year_dir  = File.join @output_path, year.to_s
    month_dir = File.join @output_path, year.to_s, month.to_s

    Dir.mkdir year_dir unless Dir.exists? year_dir
    Dir.mkdir month_dir unless Dir.exists? month_dir

    File.open( File.join(month_dir, "index.html"), "w") do |file|
      file.write render(@archive_layout, posts: posts)
    end
  end

  def render_index
    posts = Dir.glob( File.join @archived_path, "*" ).map { |post| Post.new post }.sort.first 10

    File.open(File.join(@output_path, "index.html"), "w") do |file|
      file.write render(File.join(@layouts_path, "index.erb"), posts: posts)
    end 
  end

  def render layout, props
    @shell.render(Object.new, site: self) {
      Tilt::ERBTemplate.new(layout).render Object.new, props 
    }
  end
  
end
