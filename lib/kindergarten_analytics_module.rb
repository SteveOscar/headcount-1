module KindergartenAnalytics

    def kindergarten_participation_rate_variation_trend(district, compared_to)
      answers = {}
      initial = dr.find_by_name(district).enrollment.enrollment_data.values.first
      comparison = dr.find_by_name(compared_to.values.join).enrollment.enrollment_data.values.first
      initial.each { |k, v| answers[k] = truncate((v.to_f / comparison[k].to_f)) }
      answers
    end

    def kindergarten_participation_against_high_school_graduation(district)
      kindergarten_variation = kindergarten_participation_rate_variation(district, :against => "COLORADO")
      initial = dr.find_by_name(district)
      comparison = dr.find_by_name("COLORADO")
      truncate((kindergarten_variation / (find_variation(initial, comparison, :high_school_graduation))))
    end

    def district_rate_shows_correlation?(rate)
      0.6 < rate && rate < 1.5
    end

    def district_kindergarten_participation_correlated_with_high_school_graduation?(district)
      rate = kindergarten_participation_against_high_school_graduation(district)
      district_rate_shows_correlation?(rate)
    end

    def kindergarten_participation_correlates_with_high_school_graduation(hash) ######changed colorado to statewide, update tests
      if hash == {:for => "STATEWIDE"}
        statewide_kindergarten_rates_show_correlation?
      elsif hash.keys == [:for]
        district_kindergarten_participation_correlated_with_high_school_graduation?(hash[:for])
      else
        get_range(hash)
      end
    end

    def get_range(hash)
      districts = hash[:across]
      correlated_districts = districts.select do |d|
        district_kindergarten_participation_correlated_with_high_school_graduation?(d)
      end
      correlated_districts.count / districts.count.to_f >= 0.7
    end

    def statewide_kindergarten_rates_show_correlation?
      rate = kindergarten_participation_against_high_school_graduation("COLORADO")
      rate >= 0.7
    end

    def truncate(num)
      (num * 1000).floor / 1000.0
    end
end
