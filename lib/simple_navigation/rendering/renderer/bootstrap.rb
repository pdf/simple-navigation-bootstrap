module SimpleNavigation
  module Renderer
    class Bootstrap < SimpleNavigation::Renderer::Base
      def render(item_container)
        return '' if respond_to?(:skip_if_empty?) && skip_if_empty? && item_container.empty?
        config_selected_class = SimpleNavigation.config.selected_class
        SimpleNavigation.config.selected_class = 'active'
        list_content = item_container.items.inject([]) do |list, item|
          li_options = item.html_options.reject {|k, v| k == :link}
          icon = li_options.delete(:icon)
          dropdown = item_container.dropdown.nil? ? true : item_container.dropdown
          split = item_container.split
          split = (include_sub_navigation?(item) and li_options.delete(:split)) if li_options.include?(:split)
          dropdown = (include_sub_navigation?(item) and li_options.delete(:dropdown)) if li_options.include?(:dropdown)
          li_content = tag_for(item, item.name, icon, split, dropdown)
          if include_sub_navigation?(item)
            if split
              lio = li_options.dup
              lio[:class] = [li_options[:class], 'dropdown-split-left'].flatten.compact.join(' ')
              list << content_tag(:li, li_content, lio)
              item.html_options[:link] = nil
              li_options[:id] = nil
              li_content = tag_for(item)
            end
            item.sub_navigation.dom_class = [item.sub_navigation.dom_class, dropdown ? 'dropdown-menu' : nil, split ? 'pull-right' : nil].flatten.compact.join(' ')
            li_content << render_sub_navigation_for(item)
            li_options[:class] = [li_options[:class], dropdown ? 'dropdown' : nil, split ? 'dropdown-split-right' : nil].flatten.compact.join(' ')
          end
          list << content_tag(:li, li_content, li_options)
        end.join
        SimpleNavigation.config.selected_class = config_selected_class
        if item_container.respond_to?(:dom_attributes)
          dom_attributes = item_container.dom_attributes
        else
          # supports simple-navigation before the ItemContainer#dom_attributes
          dom_attributes = {:id => item_container.dom_id, :class => item_container.dom_class}
        end
        content_tag(:ul, list_content, dom_attributes)
        end
      end

      protected

      def tag_for(item, name = '', icon = nil, split = false, dropdown = false)
        unless item.url or include_sub_navigation?(item)
          return item.name
        end
        url = item.url
        link = Array.new
        link << content_tag(:i, '', :class => [icon].flatten.compact.join(' ')) unless icon.nil?
        link << name
        if include_sub_navigation?(item)
          item_options = item.html_options
          item_options[:link] = Hash.new if item_options[:link].nil?
          item_options[:link][:class] = Array.new if item_options[:link][:class].nil?
          unless split
            if dropdown
              item_options[:link][:class] << 'dropdown-toggle'
              item_options[:link][:'data-toggle'] = 'dropdown'
              item_options[:link][:'data-target'] = '#'
            end
            link << content_tag(:b, '', :class => 'caret')
          end
          item.html_options = item_options
        end
        link_to(link.join(" ").html_safe, url, options_for(item))
      end

    end
  end
end
