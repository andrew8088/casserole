require 'maruku'
require 'date'

class Post
  attr_accessor :date, :tags, :title
  # file_path = path to file
  # should end with filename like this:
  # yyyy-mm-dd-my_descript_with_underscores-tag-multiword_tag-tag
  def initialize file_path
    md = file_path.match(/(\d{4}-\d{2}-\d{2})-(\w*)-([\w-]*)/)

    unless md.nil?
      @date, descript, @tags = md.to_a
      @date = Date.parse @date
      @tags = @tags.split "-"
    end
    File.open(file_path) do |file|
      begin
        @title = file.readline
      end until @title.match(/^#+(.*)/)
      @title = @title.split('#').last
    end
  end
end
