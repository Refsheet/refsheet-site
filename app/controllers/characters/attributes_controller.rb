class Characters::AttributesController < AccountController
  before_action :get_character

  def create
    if attribute_params[:id].blank?
      Rails.logger.info 'Creating new attribute.'
      @character.custom_attributes.push attribute_params.merge(id: SecureRandom.hex).to_h.symbolize_keys

    elsif attribute_params[:rowOrderPosition].present?
      Rails.logger.info 'Sorting attribute.'

      with @character.custom_attributes.index { |i| i[:id].downcase == attribute_params[:id].downcase } do |index|
        el = @character.custom_attributes.slice! index
        @character.custom_attributes.insert attribute_params[:rowOrderPosition].to_i, el
      end

    else
      Rails.logger.info 'Updating attribute.'
      
      @character.custom_attributes.collect! do |attr|
        if attr[:id].downcase == attribute_params[:id].downcase
          attribute_params.to_h.symbolize_keys
        else
          attr
        end
      end
    end

    @character.save
    respond_with @character, location: nil, json: @character, serializer: CharacterSerializer
  end

  def destroy
    @character.custom_attributes.reject! { |a| a[:id].downcase == params[:id].downcase }
    @character.save
    respond_with @character, location: nil, json: @character, serializer: CharacterSerializer
  end

  private

  def get_character
    @character = current_user.characters.lookup! params[:character_id]
    @character.custom_attributes ||= []
  end
  
  def attribute_params
    params.require(:custom_attributes).permit(:id, :name, :value, :rowOrderPosition)
  end
end
