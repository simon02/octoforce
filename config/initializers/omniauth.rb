module OmniAuth::Strategies

  class FacebookPage < Facebook
    def name
      :facebook_page
    end
  end

  class FacebookGroup < Facebook
    def name
      :facebook_group
    end
  end

end
