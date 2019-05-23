# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum, this matches the default thread size of Active Record.
#
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests, default is 3000.
#
port        ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
rails_env = ENV.fetch("RAILS_ENV") { "development" }
environment rails_env

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory. If you use this option
# you need to make sure to reconnect any threads in the `on_worker_boot`
# block.
#
preload_app!

# The code in the `on_worker_boot` will be called if you are using
# clustered mode by specifying a number of `workers`. After each worker
# process is booted this block will be run, if you are using `preload_app!`
# option you will want to use this block to reconnect to any threads
# or connections that may have been created at application boot, Ruby
# cannot share connections between processes.
#
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  SemanticLogger.reopen
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

if rails_env == 'development'
  key_file = 'config/certs/localhost.key'
  crt_file = 'config/certs/localhost.crt'

  unless File.exist?(key_file) && File.exist?(crt_file)
    def generate_root_cert(root_key)
      root_ca = OpenSSL::X509::Certificate.new
      root_ca.version = 2 # cf. RFC 5280 - to make it a "v3" certificate
      root_ca.serial = 0x0
      root_ca.subject = OpenSSL::X509::Name.parse "/C=BE/O=A1/OU=A/CN=dev.refsheet.net"
      root_ca.issuer = root_ca.subject # root CA's are "self-signed"
      root_ca.public_key = root_key.public_key
      root_ca.not_before = Time.now
      root_ca.not_after = root_ca.not_before + 2 * 365 * 24 * 60 * 60 # 2 years validity

      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = root_ca
      ef.issuer_certificate = root_ca
      root_ca.add_extension(ef.create_extension("basicConstraints","CA:TRUE",true))
      root_ca.add_extension(ef.create_extension("keyUsage","keyCertSign, cRLSign", true))
      root_ca.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
      root_ca.add_extension(ef.create_extension("authorityKeyIdentifier","keyid:always",false))
      root_ca.add_extension(ef.create_extension("subjectAltName","DNS:dev.refsheet.net,IP:192.168.17.134",false))

      root_ca.sign(root_key, OpenSSL::Digest::SHA256.new)
      root_ca
    end

    if File.exists?(key_file)
      file = File.new(key_file, 'rb')
      root_key = OpenSSL::PKey::RSA.new file.read
    else
      root_key = OpenSSL::PKey::RSA.new(2048)
      file = File.new(key_file, "wb")
      file.write(root_key)
      file.close
    end

    root_cert = generate_root_cert(root_key)

    file = File.new(crt_file, "wb")
    file.write(root_cert)
    file.close
  end

  ssl_bind '0.0.0.0', '8443', {
      key: key_file,
      cert: crt_file
  }
end

# before_fork do
#   require 'puma_worker_killer'
#   PumaWorkerKiller.enable_rolling_restart # Default is every 6 hours
# end
