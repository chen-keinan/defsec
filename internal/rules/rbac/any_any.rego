package builtin.kubernetes.KSV044

import data.lib.kubernetes
import data.lib.result
import data.lib.utils

__rego_metadata__ := {
	"id": "KSV044",
	"avd_id": "AVD-KSV-0044",
	"title": "No wildcard verb and resource roles",
	"short_code": "no-wildcard-verb-resource-role",
	"severity": "CRITICAL",
	"description": "Check whether role permits wildcard verb on wildcard resource",
	"recommended_actions": "Create a role which does not permit wildcard verb on wildcard resource",
	"url": "https://kubernetes.io/docs/concepts/security/rbac-good-practices/",
}

__rego_input__ := {
	"combine": false,
	"selector": [{"type": "rbac"}],
}

readKinds := ["Role", "ClusterRole"]

anyAnyResource {
	input.kind == readKinds[_]
	input.rules[_].apiGroups[_] == "*"
	input.rules[_].resources[_] == "*"
	input.rules[_].verbs[_] == "*"
}

deny[res] {
	anyAnyResource
	msg := "Role permits wildcard verb on wildcard resource"
	res := result.new(msg, input)
}
