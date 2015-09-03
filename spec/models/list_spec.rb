require 'rails_helper'

RSpec.describe List, type: :model do

  describe 'add_to_front' do
    it 'should be able to handle empty lists' do
      list = List.new
      post = Post.new
      list.add_to_front post
      expect(list.next_post).to eq(post)
      expect(post.next).to eq(post)
    end

    it 'should be able to handle a list with a single item' do
      list = List.new
      p1 = Post.new
      p2 = Post.new
      list.add_to_front p1
      list.add_to_front p2
      expect(list.next_post).to eq(p2)
      puts p1.inspect
      puts p2.inspect
      expect(p2.next).to eq(p1)
      expect(p1.next).to eq(p2)
    end

    it 'should be able to handle a list with multiple items' do
      list = List.create
      p1 = Post.create
      p2 = Post.create
      p3 = Post.create
      list.add_to_front p1
      list.add_to_front p2
      list.add_to_front p3
      expect(list.next_post).to eq(p3)
      puts p1.inspect
      puts p2.inspect
      puts p3.inspect
      expect(p3.next).to eq(p2)
      expect(p2.next).to eq(p1)
      expect(p1.next).to eq(p3)
    end

    it 'should also work with updates' do
      list = List.new
      p1 = Post.new
      c1 = ContentItem.new
      p1.content_items << c1
      p2 = Post.new
      c2 = ContentItem.new
      c3 = ContentItem.new
      p2.content_items << c2
      list.add_to_front p1
      list.updates << Update.new(content_item: c1, scheduled_at: (Time.now + 1.hours))
      list.updates << Update.new(content_item: c3, scheduled_at: (Time.now + 2.hours))
      list.add_to_front p2
      expect(list.next_post).to eq(p2)
      expect(list.updates.count).to eq(2)
      expect(list.updates.map &:content_item).to eq([c2,c1])
    end
  end

  describe 'add_to_back' do

    it 'should be able to handle empty lists' do
      list = List.new
      post = Post.new
      list.add_to_back post
      expect(list.next_post).to eq(post)
      expect(post.next).to eq(post)
    end

    it 'should be able to handle non-empty lists' do
      list = List.new
      p1 = Post.new
      p2 = Post.new
      list.add_to_back p1
      list.add_to_back p2
      expect(list.next_post).to eq(p1)
      expect(p2.next).to eq(p1)
      expect(p1.next).to eq(p2)
    end
  end

  describe '#sorted_posts' do

    it 'should sort posts based on next' do
      list = List.new
      list.add_to_front Post.new id: 1
      list.add_to_front Post.new id: 2
      list.add_to_front Post.new id: 3
      list.add_to_front Post.new id: 4
      expect(list.sorted_posts.map &:id).to eq([4,3,2,1])
    end

  end

end
