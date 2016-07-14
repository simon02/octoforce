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

  class LinkedInCompanyPage < LinkedIn
    def name
      :linkedin_page
    end
  end

end

OmniAuth.config.add_camelization 'linkedin_page', 'LinkedInCompanyPage'
