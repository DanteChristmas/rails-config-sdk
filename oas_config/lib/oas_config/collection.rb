module OasConfig
  class Collection
    include OasConfig::Validations
    extend Forwardable
    attr_accessor :meta, :object_type
    # TODO: reject!, uniq!, +, - alter the content list but currently don't update the meta data
    def_delegators :@list, :<<, :[], :[]=, :length, :empty?, :first, :each, :map, :reject, :reject!, :uniq, :uniq!, :+, :-, :each_with_index, :select, :to_a

    def initialize(clazz, list=[], meta={})
      update(clazz, list, meta)
    end

    def any?
      length > 0
    end

    def size
      length
    end

    def map!
      @list ||= []
      @list.map!
    end

    def self.from_response(clazz, response)
      if response.status == 200
        data = response.body
        content = data[:content] || []
        data.delete(:content)
        OasConfig::Collection.new clazz, content, data
      else
        collection = OasConfig::Collection.new clazz
        collection.errors = response.body
        collection.status = response.status
        collection
      end
    end

    def self.from_json(data, clazz)
      data = Oj.load data, mode: :object

      data[:content] ||= []

      if clazz
        objects = data[:content].map do |object|
          clazz.new object
        end
      else
        objects = data[:content]
      end

      data.delete(:content)
      OasConfig::Collection.new clazz, objects, data
    end

    def to_json
      if self.valid?
        hash = @meta.clone
        hash[:content] = @list.map{|o| o.dto.to_hash}

        Oj.dump hash
      else
        Oj.dump errors
      end
    end

    def page_number
      @meta[:number]
    end

    def method_missing(meth, *args, &block)
      # Converts method name from symbol
      method_name = meth.to_s

      # Checks to see if this is an assignment method. If so, throw an error
      super if method_name.match(/(\=|\?)$/)

      # Checks the dto for the camelized version of the method that was passed. AWESOME SAUCE
      @meta[method_name.camelize(:lower)]
    end

  private
    def update(clazz, list=[], meta={})
      @object_type = clazz
      @meta = meta
      @list = list.map do |obj|
        if obj.is_a?(clazz)
          obj
        else
          clazz.new obj
        end
      end
      self.status = 200
    end
  end
end
