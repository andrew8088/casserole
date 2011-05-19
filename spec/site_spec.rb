require_relative '../bin/site'

describe 'Site' do

  before :all do
    `rake test:reset`
    @site_path = File.join Dir.pwd, "test"
    @site = Site.new "Shaky Takes", "http://shakytakes.com", "atom.xml", { name: "Andrew Burgess", email: "andrew@shakytakes.com" }, @site_path
  end

  before :each do
    `rake test:create_note`
  end

  it "should be an instance of Site" do
    @site.should be_an_instance_of Site
  end

  it "should move posts after processing" do
    @site.process_new_posts
    Dir.glob(File.join(@site.posts_path, "*")).should be_empty
  end

  it "should generate tag pages" do
    post_tags = Dir.glob(File.join @site_path, "posts", "*").map do |post|
      post.match(/(\d{4}-\d{2}-\d{2}-?(\d{2}-\d{2})?)-(\w*)-([\w-]*)/)[4].split("-")
    end.flatten.uniq.map { |p| p.gsub "_", "-" }

    @site.process_new_posts

    tag_pages = Dir.glob(File.join @site_path, "site", "tag", "*.html").map do |tag_page|
      tag_page.split("/").last.split(".").first
    end.flatten.uniq

    (post_tags - tag_pages).should be_empty
  end

  it "should be able to regenerate all pages" do
    titles = []
    ["old_posts","posts"].each do |dir|
      titles << Dir.glob(File.join @site_path, dir, "*").map do |post|
        File.open(post) { |f| f.readline.split("#").last.chomp.downcase.gsub " ", "-" }
      end
    end
    titles = titles.flatten.uniq.sort

    @site.regenerate!

    processed_titles = Dir.glob(File.join @site_path, "site", "*.html").map do |post|
      post = post.split("/").last.split(".").first
    end.uniq.sort
    processed_titles.delete "index"

    titles.should == processed_titles
  end

  it "should generate monthly archive pages" do
    dates = Dir.glob(File.join @site_path, "posts", "*").map do |f|
      Date.parse(f.match(/(\d{4}-\d{2}-\d{2}-?(\d{2}-\d{2})?)-(\w*)-([\w-]*)/)[1]).strftime("%Y%m")
    end.uniq
    
    archives = Dir.glob(File.join @site_path, "site", "[0-9][0-9][0-9][0-9]", "[0-9][0-9]").map do |month|
      md = month.match(/(\d{4})\/(\d{2})/)
      "#{md[1]}#{md[2]}"
    end
    (dates - archives).should be_empty
  end

  it "should generate an atom feed" do 
    f = File.new File.join(@site_path, "site", "atom.xml")
    f.should be_an_instance_of File
  end
end
