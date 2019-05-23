require 'digest'

namespace :kube do
  task :update_config do

    apply! "configmap.yml"

    config_hash = Digest::SHA2.hexdigest %x[kubectl get cm/refsheet-prod -oyaml]

    %w[refsheet-prod refsheet-prod-worker].each do |deployment|
      config = ".kubernetes/#{deployment}.yml"
      sh "yq", "w", "-i", config, "spec.template.metadata.annotations.configHash", config_hash
      apply! deployment + '.yml'
    end
  end

  def apply!(config_file)
    kd = ".kubernetes/" + config_file
    sh "kubectl", "apply", "-f", kd
  end
end