module Jekyll

  class CategoryPage < Page
    # Initialize a new Page.
    #
    # site - The Site object.
    # base - The String path to the source.
    # dest_dir  - The String path between the dest and the file.
    # dest_name - The String name of the destination file (e.g. index.html or myproduct.html)
    # src_dir  - The String path between the source and the file.
    # src_name - The String filename of the source page file, minus the markdown or html extension
    # data_mtime - mtime of the products.json data file, used for sitemap generator
    #def initialize(site, base, dest_dir, dest_name, src_dir, src_name, data_mtime )
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category

      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
    end
  end

  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'category_index'
        dir = site.config['category_dir'] || 'categories'
        site.categories.each_key do |category|
          site.pages << CategoryPage.new(site, site.source, File.join(dir, category), category)
        end
      end
    end
  end

end
