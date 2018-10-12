RSpec.configure do |config|
  config.before(:each) do |ex|
    unless ex.metadata[:paperclip]
      allow_any_instance_of(DelayedPaperclip::Attachment).to receive(:save).and_return(true)
      allow_any_instance_of(Paperclip::Meta::Attachment).to receive(:post_process_styles).and_return(nil)
    end
  end
end
