module Diffbot
  # Public: Extend a hash with this mixin to make keys coercible to certain
  # classes. These keys, when assigned to the hash, will be transformed into the
  # specified classes.
  #
  # The object you pass as coercion types should implement either a `coerce` or
  # a `new` method.
  #
  # You can define rules to coerce properties into classes or collections of
  # classes. In the latter case, CoercibleHash will just map over whatever value
  # is passed and attempt to coerce each item individually to the given class.
  #
  # Examples
  #
  #   class Address < Struct.new(:street, :zipcode, :state)
  #     def self.coerce(address)
  #       new(address[:street], address[:zipcode], address[:state])
  #     end
  #   end
  #
  #   class Person < Hash
  #     extend Diffbot::CoercibleHash
  #
  #     coerce_property :address, Address
  #     coerce_property :children, collection: Person
  #
  #     def name
  #       self["name"]
  #     end
  #   end
  #
  #   person = Person.new(address: {
  #     street: "123 Example St.", zipcode: "12345", state: "XX"
  #   })
  #
  #   person.address.street #=> "123 Example St."
  #   # etc.
  #
  #   father = Person.new(name: "John", children: [
  #     { name: "Tim" }, { name: "Sarah" }
  #   ])
  #
  #   father.name                #=> "John"
  #   father.children.first.name #=> "Tim"
  #   father.children.last.name  #=> "Sarah"
  module CoercibleHash
    # The coercion rules defined for this hash.
    attr_reader :coercions

    # Adds a #[]= that checks for coercion on the property and delegates to super.
    def self.extended(base)
      base.instance_variable_set("@coercions", {})
      base.class_eval do
        def []=(property, value)
          if self.class.coercions.key?(property.to_s)
            super property, self.class.coercions[property.to_s].(value)
          else
            super
          end
        end
      end
    end

    # Public: Coerce a property of this hash into a given type. We will try to
    # call .coerce on the object you pass as the class, and if that fails, we will
    # call .new.
    #
    # property - The name of the property to coerce.
    # class_or_options  - Either a class to which coerce, or a hash with options:
    #                     * class:      The class to which coerce
    #                     * collection: Coerce the key into an array of members of
    #                                   this class.
    #
    # Examples
    #
    #   class Person < Hash
    #     extend Diffbot::CoercibleHash
    #
    #     coerce_property :address, Address
    #
    #     coerce_property :children, collection: Person
    #
    #     coerce_property :dob, class: Date
    #   end
    def coerce_property(property, options)
      unless options.is_a?(Hash)
        options = { class: options }
      end

      coercion_method = ->(obj) do
        if obj.respond_to?(:coerce)
          obj.method(:coerce)
        elsif obj.respond_to?(:new)
          obj.method(:new)
        else
          raise ArgumentError, "#{obj.inspect} does not implement neither .coerce nor .new"
        end
      end

      if options.has_key?(:collection)
        klass = options[:collection]
        coercion = ->(value) { value.map { |el| coercion_method[klass][el] } }
      elsif options.has_key?(:class)
        klass = options[:class]
        coercion = ->(value) { coercion_method[klass][value] }
      else
        raise ArgumentError, "You need to specify either :class or :collection"
      end

      coercions[property.to_s] = coercion
    end
  end
end
