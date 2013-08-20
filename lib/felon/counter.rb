class Felon::Counter

  FLUSH_INTERVAL = 2

  @@updates = { views: {}, conversions: {}, interactions: {} }
  @@semaphore = Mutex.new
  
  def self.record_view(variant_id)
    increment(:views, variant_id)
  end
  
  def self.record_interaction(variant_id)
    increment(:interactions, variant_id)
  end
  
  def self.record_conversion(variant_id)
    increment(:conversions, variant_id)
  end
  
  def self.flush
    Rails.logger.debug "[Felon] Flushing counts to database..."

    views = interactions = conversions = {}
    @@semaphore.synchronize do
      # make sure we kick off another synchronization thread at the next
      # recorded view / conversion
      @@thread = nil

      # get all the updates we need to save to disk; immediately replace
      # the hashes here so we can continue recording new conversions
      # while we sync the old ones to disk
      views = @@updates[:views]
      @@updates[:views] = {}

      interactions = @@updates[:interactions]
      @@updates[:interactions] = {}

      conversions = @@updates[:conversions]
      @@updates[:conversions] = {}
    end

    (views.keys | interactions.keys | conversions.keys).each do |variant_id|
      Felon::Variant.update_counters variant_id, views: views[variant_id].to_i, interactions: interactions[variant_id].to_i, conversions: conversions[variant_id].to_i
    end
  end

  private
  def self.start_flush_thread
    @@thread ||= Thread.new do
      begin
        # only write to the database once every ten seconds
        sleep FLUSH_INTERVAL

        # ready, set, go
        flush

        # every thread has its own database connection; we need to close it
        # to avoid problems
        ActiveRecord::Base.connection.close
      rescue => e
        Rails.logger.error "Felon update thred error: #{e.inspect}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  end

  def self.increment(type, variant_id)
    @@semaphore.synchronize do
      # make sure there's a background thread to flush this to disk
      start_flush_thread

      # update the actual count
      @@updates[type][variant_id] = @@updates[type][variant_id].to_i + 1
    end
  end
  
end
