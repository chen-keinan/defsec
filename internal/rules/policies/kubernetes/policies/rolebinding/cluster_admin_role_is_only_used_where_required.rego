# METADATA
# title: "Ensure that the cluster-admin role is only used where required"
# description: "The RBAC role cluster-admin provides wide-ranging powers over the environment and should be used only where and when needed."
# scope: package
# schemas:
# - input: schema.input
# related_resources:
# - https://kubernetes.io/docs/concepts/security/rbac-good-practices/
# custom:
#   id: KSV111
#   avd_id: AVD-KSV-0111
#   severity: MEDIUM
#   short_code: cluster-admin0-role-only-used-where-required"
#   recommended_action: "Identify all clusterrolebindings to the cluster-admin role. Check if they are used and if they need this role or if they could use a role with fewer privileges."
#   input:
#     selector:
#     - type: kubernetes
package builtin.kubernetes.KSV111

import data.lib.kubernetes
import data.lib.utils

roleBindings := ["clusterrolebinding", "rolebinding"]

clusterAdminRoleInUse(bindingInput) {
	lower(bindingInput.kind) == roleBindings[_]
	bindingInput.roleRef.name == "cluster-admin"
	not startswith(bindingInput.metadata.name, "system:")
}

deny[res] {
	clusterAdminRoleInUse(input)
	msg := sprintf("%s '%s' with role 'cluster-admin' should be used only when required", [input.kind, input.metadata.name])
	res := result.new(msg, input.roleRef)
}
