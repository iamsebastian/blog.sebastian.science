module Jekyll

  class CategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category
      self.data['title'] = category
    end
  end

  class CategoryPageGenerator < Generator
    safe true
    priority :low

    def generate(site)
      if site.layouts.key? 'category_index'
        dir = site.config['category_dir'] || 'category'
        print "Generate category pages:"
        site.categories.each_key do |category|
          print "category: #{category}\n"
          category_dir = File.join(dir, Utils.slugify(category))
          site.pages << CategoryPage.new(site, site.source, category_dir, category)
        end
      end
    end
  end

end
