require "typhoeus"
module RequestPool
  # http返回对象
  class Response < Typhoeus::Response
    def self.copy_by(other)
      response = new
      other.instance_variables.each do |v|
        response.instance_variable_set v, other.instance_variable_get(v)
      end
      response
    end
  end
end
