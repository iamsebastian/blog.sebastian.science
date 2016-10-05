module Jekyll
    class Malt
        def initialize(obj, weight)
            @ebc = obj['ebc']
            @weight = weight
        end

        def get_ebc
            if (@ebc.is_a? Fixnum)
                return @ebc
            end

            ebc = 0
            ebcs = @ebc.split('-')
            ebcs.each do |val|
                ebc += val.to_f
            end
            @weight * ebc/ebcs.length
        end

        def get_weight
            @weight
        end
    end

    class CalculateBeerColors < Liquid::Tag
        def initialize(tag_name, text, tokens)
            super
            @text = text
            @ebc = 0
            @weight = 0
        end

        def get_ebcs(beer, data_malts)
            used_malts = beer['malts']

            used_malts.each do |malt|
                data_malt = data_malts[malt[0]]
                new_malt = Malt.new(data_malt, malt[1])
                @ebc += new_malt.get_ebc
                @weight += new_malt.get_weight
            end

            # Round
            "%.2f" % (@ebc / @weight)
        end

        def render(context)
            beer_no = context['page']['beer']

            beer = context.registers[:site].data['beer'][beer_no]
            data_malts = context.registers[:site].data['malts']

            if (!beer_no || !beer)
                return
            end

            get_ebcs(beer, data_malts)
        end
    end
end

Liquid::Template.register_tag('calc_beer', Jekyll::CalculateBeerColors)
