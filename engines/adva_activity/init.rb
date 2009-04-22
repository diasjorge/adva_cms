# hook activities into site
module Activities
  def self.included(base)
    base.has_many :activities, :dependent => :destroy
  end
end

Activities.include_into 'Site'

ActiveRecord::Base.observers += %w( activities/activity_observer activities/article_observer activities/section_observer)
ActiveRecord::Base.observers << 'activities/comment_observer'  if Rails.plugin?(:adva_comments)
ActiveRecord::Base.observers << 'activities/topic_observer'    if Rails.plugin?(:adva_forum)
ActiveRecord::Base.observers << 'activities/wikipage_observer' if Rails.plugin?(:adva_wiki)

I18n.load_path += Dir[File.dirname(__FILE__) + '/locale/**/*.yml']

register_stylesheet_expansion :admin => %w( adva_activity/admin/activities )
