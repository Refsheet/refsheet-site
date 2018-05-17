class Mutations::ApplicationMutation
  @@before_actions = []

  def self.before_action(callback, options={})
    @@before_actions.push callback: callback, options: options
  end

  def self.action(name, &proc)
    field = GraphQL::Field.define &proc
    classy = name.to_s.classify

    field.name ||= self.name.gsub(/^Mutations::|Mutation$/, '') + classy

    field.resolve = -> (object, inputs, context) {
      resolver = self.new(object, inputs, context)
      resolver.run_before_actions(name)
      resolver.send(name)
    }

    self.const_set classy, field
  end

  attr_accessor :object

  def initialize(object, inputs, context)
    @object = object
    @inputs = inputs
    @context = context
  end

  def params
    ActionController::Parameters.new @inputs.to_h
  end

  def context
    OpenStruct.new @context.to_h
  end

  def run_before_actions(action_name)
    @@before_actions.each do |action|
      callback = action[:callback]
      options = action[:options]

      except = options[:except] && options[:except].map(&:to_s).include?(action_name.to_s)
      only = !options[:only] || options[:only].map(&:to_s).include?(action_name.to_s)

      if !except and only
        self.send(callback)
      end
    end
  end

  def authorize!(check, message=nil)
    check ? nil : not_allowed!(message)
  end

  def not_allowed!(message='You are not authorized to access this resource.')
    raise GraphQL::ExecutionError.new message
  end
end
