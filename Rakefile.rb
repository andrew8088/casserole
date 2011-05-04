require 'date'

namespace :test do
  task :create_new_post do 
    tags = ["one", "two", "three", "four", "fifth_tag", "sixth_tag"]
    descripts = ["some_post", "another_little_post", "heres_a_fourth", "next", "yet_another_killer_link"]

    r = Random.new

    filename = "#{Date.today.strftime("%Y-%m-%d")}-#{descripts[r.rand(4)]}-#{tags[r.rand(4)]}-#{tags[r.rand(4)]}.txt"

    File.open File.join(Dir.pwd, "tests", "test_site", "posts", filename), "w" do |file| 
      file.write "##the title\nthe body of the post"
    end
  end

  task :create_new_link do
    tags = ["one", "two", "three", "four", "fifth_tag", "sixth_tag"]
    descripts = ["some_post", "another_little_post", "heres_a_fourth", "next", "yet_another_killer_link"]

    r = Random.new

    filename = "#{Date.today.strftime("%Y-%m-%d")}-#{descripts[r.rand(4)]}-#{tags[r.rand(4)]}-#{tags[r.rand(4)]}.txt"

    File.open File.join(Dir.pwd, "tests", "test_site", "posts", filename), "w" do |file| 
      file.write "##[the link](http://net.tutsplus.com)\nthe body of the post" 
    end
  end
end