require 'wilson_interval'

class Felon::Variant < ActiveRecord::Base

  belongs_to :experiment

  def conversion
    if views == 0
      0
    else
      conversions.to_f / views
    end
  end

  def interaction_rate
    if views == 0
      0
    else
      interactions.to_f / views
    end
  end

  def optimistic_conversion
    if views == 0
      # make sure that we start showing this when we have absolutely no data at all
      1
    else
      conversion_upper_bound
    end
  end

  def conversion_upper_bound(confidence = 0.95)
    Wilson::Interval.new(successes: conversions, total: views, confidence: confidence).upper_bound
  end
  
  def conversion_lower_bound(confidence = 0.95)
    Wilson::Interval.new(successes: conversions, total: views, confidence: confidence).lower_bound
  end
  
  def interaction_rate_upper_bound(confidence = 0.95)
    Wilson::Interval.new(successes: interactions, total: views, confidence: confidence).upper_bound
  end
  
  def interaction_rate_lower_bound(confidence = 0.95)
    Wilson::Interval.new(successes: interactions, total: views, confidence: confidence).lower_bound
  end
  
  def weight
    sum_all = experiment.variants.map(&:optimistic_conversion).sum
    if sum_all == 0
      1.0 / experiment.variants.count
    else
      optimistic_conversion.to_f / sum_all
    end
  end

  def ucb1_interval
    # avoid divide by 0 / ln(0) problems
    total_views = [1, experiment.variants.sum(:views)].max
    this_views = [1, self.views].max

    Math.sqrt(2 * Math.log(total_views) / this_views)
  end
  
end
