##
## Embed Flickr photos in a Jekyll blog.
##
## Copyright (C) 2015 Lawrence Murray, www.indii.org.
##
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by the Free
## Software Foundation; either version 2 of the License, or (at your option)
## any later version.
##
require 'flickraw'
require 'rubysl/shellwords'

module Jekyll
  def self.flickr_setup(site)
    # defaults
    if !site.config['flickr']['cache_dir']
      site.config['flickr']['cache_dir'] = '_flickr'
    end
    if !site.config['flickr']['size_full']
      site.config['flickr']['size_full'] = 'Large'
    end
    if !site.config['flickr']['size_thumb']
      site.config['flickr']['size_thumb'] = 'Large Square'
    end

    if not site.config['flickr']['use_cache']
      # clear any existing cache
      cache_dir = site.config['flickr']['cache_dir']

      if Dir.exists?(cache_dir)
        FileUtils.rm_rf(cache_dir)
      end
      if !Dir.exists?(cache_dir)
        Dir.mkdir(cache_dir)
      end

      # populate cache from Flickr
      FlickRaw.api_key = site.config['flickr']['api_key']
      FlickRaw.shared_secret = site.config['flickr']['api_secret']

      nsid = flickr.people.findByUsername(:username => site.config['flickr']['screen_name']).id
      flickr_photosets = flickr.photosets.getList(:user_id => nsid)

      flickr_photosets.each do |flickr_photoset|
        # This will ensure, every photoset gets cached
        photoset = Photoset.new(site, flickr_photoset)
      end
    end
  end

  class Photoset
    attr_accessor :id, :title, :slug, :cache_dir, :cache_file, :photos

    def initialize(site, photoset)
      self.photos = Array.new
      if photoset.is_a? String
        self.cache_load(site, photoset)
      else
        self.flickr_load(site, photoset)
      end
      self.photos.sort! {|left, right| left.position <=> right.position}
    end

    def flickr_load(site, flickr_photoset)
      self.id = flickr_photoset.id
      self.title = flickr_photoset.title
      self.slug = self.title.downcase.gsub(/ /, '-').gsub(/[^a-z\-]/, '')
      self.cache_dir = File.join(site.config['flickr']['cache_dir'], self.slug)
      self.cache_file = File.join(site.config['flickr']['cache_dir'], "#{self.slug}.yml")

      # write to cache
      self.cache_store

      # create cache directory
      if !Dir.exists?(self.cache_dir)
        Dir.mkdir(self.cache_dir)
      end

      # photos
      flickr_photos = flickr.photosets.getPhotos(:photoset_id => self.id).photo
      flickr_photos.each_with_index do |flickr_photo, pos|
        self.photos << Photo.new(site, self, flickr_photo, pos)
      end
    end

    def cache_load(site, file)
      cached = YAML::load(File.read(file))
      self.id = cached['id']
      self.title = cached['title']
      self.slug = cached['slug']
      self.cache_dir = cached['cache_dir']
      self.cache_file = cached['cache_file']

      file_photos = Dir.glob(File.join(self.cache_dir, '*.yml'))
      file_photos.each_with_index do |file_photo, pos|
        self.photos << Photo.new(site, self, file_photo, pos)
      end
    end

    def cache_store
      cached = Hash.new
      cached['id'] = self.id
      cached['title'] = self.title
      cached['slug'] = self.slug
      cached['cache_dir'] = self.cache_dir
      cached['cache_file'] = self.cache_file

      File.open(self.cache_file, 'w') {|f| f.print(YAML::dump(cached))}
    end

    def gen_html
      content = ''
      self.photos.each do |photo|
        content += photo.gen_thumb_html
      end
      return content
    end
  end

  class Photo
    attr_accessor :id, :title, :slug, :date, :description, :tags, :url_full, :url_thumb, :cache_file, :position

    def initialize(site, photoset, photo, pos)
      if photo.is_a? String
        self.cache_load(photo)
      else
        self.flickr_load(site, photoset, photo, pos)
      end
    end

    def flickr_load(site, photoset, flickr_photo, pos)
      # init
      self.id = flickr_photo.id
      self.title = flickr_photo.title
      self.slug = self.title.downcase.gsub(/ /, '-').gsub(/[^a-z\-]/, '') + '-' + self.id
      self.date = ''
      self.description = ''
      self.tags = Array.new
      self.url_full = ''
      self.url_thumb = ''
      self.cache_file = File.join(photoset.cache_dir, "#{self.id}.yml")
      self.position = pos

      # sizes request
      flickr_sizes = flickr.photos.getSizes(:photo_id => self.id)
      if flickr_sizes
        size_full = flickr_sizes.find {|s| s.label == site.config['flickr']['size_full']}
        if size_full
          self.url_full = size_full.source
        end

        size_thumb = flickr_sizes.find {|s| s.label == site.config['flickr']['size_thumb']}
        if size_thumb
          self.url_thumb = size_thumb.source
        end
      end

      # other info request
      flickr_info = flickr.photos.getInfo(:photo_id => self.id)
      if flickr_info
        print "Found info about photo: #{flickr_info.title}: #{flickr_info.description} --- #{flickr_info.dates.posted}\n"
        self.date = flickr_info.dates.posted
        self.description = flickr_info.description
        flickr_info.tags.each do |tag|
          self.tags << tag.raw
        end
      end

      cache_store
    end

    def cache_load(file)
      cached = YAML::load(File.read(file))
      self.id = cached['id']
      self.title = cached['title']
      self.slug = cached['slug']
      self.date = cached['date']
      self.description = cached['description']
      self.tags = cached['tags']
      self.url_full = cached['url_full']
      self.url_thumb = cached['url_thumb']
      self.cache_file = cached['cache_file']
      self.position = cached['position']
    end

    def cache_store
      cached = Hash.new
      cached['id'] = self.id
      cached['title'] = self.title
      cached['slug'] = self.slug
      cached['date'] = self.date
      cached['description'] = self.description
      cached['tags'] = self.tags
      cached['url_full'] = self.url_full
      cached['url_thumb'] = self.url_thumb
      cached['cache_file'] = self.cache_file
      cached['position'] = self.position

      File.open(self.cache_file, 'w') {|f| f.print(YAML::dump(cached))}
    end

    def gen_thumb_html
      content = ''
      if self.url_full and self.url_thumb
        content = "<a href=\"#{self.url_full}\" data-lightbox=\"photoset\"><img src=\"#{self.url_thumb}\" alt=\"#{self.title}\" title=\"#{self.title}\" class=\"photo thumbnail\" width=\"75\" height=\"75\" /></a>\n"
      end
      return content
    end

    def gen_full_html
      content = ''
      if self.url_full and self.url_thumb
        content = "<p><a href=\"#{self.url_full}\" data-lightbox=\"photoset\"><img src=\"#{self.url_full}\" alt=\"#{self.title}\" title=\"#{self.title}\" class=\"photo full\" /></a></p>\n<p>#{self.description}</p>\n"
        if self.tags
          content += "<p>Tagged <i>" + self.tags.join(", ") + ".</i></p>\n"
        end
      end
      return content
    end
  end

  class PhotoPage < Page
    def initialize(site, base, dir, photo)
      #@site = site
      #@base = base
      #@dir = dir
      #@name = 'index.html'

      #self.process(@name)

      #name = photo.date[0..9] + '-photo-' + photo.slug + '.md'

      #self.read_yaml(File.join(base, '_layouts'), 'flickr_photo.html')
      self.data = Hash.new
      self.data['title'] = photo.title
      self.data['shorttitle'] = photo.title
      self.data['content'] = photo.description
      self.data['about'] = photo.description
      self.data['categories'] = photo.tags
      #data['date'] = photo.date.gsub('\'', '').gsub('"', '').sub('T', ' ').sub('+', ' +')
      self.data['date'] = DateTime.strptime(photo.date, '%s').strftime('%Y-%m-%d %H:%M:%S +0000')
      self.data['slug'] = photo.slug
      #data['permalink'] = File.join('/archives', photo.slug, 'index.html')
      self.data['flickr'] = Hash.new
      self.data['flickr']['id'] = photo.id
      self.data['flickr']['url_full'] = photo.url_full
      self.data['flickr']['url_thumb'] = photo.url_thumb

      self.data['image'] = photo.url_full
      self.data['image-sm'] = photo.url_thumb

      if site.config['flickr']['generate_frontmatter']
        site.config['flickr']['generate_frontmatter'].each do |key, value|
          self.data[key] = value
        end
      end

      #File.open(File.join('_posts', name), 'w') {|f|
        #f.print(YAML::dump(data))
        #f.print('date: ', photo.date.gsub('\'', '').gsub('"', '').sub('T', ' ').sub('+00:', ' +00'))
        #f.print("\n\n---\n\n")
        #f.print(photo.gen_full_html)
      #}

      date = DateTime.strptime(photo.date, '%s')
      ymd = date.strftime('%Y/%m/%d')
      exact_dir = "#{ymd}/#{photo.slug}"
      #@dir = exact_dir
      #self
      super(site, base, exact_dir, "index.html")
    end

    # Compare this document against another document.
    # Comparison is a comparison between the 2 paths of the documents.
    #
    # Returns -1, 0, +1 or nil depending on whether this doc's path is less than,
    #   equal or greater than the other doc's path. See String#<=> for more details.
    def <=>(other)
      return nil unless other.respond_to?(:data)

      adt = data['date']
      bdt = other.data['date']

      unless adt.nil? || bdt.nil?
        print "adt: #{adt.class}, bdt: #{bdt.class}\n"
        a = DateTime.parse(adt.to_s)
        b = DateTime.parse(bdt.to_s)
        print "a: #{a.class}, b: #{b.class}\n"

        a = DateTime.strptime(adt, '%Y-%m-%d %H:%M:%S') if adt.is_a?String || adt
        b = DateTime.strptime(bdt, '%Y-%m-%d %H:%M:%S') if bdt.is_a?String || bdt
        print "a: #{a.class}, b: #{b.class}\n"
        cmp = a.strftime('%s').to_i <=> b.strftime('%s').to_i
      end

      cmp = data['title'] <=> other.data['title'] if cmp.nil? || cmp.zero?
      cmp * -1
    end
  end

  class FlickrPageGenerator < Generator
    safe true
    priority :high

    def generate(site)
      Jekyll::flickr_setup(site)
      cache_dir = site.config['flickr']['cache_dir']

      file_photosets = Dir.glob(File.join(cache_dir, '*.yml'))
      file_photosets.each_with_index do |file_photoset, file_photoset_pos|
        photoset = Photoset.new(site, file_photoset)
        if site.config['flickr']['generate_photosets'].include? photoset.title
          # generate photo pages if requested
          if site.config['flickr']['generate_posts']
            file_photos = Dir.glob(File.join(photoset.cache_dir, '*.yml'))
            file_photos.each do |file_photo, file_photo_pos|
              photo = Photo.new(site, photoset, file_photo, file_photo_pos)
              page_photo = PhotoPage.new(site, site.source, 'flickr', photo)

              # posts need to be in a _posts directory, but this means Jekyll has already
              # read in photo posts from any previous run... so for each photo, update
              # its associated post if it already exists, otherwise create a new post
              site.posts.docs.each_with_index do |post, post_pos|
                if post.data['slug'] == photo.slug
                  #site.posts.docs.delete_at(post_pos)
                end
              end
              site.posts.docs << page_photo

              page_photo.data['categories'].each do |cat|
                site.categories[:cat] << page_photo['id']
              end
            end
          end
        end
      end

      # re-sort posts by date
      site.posts.docs.sort! {|left, right|
        #bool = left <=> right
        #print "left to right: #{bool}\n"
        #print "title: left: #{left['title']}, right: #{right['title']}\n"
        #print "date: left: #{left['date']}, right: #{right['date']}\n"
        #bool

        adt = left.data['date']
        bdt = right.data['date']

        unless adt.nil? || bdt.nil?
          print "adt: #{adt.class}, bdt: #{bdt.class}\n"
          a = DateTime.parse(adt.to_s)
          b = DateTime.parse(bdt.to_s)
          print "a: #{a.class}, b: #{b.class}\n"

          a = DateTime.strptime(adt, '%Y-%m-%d %H:%M:%S') if adt.is_a?String || adt
          b = DateTime.strptime(bdt, '%Y-%m-%d %H:%M:%S') if bdt.is_a?String || bdt
          print "a: #{a.class}, b: #{b.class}\n"
          cmp = a.strftime('%s').to_i <=> b.strftime('%s').to_i
        end

        cmp = left.data['title'] <=> right.data['title'] if cmp.nil? || cmp.zero?
        cmp * -1
      }

      print "\n\n---\nPosts are now ordered like this\n"

      site.posts.docs.each do |post|
        print "Post: #{post.data['title']}\n"
      end
    end
  end

  class FlickrPhotosetTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      params = RubySL::Shellwords.shellwords markup
      title = params[0]
      @slug = title.downcase.gsub(/ /, '-').gsub(/[^a-z\-]/, '')
    end

    def render(context)
      site = context.registers[:site]
      Jekyll::flickr_setup(site)
      file_photoset = File.join(site.config['flickr']['cache_dir'], "#{@slug}.yml")
      photoset = Photoset.new(site, file_photoset)
      return photoset.gen_html
    end
  end

end

Liquid::Template.register_tag('flickr_photoset', Jekyll::FlickrPhotosetTag)

