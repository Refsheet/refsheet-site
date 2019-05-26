require 'digest'

namespace :kube do
  task :update_config do
    apply! "configmap.yml"

    # Fetch update values:
    config_hash = Digest::SHA2.hexdigest %x[kubectl get cm/refsheet-prod -oyaml]
    latest_image = %x[kubectl get deployment refsheet-prod -o=jsonpath='{$.spec.template.spec.containers[:1].image}']

    # Deployments:
    %w[refsheet-prod refsheet-prod-worker].each do |deployment|
      file = ".kubernetes/#{deployment}.yml"
      sh "yq", "w", "-i", file, "spec.template.metadata.annotations.configHash", config_hash
      sh "yq", "w", "-i", file, "spec.template.spec.containers[*].image", latest_image
      apply! file
    end

    # Jobs:
    Dir['.kubernetes/jobs/*.yml'].each do |file|
      sh "yq", "w", "-i", file, "spec.jobTemplate.spec.template.metadata.annotations.configHash", config_hash
      sh "yq", "q", "-i", file, "spec.jobTemplate.spec.template.spec.containers[*].image", latest_image
      apply! file
    end
  end

  def apply!(config_file)
    config_file = ".kubernetes/" + config_file unless config_file =~ /^\.kubernetes/
    sh "kubectl", "apply", "-f", config_file
  end
end