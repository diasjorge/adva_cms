class AddTranslationsToSections < ActiveRecord::Migration
  def self.up
    Section.create_translation_table! :title => :string
    Section.all.each do |section|
      section.globalize_translations.create!(:title => section[:title], :locale => I18n.default_locale)
    end
  end
  def self.down
    Section.drop_translation_table!
  end
end
