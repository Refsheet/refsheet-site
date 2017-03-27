# Use this setup block to configure all options available in SimpleForm.
# https://github.com/patricklindsay/simple_form-materialize/blob/master/lib/generators/simple_form/materialize/templates/config/initializers/simple_form_materialize.rb
# contribute here: https://github.com/mkhairi/materialize-sass/issues/16
SimpleForm.setup do |config|

  config.wrappers :default, class: :input,
                  hint_class: :field_with_hint, error_class: :invalid do |b|
    ## Extensions enabled by default
    # Any of these extensions can be disabled for a
    # given input by passing: `f.input EXTENSION_NAME => false`.
    # You can make any of these extensions optional by
    # renaming `b.use` to `b.optional`.

    # Determines whether to use HTML5 (:email, :url, ...)
    # and required attributes
    b.use :html5

    # Calculates placeholders automatically from I18n
    # You can also pass a string as f.input placeholder: "Placeholder"
    b.use :placeholder

    ## Optional extensions
    # They are disabled unless you pass `f.input EXTENSION_NAME => true`
    # to the input. If so, they will retrieve the values from the model
    # if any exists. If you want to enable any of those
    # extensions by default, you can change `b.optional` to `b.use`.

    # Calculates maxlength from length validations for string inputs
    b.optional :maxlength

    # Calculates pattern from format validations for string inputs
    b.optional :pattern

    # Calculates min and max from length validations for numeric inputs
    b.optional :min_max

    # Calculates readonly automatically from readonly attributes
    b.optional :readonly

    ## Inputs
    b.use :label_input
    b.use :hint,  wrap_with: { tag: :div, class: 'help-block' }
    b.use :error, wrap_with: { tag: :span, class: 'error-block' }

    ## full_messages_for
    # If you want to display the full error message for the attribute, you can
    # use the component :full_error, like:
    #
    # b.use :full_error, wrap_with: { tag: :span, class: :error }
  end

  # https://github.com/plataformatec/simple_form/blob/754dc1d5d4ea010b1abdc9d386fcbfdcabc6baae/lib/simple_form.rb
  config.wrappers :materialize_string, tag: 'div', error_class: 'invalid' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper :container_wrapper, tag: 'div', class: 'input-field' do |ba|
      ba.use :label_input
    end

    b.use :hint,  wrap_with: { tag: :span, class: 'help-block' }
    b.use :error, wrap_with: { tag: :span, class: 'error-block' }
  end

  config.wrappers :materialize_file_input, tag: 'div', class: 'file-field input-field', error_class: 'invalid' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper :button_wrapper, tag: 'div', class: 'btn' do |button_wrapper|
      button_wrapper.use :label_text, wrap_with: { tag: :span }
      button_wrapper.use :input
    end

    b.wrapper :path_validate, tag: 'div', class: 'file-path-wrapper' do |path_validate_wrapper|
      path_validate_wrapper.use :input, class: 'file-path validate', type: 'text', name: 'zz'
      # path_validate_wrapper.wrapper :path_validate_input, tag: 'input', class: 'file-path validate', type: 'text' do
      # end
    end

    b.use :hint,  wrap_with: { tag: :span, class: 'help-block' }
    b.use :error, wrap_with: { tag: :span, class: 'error-block' }
  end

  config.wrappers :materialize_text_area, tag: 'div', class: 'input-field', error_class: 'invalid' do |b|
    b.use :html5
    b.optional :readonly

    b.use :input, class: 'materialize-textarea'
    b.use :label

    b.use :hint,  wrap_with: { tag: :span, class: 'help-block' }
    b.use :error, wrap_with: { tag: :span, class: 'error-block' }
  end

  config.wrappers :materialize_date, tag: 'div', class: '', error_class: 'invalid' do |b|
    b.use :html5
    b.optional :readonly

    b.use :input, class: 'datepicker'
    b.use :label_text

    b.use :hint,  wrap_with: { tag: :span, class: 'help-block' }
    b.use :error, wrap_with: { tag: :span, class: 'error-block' }
  end

  config.wrappers :materialize_multiple, tag: 'div', class: 'row', error_class: 'invalid' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper :label_wrapper, tag: 'div', class: 's12 col label' do |label_wrapper|
      label_wrapper.wrapper :tag => 'label' do |bb|
        bb.use :label_text
      end

      label_wrapper.use :hint,  wrap_with: { tag: :span, class: 'help-block' }
      label_wrapper.use :error, wrap_with: { tag: :span, class: 'error-block' }

    end

    b.wrapper :options_wrapper, tag: 'div', class: 's12 col options' do |options_wrapper|
      options_wrapper.use :input, wrap_with: { tag: :div }
    end

  end

  config.wrappers :two_columns, tag: 'div', class: 'row', error_class: 'invalid' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper :label_wrapper, tag: 'div', class: 's12 col label' do |label_wrapper|
      label_wrapper.wrapper :tag => 'label' do |bb|
        bb.use :label_text
      end

      label_wrapper.use :hint,  wrap_with: { tag: :span, class: 'help-block' }
      label_wrapper.use :error, wrap_with: { tag: :span, class: 'error-block' }
    end

    b.wrapper :options_wrapper, tag: 'div', class: 's12 col options two-columns' do |options_wrapper|
      options_wrapper.use :input
    end

  end

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :default

  # Define the way to render check boxes / radio buttons with labels.
  # Defaults to :nested for bootstrap config.
  #   inline: input + label
  #   nested: label > input
  config.boolean_style = :inline

  # Default class for buttons
  config.button_class = 'waves-effect waves-light btn'

  # Method used to tidy up errors. Specify any Rails Array method.
  # :first lists the first message for each field.
  # Use :to_sentence to list all errors for each field.
  # config.error_method = :first

  # Default tag used for error notification helper.
  config.error_notification_tag = :div

  # CSS class to add for error notification helper.
  config.error_notification_class = 'error_notification'

  # ID to add for error notification helper.
  # config.error_notification_id = nil

  # Series of attempts to detect a default label method for collection.
  # config.collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attempts to detect a default value method for collection.
  # config.collection_value_methods = [ :id, :to_s ]

  # You can wrap a collection of radio/check boxes in a pre-defined tag, defaulting to none.
  # config.collection_wrapper_tag = nil

  # You can define the class to use on all collection wrappers. Defaulting to none.
  # config.collection_wrapper_class = nil

  # You can wrap each item in a collection of radio/check boxes with a tag,
  # defaulting to :span.
  config.item_wrapper_tag = :div

  # You can define a class to use in all item wrappers. Defaulting to none.
  # config.item_wrapper_class = nil

  # How the label text should be generated altogether with the required text.
  # config.label_text = lambda { |label, required, explicit_label| "#{required} #{label}" }

  # You can define the class to use on all labels. Default is nil.
  # config.label_class = nil

  # You can define the default class to be used on forms. Can be overriden
  # with `html: { :class }`. Defaulting to none.
  # config.default_form_class = nil

  # You can define which elements should obtain additional classes
  # config.generate_additional_classes_for = [:wrapper, :label, :input]

  # Whether attributes are required by default (or not). Default is true.
  # config.required_by_default = true

  # Tell browsers whether to use the native HTML5 validations (novalidate form option).
  # These validations are enabled in SimpleForm's internal config but disabled by default
  # in this configuration, which is recommended due to some quirks from different browsers.
  # To stop SimpleForm from generating the novalidate option, enabling the HTML5 validations,
  # change this configuration to true.
  config.browser_validations = false

  # Collection of methods to detect if a file type was given.
  # config.file_methods = [ :mounted_as, :file?, :public_filename ]

  # Custom mappings for input types. This should be a hash containing a regexp
  # to match as key, and the input type that will be used when the field name
  # matches the regexp as value.
  # config.input_mappings = { /count/ => :integer }

  # Custom wrappers for input types. This should be a hash containing an input
  # type as key and the wrapper that will be used for all inputs with specified type.
  # https://github.com/plataformatec/simple_form#available-input-types-and-defaults-for-each-column-type
  config.wrapper_mappings = { text: :materialize_text_area,
                              string: :materialize_string,
                              email: :materialize_string,
                              tel: :materialize_string,
                              number: :materialize_string,
                              integer: :materialize_string,
                              decimal: :materialize_string,
                              date: :materialize_date,
                              check_boxes: :materialize_multiple,
                              radio_buttons: :materialize_multiple,
                              switch: :material_checkbox,
                              file: :materialize_file_input,
                              password: :materialize_string
                              # boolean: :horizontal_boolean
  }

  # Namespaces where SimpleForm should look for custom input classes that
  # override default inputs.
  # config.custom_inputs_namespaces << "CustomInputs"

  # Default priority for time_zone inputs.
  # config.time_zone_priority = nil

  # Default priority for country inputs.
  # config.country_priority = nil

  # When false, do not use translations for labels.
  # config.translate_labels = true

  # Automatically discover new inputs in Rails' autoload path.
  # config.inputs_discovery = true

  # Cache SimpleForm inputs discovery
  # config.cache_discovery = !Rails.env.development?

  # Default class for inputs
  # config.input_class = nil

  # Define the default class of the input wrapper of the boolean input.
  config.boolean_label_class = 'checkbox'

  # .checkbox
  #   = f.check_box :remember_me
  #   = f.label :remember_me


  # config.wrappers :radio_and_checkboxes, tag: 'div', class: 'row' do |b|
  #   b.use :html5
  #   b.optional :readonly

  #   b.wrapper :container_wrapper, tag: 'div', class: 'small-offset-3 small-9 columns' do |ba|
  #     ba.wrapper :tag => 'label', :class => 'checkbox' do |bb|
  #       bb.use :input
  #       bb.use :label_text
  #     end

  #     ba.use :error, wrap_with: { tag: :small, class: :error }
  #     # ba.use :hint,  wrap_with: { tag: :span, class: :hint }
  #   end
  # end

  # Defines if the default input wrapper class should be included in radio
  # collection wrappers.
  # config.include_default_input_wrapper_class = true

  # Defines which i18n scope will be used in Simple Form.
  # config.i18n_scope = 'simple_form'
end
