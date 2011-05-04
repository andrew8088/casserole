require 'tilt'
require 'fileutils'

class Site

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
    Dir.glob( File.join @posts_path, "*" ).each do |file|
      add_post file
      file = File.basename(file)
      FileUtils.mv File.join(@posts_path, file), File.join(@archived_path, file)
    end
  end


  private

  def add_post post_path
  end
  
end
