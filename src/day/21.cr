require "./day"

module Aoc
  class Day21 < Day
    # Items:
    # a b c d (dairy, fish)
    # e f g a (dairy)
    # c f     (soy)
    # c a g   (fish)
    #
    # Ingredients:
    # a b c d e f g
    # Allergens:
    # dairy, soy, fish
    #
    # Ingredients that can't contain allergens:
    # - b can't work, because if b had dairy,
    #   then item 2 would be wrong, and same for fish and item 4
    # - d can't work for the same reasons as b
    # - e can't work because item 1 would have to have e (dairy)
    # - g can't work because either as dairy or fish,
    #   it would have to be in item 1

    def first(input)
      items = parse_items input
      non_allergens = find_non_allergens items

      non_allergens.sum do |non_algn|
        items.count { |ings, algns| ings.includes?(non_algn) }
      end
    end

    def second(input)
      items = parse_items input
      allergen_map = find_allergens items

      allergen_map
        .to_a
        .sort { |pair1, pair2| pair1[1] <=> pair2[1] }
        .map { |ingredient, _allergen| ingredient }
        .join ","
    end

    def parse_items(lines)
      lines.map do |line|
        split = line.split " (contains "
        ingredients = split[0].split
        allergens = split[1][...-1].split ", "

        {ingredients, allergens}
      end
    end

    def find_non_allergens(items)
      all_ingredients = items
        .flat_map { |ings, _algns| ings }
        .uniq

      all_ingredients.select do |ingredient|
        appears_in = items
          .map_with_index { |item, index| item[0].includes?(ingredient) ? index : nil }
          .compact
        possible_allergens = appears_in
          .flat_map { |index| items[index][1] }
          .uniq

        if possible_allergens.empty?
          true
        else
          possible_allergens.all? do |poss_algn|
            items.any? do |ings, algns|
              algns.includes?(poss_algn) && !ings.includes?(ingredient)
            end
          end
        end
      end
    end

    def find_allergens(items)
      non_allergens = find_non_allergens items
      all_ingredients = items
        .flat_map { |ings, _algns| ings }
        .uniq
      problem_ingredients = all_ingredients - non_allergens
      problem_items = items.map { |ings, algns| {ings - non_allergens, algns} }
      allergen_map = {} of String => String

      remaining_allergens = all_allergens = items
        .flat_map { |_ings, algns| algns }
        .uniq
      until remaining_allergens.empty?
        find_allergen = remaining_allergens
          .each
          .compact_map do |allergen|
            items_with_allergen = problem_items
              .to_a
              .select { |item| item[1].includes? allergen }
            common_ingredients = items_with_allergen
              .skip(1)
              .reduce(items_with_allergen.first?.try(&.[0]) || [] of String) do |common, item|
                common & item[0]
              end

            if common_ingredients.size == 1
              {common_ingredients.first, allergen}
            else
              nil
            end
          end

        ingredient, allergen = find_allergen.first
        remaining_allergens.delete allergen
        allergen_map[ingredient] = allergen
        problem_items.each do |item|
          item[0].delete ingredient
          item[1].delete allergen
        end
      end

      allergen_map
    end
  end
end
