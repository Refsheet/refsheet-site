class ConvertPaperclipJob < ApplicationJob
  def perform(record, paperclip_from, active_storage_to)
    file_name = record.send(paperclip_from.to_s + "_file_name")
    attachment = record.send(paperclip_from)
    return unless attachment.exists?

    puts "Downloading old attachment..."
    split = file_name.split('.')
    tmp = Tempfile.new([split[0..-2].join('.'),"."+split[-1]])
    record.send(paperclip_from).copy_to_local_file(:original, tmp)

    puts "Uploading new attachment..."
    record.send(active_storage_to).attach(io: tmp, filename: file_name)
    puts record.save!.inspect

    puts "Updated #{record}"
  end
end