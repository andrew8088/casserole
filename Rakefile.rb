require 'date'

namespace :test do
  task :create_new_post do 
    tags = ["one", "two", "three", "four", "fifth_tag", "sixth_tag"]
    descripts = ["some_post", "another_little_post", "heres_a_fourth", "next", "yet_another_killer_link"]

    r = Random.new

    filename = "#{Date.today.strftime("%Y-%m-%d")}-#{descripts[r.rand(4)]}-#{tags[r.rand(4)]}-#{tags[r.rand(4)]}.txt"

    File.open File.join(Dir.pwd, "test", "test_site", "posts", filename), "w" do |file| 
      file.write "##the title #{Time.now}\nthe body of the post"
    end
  end

  task :create_new_link do
    tags = ["one", "two", "three", "four", "fifth_tag", "sixth_tag"]
    descripts = ["some_post", "another_little_post", "heres_a_fourth", "next", "yet_another_killer_link"]

    r = Random.new

    filename = "#{Date.today.strftime("%Y-%m-%d")}-#{descripts[r.rand(4)]}-#{tags[r.rand(4)]}-#{tags[r.rand(4)]}.txt"

    File.open File.join(Dir.pwd, "test", "test_site", "posts", filename), "w" do |file| 
      file.write "##[the link #{Time.now}](http://net.tutsplus.com)\nthe body of the post" 
    end
  end

  desc "Run the unit tests in test"
  task :unit_tests do |t|
    Dir.glob("test/*_test.rb") do |file|
      `ruby #{file}`
    end
  end
end
