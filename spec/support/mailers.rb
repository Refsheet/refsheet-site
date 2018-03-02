def expect_live_mailer(mailer_klass, mailer_method, *args)
  args.push any_args if args.empty?
  expect(mailer_klass).to receive(mailer_method).at_least(:once).and_call_original
end

def expect_mailer(mailer_klass, mailer_method, *args, &block)
  args.push any_args if args.empty?

  match = receive_message_chain(mailer_method, :deliver_later)
              .with(*args)
              .with(no_args)

  match = match.instance_exec(&block) if block_given?
  expect(mailer_klass).to match
end

def expect_mailer_now(mailer_klass, mailer_method, *args)
  args.push any_args if args.empty?

  expect(mailer_klass).to receive_message_chain(mailer_method, :deliver_now)
                              .with(*args)
                              .with(no_args)
end
