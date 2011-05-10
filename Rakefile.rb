require 'date'

namespace :test do

  task :setup do
    test_site = File.join Dir.pwd, "test"
    test_site_posts = File.join test_site, "posts"
    test_site_layouts = File.join test_site, "layouts"
    test_site_output  = File.join test_site, "site"

    Dir.mkdir test_site unless Dir.exists? test_site
    Dir.mkdir test_site_posts unless Dir.exists? test_site_posts
    Dir.mkdir test_site_layouts unless Dir.exists? test_site_layouts
    Dir.mkdir test_site_output unless Dir.exists? test_site_output

    File.open File.join(test_site_layouts, "layout.erb"), "w" do |f|
      f.write <<EOF
        <h1>Test Site</h1>
        <%= yield %>
EOF
    end
    File.open File.join(test_site_layouts, "post.erb"), "w" do |f|
      f.write <<EOF
      <h2><%= post.title %></h2>
      <%= post.content %>
EOF

    end



    tags      = ["tag_one", "tag_two", "interesting", "rant", "misc", "writing", "tech", "web"]
    descripts = ["descript_one", "descript_two", "descript_three", "descript_four", "descript_five"]
    dates     = ["2009-01-02-03-04", "2010-12-12-12-12", "2011-06-18-12-04", "2012-12-23-04-59"]
    titles    = ["Title One", "Title Two", "Title Three", "Title Four", "Title Four", "Title Five"]
    texts     = ["Some text for the post", "Some text for a different Post", "Here's another post", "And one more"]
    r         = Random.new

    5.times do
      filename = "#{dates[r.rand(dates.length)]}-#{descripts[r.rand(descripts.length)]}-#{tags[r.rand(tags.length)]}-#{tags[r.rand(tags.length)]}.txt"
      File.open File.join(test_site_posts, filename), "w" do |file|
        file.write "###{titles[r.rand(titles.length)]}\n\n#{texts[r.rand(texts.length)]}"
      end
    end
  end
end
