require 'tilt'

class Site

  def initialize title, posts_dir = "posts", layouts_dir = "layouts", output_dir = "site"
    @output_path    = File.join Dir.pwd, output_dir
    @layouts_path   = File.join Dir.pwd, layouts_dir
    @posts_path     = File.join Dir.pwd, posts_dir
    @title          = title
    @archive_layout = File.join @layouts_path "archive.erb"
    @shell          = Tilt::ERBTemplate.new File.join @layouts_path, "layouts.erb"
    @archived_path  = File.join Dir.pwd, "old_posts"

    Dir.mkdir @output_path   unless Dir.exists? @outputs_path
    Dir.mkdir @archived_path unless Dir.exists? @archived_path
  end
end
