module Jekyll
  module SproutTimeFilter
    def sprout_time_filter(seed)
      require 'date'
      diff = ''

      if (seed['sown'].is_a? Date)
        if (seed['sprout'].is_a? Date)
          diff_i = (seed['sprout'] - seed['sown']).to_i
          diff = diff_i.to_s
        end
      end

      diff
    end
  end
end

Liquid::Template.register_filter(Jekyll::SproutTimeFilter)
