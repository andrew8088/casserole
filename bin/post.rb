require 'tilt'
require 'maruku'
require 'date'

class Post
  attr_accessor :date, :tags, :title, :content, :slug, :link, :permalink, :type

  include Comparable


  # file_path = path to file
  # should end with filename like this:
  # yyyy-mm-dd-hh-mm-my_descript_with_underscores-tag-multiword_tag-tag
  def initialize file_path
    md = file_path.match(/(\d{4}-\d{2}-\d{2}-?(\d{2}-\d{2})?)-(\w*)-([\w-]*)/)

    unless md.nil?
      @date = Date.parse(md[1])
      @tags = md[4].split "-"
    end

    File.open(file_path) do |file|

      @title = ""
      @title = file.readline until md = @title.match(/^#+(.*)/) 
      @title = md[1]

      if (md = @title.match /^\[(.*)\]\((.*)\)/)
        @title = md[1]  
        @link  = md[2]
        @type  = :link
      else
        @type  = :post
      end

      @content   = Maruku.new(file.read).to_html
      @slug      = @title.downcase.gsub(/[^\w\s]/, "").gsub /\s+/, "-"
      @permalink = "#{@slug}.html"
    end
  end

  def render
    @@post_template ||= Tilt.new( File.join "layouts", "post.erb" ) 
    @@link_template ||= Tilt.new( File.join "layouts", "link.erb" ) 

    (self.type == :post ? @@post_template : @@link_template).render(Object.new, post: self) 
  end

  def self.post_template= template
    @@post_template = Tilt.new(template)
  end

  def self.link_template= template
    @@link_template = Tilt.new(template)
  end

  def <=> b
    return  1 if @date <  b.date
    return -1 if @date >  b.date
    return  0 if @date == b.date
  end
end
