class Felon::Variant < ActiveRecord::Base

  belongs_to :experiment

  def conversion
    if views == 0
      0
    else
      conversions.to_f / views
    end
  end

  def optimistic_conversion
    Wilson::Interval.new(successes: conversions, total: views, confidence: 0.95).upper_bound
  end

  def ucb1_interval
    # avoid divide by 0 / ln(0) problems
    total_views = [1, experiment.variants.sum(:views)].max
    this_views = [1, self.views].max

    Math.sqrt(2 * Math.log(total_views) / this_views)
  end
  
end
