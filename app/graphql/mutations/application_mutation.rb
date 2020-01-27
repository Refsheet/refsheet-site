class Mutations::ApplicationMutation
  include Pundit
  include Helpers::SessionHelper
  include ParamsHelper

  def self.before_action(callback, options={})
    @before_actions ||= []
    @before_actions.push callback: callback, options: options
  end

  def self.before_actions
    @before_actions || []
  end

  def self.action(name, &proc)
    field = GraphQL::Field.define &proc
    classy = name.to_s.classify

    field.name ||= self.name.gsub(/^Mutations::|Mutation$/, '') + classy

    field.resolve = -> (object, inputs, context) {
      resolver = self.new(object, inputs, context, name)
      resolver.run_before_actions(name)
      resolver.send(name)
    }

    self.const_set classy, field
  end

  attr_accessor :object

  def initialize(object, inputs, context, action)
    @object = object
    @inputs = inputs
    @context = context
    @action = action
  end

  def action_name
    @action
  end

  def params
    ActionController::Parameters.new @inputs.to_h
  end

  def context
    OpenStruct.new @context.to_h
  end

  def run_before_actions(action_name)
    Rails.logger.info "Processing by #{self.class.name}##{action_name} as GRAPHQL"
    # TODO: Enable this once we can get the parameter filter on here.

    unless Rails.env.production?
      Rails.logger.info "  Parameters: #{params.as_json}"
    end

    self.class.before_actions.each do |action|
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
