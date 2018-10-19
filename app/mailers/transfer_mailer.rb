class TransferMailer < ApplicationMailer
  def incoming(transfer_id)
    @transfer = Transfer.find transfer_id
    @user = @transfer.destination
    @preheader = "#{@transfer.sender.name} would like to transfer #{@transfer.character.name} to you!"

    mail to: @user.email_to,
         subject: "[Refsheet.net] Character transfer request from #{@transfer.sender.name}"
  end

  def accepted(transfer_id)
    @transfer = Transfer.find transfer_id
    @user = @transfer.sender
    @preheader = "#{@transfer.destination.name} has accepted your transfer of #{@transfer.character.name}."

    mail to: @user.email_to,
         subject: "[Refsheet.net] #{@transfer.character.name} transferred to #{@transfer.destination.name}"
  end

  def rejected(transfer_id)
    @transfer = Transfer.find transfer_id
    @user = @transfer.sender
    @preheader = "#{@transfer.destination.name} does not seem to want #{@transfer.character.name}."

    mail to: @user.email_to,
         subject: "[Refsheet.net] Transfer of #{@transfer.character.name} rejected by #{@transfer.destination.name}"
  end
end
