# TODO move this to the base_helper?

module Admin::BaseHelper
  def new_admin_content_path(section)
    type = section.class.content_type.gsub('::', '_').underscore.downcase
    send :"new_admin_#{type}_path", section.site, section
  end

  def edit_admin_content_path(content)
    type = content.section.class.content_type.gsub('::', '_').underscore.downcase
    send :"edit_admin_#{type}_path", content.site, content.section, content
  end
  
  def view_resource_link(resource, path, options={})
    text = options.delete(:text) || t(:'adva.resources.view')
    resource_link text, path, options.reverse_merge(:class => 'view', :id => "view_#{resource_class(resource)}_#{resource.id}")
  end

  def edit_resource_link(resource, path, options={})
    text = options.delete(:text) || t(:'adva.resources.edit')
    resource_link text, path, options.reverse_merge(:class => 'edit', :id => "edit_#{resource_class(resource)}_#{resource.id}")
  end

  def delete_resource_link(resource, path, options={})
    text = options.delete(:text) || t(:'adva.resources.delete')
    klass = resource_class(resource)
    options.reverse_merge!(:class => 'delete', :id => "delete_#{klass}_#{resource.id}", :confirm => t(:"adva.#{klass.pluralize}.confirm_delete"), :method => :delete)
    resource_link text, path, options
  end

  def save_or_cancel_links(builder, options={})
    save_text   = options.delete(:save_text)   || t(:'adva.common.save')
    or_text     = options.delete(:or_text)     || t(:'adva.common.connector.or')
    cancel_text = options.delete(:cancel_text) || t(:'adva.common.cancel')
    cancel_url  = options.delete(:cancel_url)

    save_options = options.delete(:save) || {}
    save_options.reverse_merge!(:id => 'commit')

    cancel_options = options.delete(:cancel) || {}
    # cancel_options.reverse_merge!(:id => 'cancel')

    builder.buttons do
      returning '' do |buttons|
        buttons << submit_tag(save_text, save_options)
        buttons << " #{or_text} #{link_to(cancel_text, cancel_url, cancel_options)}" if cancel_url
      end
    end
    nil # need to return nil here so we don't get duplicate output
  end

  def admin_site_select_tag
    return '' unless current_user.has_role?(:superuser) || Site.multi_sites_enabled
    options = []

    if current_user.has_role?(:superuser)
      options << [t(:'adva.links.sites_overview'), admin_sites_path]
      options << [t(:'adva.links.superusers_admins'), admin_users_path]
      options << ['------------------', '#']
    end

    # TODO only show sites where the user actually has access to!
    options += Site.all.collect { |site| [site.name, admin_site_path(site)] }

    selection = options.reverse.detect { |name, url| request.path.starts_with?(url) }

    select_tag 'site_select', options_for_select(options, selection)
  end

  def link_to_profile(site = nil, options = {})
    name = options[:name].nil? ? t(:'adva.links.profile') : options[:name]

    if site.nil? || site.new_record? || current_user.has_role?(:superuser)
      link_to(name, admin_user_path(current_user))
    else
      link_to(name, admin_site_user_path(site, current_user))
    end
  end

  def content_translation_links(content, view)
    content.translated_locales.map { |tl|
      link_to tl, edit_admin_article_url(content.site, content.section, content, :cl => tl)
    }.join(', ')
  end

  def section_translation_links(section, view)
    section.translated_locales.map { |tl|
      link_to tl, edit_admin_section_url(section.site, section, :cl => tl)
    }.join(', ')
  end


  private
  def resource_class(resource)
    resource.class.to_s.tableize.singularize
  end

  def resource_link(text, path, options={})
    link_to text, path, options
  end
end
