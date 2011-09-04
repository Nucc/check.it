class Response
  include ActiveModel::Serializers::JSON
  include ActiveModel::Serializers::Xml
 
  attr_accessor :attributes

  def initialize(args = {})
    @attributes = {}
    args.each do |key, value|
      @attributes[key.to_s] = value.to_s
    end
  end
  
  def method_missing(method)
    return @attributes[method.to_s]
  end
end
