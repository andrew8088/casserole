require 'date'
require 'fileutils'

namespace :test do

  task :create_note do
    create_note
  end

  task :setup do
    test_site = File.join Dir.pwd, "test"
    test_site_posts = File.join test_site, "posts"
    test_site_layouts = File.join test_site, "layouts"
    test_site_output  = File.join test_site, "site"

    FileUtils.rm_rf test_site
    Dir.mkdir test_site 
    Dir.mkdir test_site_posts unless Dir.exists? test_site_posts
    Dir.mkdir test_site_layouts unless Dir.exists? test_site_layouts
    Dir.mkdir test_site_output unless Dir.exists? test_site_output

    File.open File.join(test_site_layouts, "layout.erb"), "w" do |f|
      f.write "<link href='atom.xml' type='application/atom+xml' rel='alternate' title='Sitewide ATOM Feed' />\n<h1>Test Site - Autogenerated Site Templates</h1><%= yield %>"
    end
    File.open File.join(test_site_layouts, "post.erb"), "w" do |f|
      f.write "<h2><%= post.title %></h2> <%= post.content %>"
    end
    FileUtils.cp File.join(test_site_layouts, "post.erb"), File.join(test_site_layouts, "link.erb")

    File.open File.join(test_site_layouts, "archive.erb"), "w" do |f|
      f.write "<h2>Archive Page</h2> <ul> <% posts.each do |post| %> <li><a href='<%= post.permalink %>'><%= post.title %></a></li> <% end %> </ul>"
    end
    File.open File.join(test_site_layouts, "index.erb"), "w" do |f|
      f.write "<h2>Index Page</h2> <ul> <% posts.each do |post| %> <li><a href='<%= post.permalink %>'><%= post.title %></a></li> <% end %> </ul>"
    end
    File.open File.join(test_site_layouts, "atom.erb"), "w" do |f|
      f.write <<EOF
<?xml version="1.0" encoding="utf-8"?>
 
<feed xmlns="http://www.w3.org/2005/Atom">
 
  <title><%= site.title %></title>
  <link href="<%= site.feed_url %>" rel="self" />
  <link href="<%= site.url %>" />
  <updated><%= Date.today %></updated>
  <author>
          <name><%= site.author[:name] %></name>
          <email><%= site.author[:email] %></email>
  </author>

  <% posts.each do |post| %>

  <entry>
    <title><%= post.title %></title>
    <link href="<%= post.link || post.permalink %>" />
    <updated><%= post.date %></updated>
    <summary><%= post.content %></summary>
  </entry>

  <% end %>
</feed>
EOF
    end

    5.times do
      create_note
    end
  end
  
  task :reset do
    test_site = File.join Dir.pwd, "test"
    test_site_posts = File.join test_site, "posts"
    test_site_output  = File.join test_site, "site"

    FileUtils.rm_rf test_site_posts
    Dir.mkdir test_site_posts 
    FileUtils.rm_rf test_site_output
    Dir.mkdir test_site_output

    5.times do
      create_note
    end
  end


end


def create_note
    @@count ||= 0
    test_site = File.join Dir.pwd, "test"
    test_site_posts = File.join test_site, "posts"

    tags      = ["tag_one", "tag_two", "interesting", "rant", "misc", "writing", "tech", "web"]
    descripts = ["descript_one", "descript_two", "descript_three", "descript_four", "descript_five"]
    dates     = ["2009-01-02-03-04", "2010-12-12-12-12", "2011-06-18-12-04", "2012-12-23-04-59"]
    titles    = ["Title One", "Title Two", "Title Three", "Title Four", "Title Four", "Title Five"]
    texts     = ["Some text for the post", "Some text for a different Post", "Here's another post", "And one more"]
    r         = Random.new

    filename = "#{dates[r.rand(dates.length)]}-#{descripts[r.rand(descripts.length)]}-#{tags[r.rand(tags.length)]}-#{tags[r.rand(tags.length)]}.txt"
    File.open File.join(test_site_posts, filename), "w" do |file|
      file.write "##Title #{Time.now.to_i}#{@@count += 1}\n\n#{texts[r.rand(texts.length)]}"
    end
end
