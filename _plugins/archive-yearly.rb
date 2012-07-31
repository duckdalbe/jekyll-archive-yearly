module Jekyll

  class ArchiveYearlyPage < Page
    def initialize(site, year, posts)
      @site = site
      @base = site.source
      @dir = ""
      @name = "#{year}/index.html"

      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'archive-yearly.html')
      self.data['year'] = year
      self.data['posts'] = posts
    end
  end

  class CategoryPageGenerator < Generator
    safe true
    
    def generate(site)
      if site.config['archive-yearly']
        site.posts.group_by{ |p| p.date.year }.each do |year,posts|
          site.pages << ArchiveYearlyPage.new(site, year, posts.reverse)
        end
      end
    end
  end

  class ArchiveYearlyLinksTag < Liquid::Tag
    def render(context)
      html = '<ul>'
      context.registers[:site].posts.map do |p|
        p.date.year
      end.uniq.each do |year|
        html << "<li><a href='/#{year}/'>#{year}</a></li>"
      end
      html << '</ul>'
    end
  end

  Liquid::Template.register_tag('archive_yearly_links', Jekyll::ArchiveYearlyLinksTag)

end
