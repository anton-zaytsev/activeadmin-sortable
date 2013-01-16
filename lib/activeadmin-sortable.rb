require 'activeadmin-sortable/version'
require 'activeadmin'
require 'rails/engine'

module ActiveAdmin
  module Sortable
    module ControllerActions
      def sortable
        collection_action :sort, :method => :post do
          params[:positions].each do |resource_id, position|
            active_admin_collection.update resource_id, {"#{params[:field]}" => position}
          end

          head 200
        end
      end
    end

    module TableMethods
      HANDLE = '&#8801;'.html_safe

      def sortable_handle_column *args
        options = args.extract_options!
        sortable_field = options[:field] || :weight

        column '', class: 'handle' do |resource|
          #require 'pry'
          #binding.pry
          sort_url = url_for([:sort, :admin, resource.class.name.downcase.pluralize])
          content_tag :span, HANDLE, 'data-sort-url' => sort_url, 'data-field' => sortable_field, style: 'font-size: 16px;vertical-align: middle;cursor:move;'
        end
      end
    end

    ::ActiveAdmin::ResourceDSL.send(:include, ControllerActions)
    ::ActiveAdmin::Views::TableFor.send(:include, TableMethods)

    class Engine < ::Rails::Engine
      # Including an Engine tells Rails that this gem contains assets
    end
  end
end


