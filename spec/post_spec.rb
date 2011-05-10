require_relative '../bin/post'

describe 'Posts' do 

  before :each do
    Post.post_template = File.join Dir.pwd, "test", "layouts", "post.erb"
    Post.link_template = File.join Dir.pwd, "test", "layouts", "link.erb"

    textfiles = Dir.glob File.join(Dir.pwd, "test","posts", "*.txt")
    r = Random.new
    @post = Post.new textfiles[r.rand(textfiles.length)]
  end

  describe 'title' do
    it 'should exist' do
      @post.should respond_to :title
    end
    it 'should be a string' do
      @post.title.should be_an_instance_of String
    end
  end
  describe 'date' do
    it 'should exist' do
      @post.should respond_to :date
    end
    it 'should be a date' do
      @post.date.should be_an_instance_of Date
    end
  end
  describe 'tags' do
    it 'should exist' do
      @post.should respond_to :tags
    end
    it 'should be an array' do
      @post.tags.should be_an_instance_of Array
    end
  end
  describe 'content' do
    it 'should exists' do
      @post.should respond_to :content
    end
    it 'should be a string' do
      @post.content.should be_an_instance_of String 
    end
  end
  describe 'permalink' do
    it 'should exist' do
      @post.should respond_to :permalink
    end
    it 'should be a string' do
      @post.permalink.should be_an_instance_of String
    end
  end
  describe 'slug' do
    it 'should exist' do
      @post.should respond_to :slug
    end
    it 'should be a string' do
      @post.slug.should be_an_instance_of String
    end
  end

  # Post Spec

  it 'should render itself' do
    @post.render.should be_an_instance_of String
  end

end
