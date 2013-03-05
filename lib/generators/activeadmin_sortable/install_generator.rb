module ActiveadminSortable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc << "Description:\n    Copies source files to your application's app directory and required gems."

      source_root File.expand_path('../templates', __FILE__)

      def add_assets
        if File.exist?('app/assets/javascripts/active_admin.js')
          scripts_content = File.read('app/assets/javascripts/active_admin.js')
          scripts_require_string = 'require activeadmin-sortable'

          if scripts_content.include? scripts_require_string
            say_status(:exists, "app/assets/javascripts/active_admin.js", :yellow)
          else
            insert_into_file "app/assets/javascripts/active_admin.js",
                             "//= #{scripts_require_string}\n", :after => "base\n"
          end

        else
          puts "It doesn't look like you've installed activeadmin: active_admin.js is missing.\nPlease install it and try again."
        end

        if File.exist?('app/assets/stylesheets/active_admin.css.scss')
          styles_content = File.read('app/assets/stylesheets/active_admin.css.scss')
          styles_scss_string = "@import \"activeadmin-sortable\";"

          if styles_content.include? styles_scss_string
            say_status(:exists, "app/assets/stylesheets/active_admin.css.scss", :yellow)
          elsif styles_content.include? '@import "active_admin/base";'
            insert_into_file "app/assets/stylesheets/active_admin.css.scss",
                             "#{styles_scss_string}\n", :after => "@import \"active_admin/base\";\n"
          else
            insert_into_file "app/assets/stylesheets/active_admin.css.scss",
                             "//= require activeadmin-sortable\n", :before => "// Active Admin CSS Styles\n"
          end
        else
          puts "It doesn't look like you've installed activeadmin: active_admin.scss is missing.\nPlease install it and try again."
        end

      end
    end
  end
end