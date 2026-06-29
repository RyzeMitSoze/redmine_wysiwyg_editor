Redmine::Plugin.register :redmine_wysiwyg_editor do
  name 'Redmine WYSIWYG Editor plugin'
  author 'Takeshi Nakamura'
  description 'Redmine WYSIWYG text editor'
  version '0.101.3'
  url 'https://github.com/taqueci/redmine_wysiwyg_editor'
  author_url 'https://github.com/taqueci'

  project_module :visual_editor do
    permission :use_visual_editor, { redmine_wysiwyg_editor: [] },
               public: true, require: :member
  end

  settings default: { settings_visual_editor_mode_switch_tab: '',
                      settings_visual_editor_dark_mode: '' },
           partial: 'redmine_wysiwyg_editor/setting'
end

require File.expand_path('lib/redmine_wysiwyg_editor', __dir__)

Rails.application.config.after_initialize do
  next unless Rails.env.production?

  require 'rake'

  File.open(Rails.root.join('tmp/redmine_wysiwyg_editor_precompile.lock'), 'w') do |file|
    next unless file.flock(File::LOCK_EX | File::LOCK_NB)

    Rails.logger.info('[redmine_wysiwyg_editor] Running assets:precompile')

    Rails.application.load_tasks
    Rake::Task['assets:precompile'].reenable
    Rake::Task['assets:precompile'].invoke

    Rails.logger.info('[redmine_wysiwyg_editor] assets:precompile finished')
  end
rescue => e
  Rails.logger.error("[redmine_wysiwyg_editor] assets:precompile failed: #{e.class}: #{e.message}")
end

