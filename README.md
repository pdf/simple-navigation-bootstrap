== Simple Navigation for Bootstrap
This gem adds a renderer for {Simple Navigation}[http://github.com/andi/simple-navigation] to output markup compatible 
with {Twitter Bootstrap}[http://twitter.github.com/bootstrap/].

== Getting Started
For Rails >= 3, simply add this gem to your `Gemfile`:
 gem 'simple-navigation-bootstrap'
and run
 bundle install
Follow the {configuration instructions}[https://github.com/andi/simple-navigation/wiki/Configuration] on the Simple Navigation wiki for initial configuration.

To use the Bootstrap renderer, specify it in your view:
 render_navigation :expand_all => true, :renderer => :bootstrap

== Additional Functionality
In addition to generating Bootstrap-comptible list markup, you may specify 
an `:icon` attribute on your navigation items, either as an array 
or string, containing Bootstrap {icon classes}[http://twitter.github.com/bootstrap/base-css.html#icons], to add an icon to the item.

For items with sub-navigation, you may specify `:split => true` to enable a
split dropdown.  Split dropdowns allow using an url on the primary navigation
item, as well as having a dropdown containing sub-navigation.  If you plan on
using this feature, in your `application.css` or equivalent you must require
the `bootstrap_navbar_split_dropdowns` stylesheet after requiring Bootstrap.

For example:
```css
/*
*= require bootstrap_and_overrides
*= require bootstrap_navbar_split_dropdowns
*/
```

== Examples
To create a navigation menu, you might do something like this:
```ruby
SimpleNavigation::Configuration.run do |navigation|  
  navigation.items do |primary|
    primary.item :music, 'Music', musics_path
    primary.item :dvds, 'Dvds', dvds_path, :split => true do |dvds|
      dvds.item :action, 'Action', dvds_action_path
      dvds.item :drama, 'Drama', dvds_drama_path
    end
    primary.item :books, 'Books', :icon => ['icon-book', 'icon-white'] do |books|
      books.item :fiction, 'Fiction', books_fiction_path
      books.item :history, 'History', books_history_path
    end
    primary.dom_class = 'nav'
  end
end
```

== Caveats
Requires Bootstrap version >= 2.1.0

== Further Reading
* {Twitter Bootstrap Documentation}[http://twitter.github.com/bootstrap/]
* {Simple Navigation Wiki}[https://github.com/andi/simple-navigation/wiki/]

== TODO
So far, only nav markup and dropdowns are supported, may also implement 
buttons and nav lists in the future. And tests, there are currently no
tests.
