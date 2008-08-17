module ActiveRecordMatchers
  class ActiveRecordAssociationMatch
    def initialize(expected)
      @expected = expected
    end
    def matches?(target)
      @target = target
      matches = true

      # Determine whether the target responds to the expected methods
      object_methods = @object_methods || []
      matches &&= begin
        object_methods.detect{|m| !@target.respond_to?(m)}.nil?
      rescue
        false
      end

      # Determine whether the target's association responds to the expected methods
      association_methods  = @association_methods || []
      matches &&= begin        
        assoc = @target.send(@expected)
        association_methods.detect{|m| !assoc.respond_to?(m)}.nil?
      rescue
        false
      end

      matches
    end
    def failure_message
      "expected #{@target.inspect} to #{assoc_name} #{@expected}"
    end
    def negative_failure_message
      "expected #{@target.inspect} to not #{assoc_name} #{@expected}"
    end
    def assoc_name
      @assoc_name ||= self.class.to_s.demodulize.tableize.singularize
    end
  end
  
  class BelongTo < ActiveRecordAssociationMatch
    def initialize(expected)
      @association_methods = [:nil?]
      super(expected)
      @object_methods = [@expected, (@expected.to_s + '=').to_sym]
    end
  end

  class HaveMany < ActiveRecordAssociationMatch
    def initialize(expected)
      @association_methods = [:empty?, :size, :<<, :delete, :find, :build, :create]
      super(expected)
      @object_methods      = [@expected]
    end
  end

  def belong_to(expected)
    BelongTo.new(expected)
  end

  def have_many(expected)
    HaveMany.new(expected)
  end
end
