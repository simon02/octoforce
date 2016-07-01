class CsvImporterWorker
  include Sidekiq::Worker

  def perform user_id, csv_id, identity_ids, options = {}
    user = User.find_by id: user_id
    csv = Csv.find_by id: csv_id
    return unless user && csv
    parser = PostParser.new(user, csv, identity_ids)
    CsvImporter.new(open(csv.file.url, 'r'), parser, options).run

    csv.update finished: true

    # ActiveRecord::Base.transaction do
    #   array.each do |row|
    #     next if (row["category"] || '').empty? || (row["text"] || '').empty?
    #     begin
    #       category = Category.find_or_create_by name: row["category"], user_id: user_id
    #     rescue ActiveRecord::RecordNotUnique
    #       retry
    #     end
    #     post = category.posts.new user_id: user_id, text: row["text"]
    #     if post.save
    #       if row["image_url"]
    #         asset = Asset.new user_id: user_id
    #         asset.media = open(row["image_url"])
    #         asset.posts << post
    #         asset.save
    #       end
    #     end
    #   end
    # end
  end

  class PostParser

    def initialize user, csv, identity_ids
      @user = user
      @csv = csv
      @identity_ids = identity_ids
    end

    def parse row, index
      return unless @csv.processed <= index
      ActiveRecord::Base.transaction do
        category = Category.find_or_create_by name: row[:category], user: @user
        post = Post.new \
          user: @user,
          text: row[:text],
          category: category,
          social_media_posts_attributes: @identity_ids.map { |i| { identity_id: i } }
        if post.save
          if row[:image_url]
            asset = Asset.create user: @user, posts: [post]
            AssetWorker.perform_async asset.id, row[:image_url]
          end
          @csv.succeeded += 1
        end
        @csv.processed += 1
        @csv.save
      end
    end

  end

end
