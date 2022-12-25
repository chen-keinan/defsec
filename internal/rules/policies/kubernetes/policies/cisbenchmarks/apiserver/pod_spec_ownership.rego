# METADATA
# title: "Ensure that the API server pod specification file ownership is set to root:root"
# description: "Ensure that the API server pod specification file ownership is set to root:root."
# scope: package
# schemas:
# - input: schema["input"]
# related_resources:
# - https://www.cisecurity.org/benchmark/kubernetes
# custom:
#   id: KCV0049
#   avd_id: AVD-KCV-0049
#   severity: HIGH
#   short_code: ensure-api-server-pod-specification-ownership-set-root:root.
#   recommended_action: "Change the API server pod specification file /etc/kubernetes/manifests/kube-apiserver.yaml ownership to root:root"
#   input:
#     selector:
#     - type: kubernetes
package builtin.kubernetes.KCV0049

import data.lib.kubernetes

validate_spec_ownership(sp) := {"kubeAPIServerSpecFileOwnership": ownership} {
	sp.kind == "Nodeinfo"
	sp.type == "master"
	ownership := sp.info.kubeAPIServerSpecFileOwnership[_]
	not ownership == "root:root"
}

deny[res] {
	output := validate_spec_ownership(input)
	msg := "Ensure that the API server pod specification file ownership is set to root:root"
	res := result.new(msg, output)
}
