module OmniAuth::Strategies

  class FacebookPages < Facebook
    def name
      :facebook_pages
    end
  end

  class FacebookGroups < Facebook
    def name
      :facebook_groups
    end
  end

end
