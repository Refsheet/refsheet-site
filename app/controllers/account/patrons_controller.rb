class Account::PatronsController < AccountController
  def update
    @patron = Patreon::Patron.find_by 'LOWER(email) = ?', patron_params[:lookup_email]&.downcase

    if !@patron
      render json: { errors: { lookup_email: ["doesn't match a known patron."] } }, status: :not_found

    elsif @patron.user_id.present?
      render json: { errors: { lookup_email: ["claimed by another Refsheet.net account."] } }, status: :bad_request

    else
      @patron.initiate_link! current_user
      head :ok
    end
  end

  def link
    @patron = Patreon::Patron.find_by 'LOWER(email) = ?', params[:lookup_email]&.downcase

    if !@patron
      flash = { error: 'Patron email not found.' }

    elsif @patron.user_id.present?
      flash = { error: 'Patron already linked to account.' }

    elsif @patron.pending_user_id != current_user.id
      flash = { error: 'Patron can not be linked to this account.' }

    elsif !@patron.auth_code? params[:auth]
      flash = { error: 'Invalid auth code.' }

    else
      @patron.update user: current_user
      flash = { notice: 'Patron linked successfully!' }
    end

    redirect_to account_support_patron_path, flash: flash
  end

  private

  def patron_params
    params.require(:patron)
          .permit(
              :lookup_email
          )
  end
end
