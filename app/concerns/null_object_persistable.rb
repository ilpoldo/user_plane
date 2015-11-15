module NullObjectPersistable
  extend ActiveSupport::Concern

  included do
    def self.mimics_persistence_from(real_model_class)
      @real_model_class = real_model_class
    end

    def self.real_model_class
      @real_model_class
    end

    def self.table_name
      @real_model_class.to_s.tableize
    end

    def self.primary_key
      "id"
    end
  end

  def real_model_class
    self.class.real_model_class
  end

  def id
  end

  def [](*)
  end

  def []=(*)
  end

  def has_attribute? attribute
    real_model_class.new().has_attribute? attribute
  end

  def is_a?(klass)
    if klass == real_model_class
      true
    else
      super
    end
  end

  def destroyed?
    false
  end

  def new_record?
    false
  end

  def persisted?
    false
  end

  def marked_for_destruction?
    false
  end
end