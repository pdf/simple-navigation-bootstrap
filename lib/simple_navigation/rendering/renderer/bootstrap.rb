module SimpleNavigation
  module Renderer
    class Bootstrap < SimpleNavigation::Renderer::Base
      def render(item_container)
        config_selected_class = SimpleNavigation.config.selected_class
        SimpleNavigation.config.selected_class = 'active'
        list_content = item_container.items.inject([]) do |list, item|
          li_options = item.html_options.reject {|k, v| k == :link}
          li_content = tag_for(item, li_options.delete(:icon), li_options.delete(:badge))
          icon = li_options.delete(:icon)
		  badge = li_options.delete(:badge)
          split = (include_sub_navigation?(item) and li_options.delete(:split))
          li_content = tag_for(item, item.name, icon, split, badge)
          if include_sub_navigation?(item)
            if split
              lio = li_options.dup
              lio[:class] = [li_options[:class], 'dropdown-split-left'].flatten.compact.join(' ')
              list << content_tag(:li, li_content, lio)
              item.html_options[:link] = nil
              li_options[:id] = nil
              li_content = tag_for(item)
            end
            item.sub_navigation.dom_class = [item.sub_navigation.dom_class, 'dropdown-menu', split ? 'pull-right' : nil].flatten.compact.join(' ')
            li_content << render_sub_navigation_for(item)
            li_options[:class] = [li_options[:class], 'dropdown', split ? 'dropdown-split-right' : nil].flatten.compact.join(' ')
          end
          list << content_tag(:li, li_content, li_options)
        end.join
        SimpleNavigation.config.selected_class = config_selected_class
        if skip_if_empty? && item_container.empty?
          ''
        else  
          content_tag(:ul, list_content, {:id => item_container.dom_id, :class => item_container.dom_class}) 
        end
      end

      protected

      def tag_for(item, name = '', icon = nil, split = false, badge = {})
        unless item.url or include_sub_navigation?(item)
          return item.name
        end
        url = item.url
        link = Array.new
        link << content_tag(:span, badge[:value].call, :class => ["badge", badge[:class]].flatten.compact.join(' ')) if badge.present? and badge[:value]
        link << content_tag(:i, '', :class => [icon].flatten.compact.join(' ')) unless icon.nil?
        link << name
        if include_sub_navigation?(item)
          item_options = item.html_options
          item_options[:link] = Hash.new if item_options[:link].nil?
          item_options[:link][:class] = Array.new if item_options[:link][:class].nil?
          unless split
            item_options[:link][:class] << 'dropdown-toggle'
            item_options[:link][:'data-toggle'] = 'dropdown'
            item_options[:link][:'data-target'] = '#'
            link << content_tag(:b, '', :class => 'caret')
          end
          item.html_options = item_options
        end
        link_to(link.join(" ").html_safe, url, options_for(item))
      end

    end
  end
end
