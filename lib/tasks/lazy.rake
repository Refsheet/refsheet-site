namespace :lazy do
  namespace :expect do
    desc 'Generates expectation hash for models.'
    task :generate => :environment do

      all_models.each do |model|
        expectations = {}

        model.reflections.each do |name, reflection|
          ex_name = map_names reflection.macro
          next unless ex_name

          if expectations[ex_name].nil?
            expectations[ex_name] = name.to_sym
            next
          elsif expectations[ex_name].is_a? Symbol
            expectations[ex_name] = [expectations[ex_name]]
          end

          expectations[ex_name] << name.to_sym
        end

        model.validators.each do |validator|
          name, ex_name = validator.attributes, map_names(validator.class.name.demodulize)
          next unless ex_name

          if expectations[ex_name].nil?
            expectations[ex_name] = name.many? ? name.collect(&:to_sym) : name.first.to_sym
            next
          elsif expectations[ex_name].is_a? Symbol
            expectations[ex_name] = [expectations[ex_name]]
          end

          expectations[ex_name].push *name.collect(&:to_sym)
        end

        output = JSON.pretty_generate expectations
        output.gsub! /:/, ' =>'
        output.gsub! /"(\w+)"/, ':\1'
        output.gsub! /:(\w+)\s*=>/, '\1:'

        puts
        puts "=== #{model}:"
        puts "it_is_expected_to(\n#{output.gsub /^\{\n|\n?}$/, ''}\n)"

        filename = model.to_s.underscore.gsub '::', '/'

        puts
        puts "- spec/models/#{filename}_spec.rb"
      end
    end
  end

  class Class
    def extend?(klass)
      puts klass.inspect
      not superclass.nil? and ( superclass == klass or superclass.extend? klass )
    end
  end

  def all_models
    Dir["#{Rails.root}/app/models/**/*.rb"].each do |model_path|
      puts "Loading #{model_path}..."
      require_relative model_path
    end

    Module.constants.collect do |constant_name|
      eval constant_name.to_s
    end.select do |constant|
      constant.is_a? Class and constant.extend? ActiveRecord::Base
    end
  end

  def map_names(macro)
    macro = macro.to_sym
    macros = {
        belongs_to: :belong_to,
        has_and_belongs_to_many: :have_and_belong_to_many,
        has_many: :have_many,
        has_one: :have_one,
        PresenceValidator: :validate_presence_of,
        NumericalityValidator: :validate_numericality_of,
        ConfirmationValidator: :validate_confirmation_of,
        AcceptanceValidator: :validate_acceptance_of
    }
    macros[macro]
  end
end
