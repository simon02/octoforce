class ImportController < ApplicationController
  skip_before_filter :onboarding

  def twitter_setup
  end

  def twitter
    identity = Identity.find_by id: params['identity_id'], user: current_user
    if identity
      category = Category.find_or_create_by name: "Import #{identity.subname} #{Time.zone.now.strftime("%Y%m%d%H%M")}", user: current_user
      TwitterImporter.new.import identity, category, twitter_import_params
      redirect_to import_show_twitter_path(category.id)
    else
      redirect_to import_twitter_path, notice: "Could not find that social media account"
    end
  end

  def show_twitter
    @updates = ImportedUpdate.where category_id: params['id']
    render :twitter
  end

  def csv_setup
    @csvs = Csv.where(user: current_user).order created_at: :desc
  end

  def csv_preview
    @col_sep = params["col_sep"] || ','
    options = {
      chunk_size: 1,
      col_sep: @col_sep
    }
    @csv_file_path = params['csv_file'].path
    @example_data = CsvImporter.new(params['csv_file'].path, nil, options).head 1
  end

  def csv_import
    csv = Csv.create user: current_user, file: open(params['csv_file_path'])
    CsvImporterWorker.perform_async current_user.id, csv.id, csv_import_params
    # redirect_to import_csv_path, notice: "Your CSV file is currently being processed. Refresh this page to view its status."

    if current_user.onboarding_active && current_user.onboarding_step == 5
      redirect_to welcome_step6_path
    else
      redirect_with_param import_csv_path, notice: "Your CSV file is currently being processed. Refresh this page to view its status."
    end
  end

  def import
    updates = []
    import_params.each do |u|
      update = ImportedUpdate.find_by_id u['id']
      if update
        update.update category_id: u['category_id']
        updates << update
      end
    end
    count = 0
    updates.reverse.each do |u|
      count += u.create_post ? 1 : 0
    end
    if current_user.onboarding_active && current_user.onboarding_step == 5
      redirect_to welcome_step6_path
    else
      redirect_with_param library_path, notice: "Saved #{count} posts to your library. Images are being uploaded."
    end
  end

  private

  def import_params
    params.require('updates').map { |u| u.permit(:id, :category_id)}
  end

  def twitter_import_params
    params.permit(:count, :min_favorites, :min_retweets, :single_condition, :skip_octoforce)
  end

  def csv_import_params
    permitted_params = params.permit(:col_sep)
    if params["key_mapping"]
      permitted_params.merge "key_mapping" => params["key_mapping"]
    else
      permitted_params
    end
  end

end
