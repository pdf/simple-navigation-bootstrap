# Simple Navigation for Bootstrap
This gem adds a renderer for [Simple Navigation](http://github.com/andi/simple-navigation) to output markup compatible 
with [Twitter Bootstrap](http://twitter.github.com/bootstrap/).

_MAINTAINER WANTED_: Whilst this likely works as is, I don't do much Rails work these days, so I'd be happy to hand this over to someone if they'd like to take over maintenance

## Getting Started
For Rails >= 3, simply add this gem to your `Gemfile`:
```ruby
gem 'simple-navigation-bootstrap'
```
and run
```
bundle install
```
Follow the [configuration instructions](https://github.com/andi/simple-navigation/wiki/Configuration) on the Simple Navigation wiki for initial configuration.

To use the Bootstrap renderer, specify it in your view:
```ruby
render_navigation :expand_all => true, :renderer => :bootstrap
```

And the minimal navigation config you need is:
```ruby
SimpleNavigation::Configuration.run do |navigation|  
  navigation.items do |primary|
    primary.dom_class = 'nav'
  end
end
```

See below for a more complete example.

## Additional Functionality
### Icons
In addition to generating Bootstrap-comptible list markup, you may specify 
an `:icon` attribute on your navigation items, either as an array 
or string, containing Bootstrap [icon classes](http://twitter.github.com/bootstrap/base-css.html#icons), to add an icon to the item.

### Split navigation
For items with sub-navigation, you may specify `:split => true` on an item to
enable a split dropdown.  Split dropdowns allow using an url on the primary
navigation item, as well as having a dropdown containing sub-navigation.  If
you plan on using this feature, in your `application.css` or equivalent you
must require the `bootstrap_navbar_split_dropdowns` stylesheet after
requiring Bootstrap.

For example:
```css
/*
*= require bootstrap_and_overrides
*= require bootstrap_navbar_split_dropdowns
*/
```

You may also enable split navigation for all children by setting the `split`
attribute of the container to `true` (defaults to `false`).

### Dropdowns
If you wish to disable dropdown attributes for some reason (eg -you don't use the
JavaScript, or have custom handling), you may specify `:dropdown => false` on an
item, or set the `dropdown` attribute on the container to `false` (defaults to
`true`).

## Examples
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
    primary.dropdown = true
    primary.split = false
  end
end
```

## Caveats
Requires Bootstrap version >= 2.1.0

## Further Reading
* [Twitter Bootstrap Documentation](http://twitter.github.com/bootstrap/)
* [Simple Navigation Wiki](https://github.com/andi/simple-navigation/wiki/)

## TODO
So far, only nav markup and dropdowns are supported, may also implement 
buttons and nav lists in the future. And tests, there are currently no
tests.
