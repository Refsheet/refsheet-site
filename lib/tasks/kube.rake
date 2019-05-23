require 'digest'

namespace :kube do
  task :update_config do
    apply! "configmap.yml"

    config_hash = Digest::SHA2.hexdigest %x[kubectl get cm/refsheet-prod -oyaml]
    latest_image = %x[kubectl get deployment refsheet-prod -o=jsonpath='{$.spec.template.spec.containers[:1].image}']

    %w[refsheet-prod refsheet-prod-worker].each do |deployment|
      config = ".kubernetes/#{deployment}.yml"
      sh "yq", "w", "-i", config, "spec.template.metadata.annotations.configHash", config_hash
      sh "yq", "w", "-i", config, "spec.template.spec.containers[*].image", latest_image
      apply! deployment + '.yml'
    end
  end

  def apply!(config_file)
    kd = ".kubernetes/" + config_file
    sh "kubectl", "apply", "-f", kd
  end
end