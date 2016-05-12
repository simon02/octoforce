# Parser class to be used in CsvImporter
class BasicPostParser

  def initialize user
    @user = user
  end

  def parse row
    category = Category.find_or_create_by name: row[:category], user: @user
    post = category.posts.new user: @user, text: row[:text]
    if post.save
      if row[:image_url]
        asset = Asset.new user: @user
        asset.media = open(row[:image_url])
        asset.posts << post
        asset.save
      end
      return true
    end
    return false
  end

end
