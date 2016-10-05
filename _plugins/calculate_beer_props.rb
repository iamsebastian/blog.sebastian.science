class Malt
end

module Jekyll
  module CalculateBeerProps
    def calc_ebc(beer)
    end

    def get_sum_weight(beer)
        if (!beer)
            return
        end

        weight = 0

        beer['malts'].each do |malt|
            weight += malt[1]
        end

        "#{weight}g"
    end
  end
end

Liquid::Template.register_filter(Jekyll::CalculateBeerProps)
