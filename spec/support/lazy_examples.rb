def it_is_expected_to(things={}, negate=false, title='is expected to')
  describe title do
    to_or_not = negate ? :to_not : :to

    if (to_not = things.delete(:not))
      it_is_expected_to to_not, true, 'not'
    end

    things.each do |matcher, column|
      column = [column] unless column.is_a? Array

      column.each do |col|
        if col === true
          it(matcher.to_s.humanize.downcase) {
            is_expected.send to_or_not, self.send(matcher)
          }
        elsif col.is_a? Array
          (actual_col, options) = col
          options ||= {}

          it("#{matcher.to_s.humanize.downcase} #{actual_col}") {
            start = self.send(matcher, actual_col)

            chain = options.inject(start) { |o, option|
              (key, values) = option
              o.send(key, values)
            }

            is_expected.send to_or_not, chain
          }
        else
          it("#{matcher.to_s.humanize.downcase} #{col}") {
            is_expected.send to_or_not, self.send(matcher, col)
          }
        end
      end
    end
  end
end
