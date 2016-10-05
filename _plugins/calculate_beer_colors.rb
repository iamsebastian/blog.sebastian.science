module Jekyll
    class Malt
        def initialize(obj, weight)
            @name = obj['name']
            @ebc = obj['ebc']
            @weight = weight
        end

        def get_name
            @name
        end

        def get_ebc
            if (@ebc.is_a? Fixnum)
                return @ebc
            end

            print "\nEBC is not a Fixnum! #{@ebc}"
            ebc = 0
            ebcs = @ebc.split('-')
            ebcs.each do |val|
                ebc += val.to_f
            end
            @ret = ebc/ebcs.length
            print "\nEBC will return with: #{@ret}"
            @ret
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
            @e = 2.718281828459045235
            # ~ 20 Liter H2O.
            @gals_water = 5.283
            # malt color units
            # mcu = (grain_color * grain_weight_lbs)/volume_gallons
            @mcu = 0
            # srm beer color
            @srm = 0
            # ebc beer color
            @ebc = 0
        end

        def gals_to_litre(gals)
            gals * 3.785411784
        end

        def litre_to_gals(l)
            l / 3.785411784
        end

        def kg_to_lbs(kg)
            kg * 2.205
        end

        def gram_to_lbs(gram)
            kg_to_lbs(gram / 1000)
        end

        def ebc_to_srm(ebc)
            ebc / 1.97
        end

        def srm_to_ebc(srm)
            srm * 1.97
        end

        def mcu_from_ebc_and_weight(malt)
            print "\nMalt #{malt.get_name}: #{ebc_to_srm(malt.get_ebc)} SRM, #{gram_to_lbs(malt.get_weight)} lbs"
            (ebc_to_srm(malt.get_ebc) * gram_to_lbs(malt.get_weight)) / @gals_water
        end

        def srm_from_mcu(mcu)
            # "**" == "Math.pow"
            print "\nmcu: #{mcu}"
            1.4922 * (mcu ** 0.6859)
        end

        def calc_ebc_from_malt(malt)
            @mcu = mcu_from_ebc_and_weight(malt)
            @srm = srm_from_mcu(@mcu)
            @ebc = srm_to_ebc(@srm)
            print "\nCalculated '#{malt.get_name}': \n  MCU: #{@mcu}\n  SRM: #{@srm}\n  EBC: #{@ebc}"
            @ebc
        end

        def get_ebcs(beer, data_malts)
            used_malts = beer['malts']

            used_malts.each do |malt|
                data_malt = data_malts[malt[0]]
                new_malt = Malt.new(data_malt, malt[1])
                @ebc += calc_ebc_from_malt(new_malt)
            end

            # Round
            "%.2f" % @ebc
        end

        def render(context)
            beer_no = context['page']['beer']

            beer = context.registers[:site].data['beer'][beer_no]
            data_malts = context.registers[:site].data['malts']

            if (!beer_no || !beer)
                return
            end

            print "\n=========\nDebugging beer: #{beer['name']}"

            if (beer['water'])
                print "\n* Recipe has another water batch: #{beer['water']}"
                @gals_water = litre_to_gals(beer['water'])
            end

            get_ebcs(beer, data_malts)
        end
    end
end

Liquid::Template.register_tag('calc_beer', Jekyll::CalculateBeerColors)
