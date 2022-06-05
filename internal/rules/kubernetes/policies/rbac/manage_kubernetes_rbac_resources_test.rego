package builtin.kubernetes.KSV050

itest_manage_K8s_RBAC_resources_create {
	r := deny with input as {
		"apiVersion": "rbac.authorization.k8s.io/v1",
		"kind": "Role",
		"metadata": {
			"namespace": "default",
			"name": "pod-reader",
		},
		"rules": [{
			"apiGroups": ["*"],
			"resources": ["role"],
			"verbs": ["create"],
		}],
	}

	count(r) > 0
}

itest_manage_K8s_RBAC_resources_create {
	r := deny with input as {
		"apiVersion": "rbac.authorization.k8s.io/v1",
		"kind": "Role",
		"metadata": {
			"namespace": "default",
			"name": "pod-reader",
		},
		"rules": [{
			"apiGroups": ["*"],
			"resources": ["role"],
			"verbs": ["update"],
		}],
	}

	count(r) > 0
}

itest_manage_K8s_RBAC_resources_delete {
	r := deny with input as {
		"apiVersion": "rbac.authorization.k8s.io/v1",
		"kind": "Role",
		"metadata": {
			"namespace": "default",
			"name": "pod-reader",
		},
		"rules": [{
			"apiGroups": ["*"],
			"resources": ["role"],
			"verbs": ["update"],
		}],
	}

	count(r) > 0
}

itest_manage_K8s_RBAC_resources_deletecollection {
	r := deny with input as {
		"apiVersion": "rbac.authorization.k8s.io/v1",
		"kind": "Role",
		"metadata": {
			"namespace": "default",
			"name": "pod-reader",
		},
		"rules": [{
			"apiGroups": ["*"],
			"resources": ["rolebindings"],
			"verbs": ["deletecollection"],
		}],
	}

	count(r) > 0
}

itest_manage_K8s_RBAC_resources_deletecollection {
	r := deny with input as {
		"apiVersion": "rbac.authorization.k8s.io/v1",
		"kind": "Role",
		"metadata": {
			"namespace": "default",
			"name": "pod-reader",
		},
		"rules": [{
			"apiGroups": ["*"],
			"resources": ["rolebindings"],
			"verbs": ["impersonate"],
		}],
	}

	count(r) > 0
}

itest_manage_K8s_RBAC_resources_all {
	r := deny with input as {
		"apiVersion": "rbac.authorization.k8s.io/v1",
		"kind": "Role",
		"metadata": {
			"namespace": "default",
			"name": "pod-reader",
		},
		"rules": [{
			"apiGroups": ["*"],
			"resources": ["rolebindings"],
			"verbs": ["*"],
		}],
	}

	count(r) > 0
}

itest_manage_K8s_RBAC_resources_all {
	r := deny with input as {
		"apiVersion": "rbac.authorization.k8s.io/v1",
		"kind": "Role",
		"metadata": {
			"namespace": "default",
			"name": "pod-reader",
		},
		"rules": [{
			"apiGroups": ["*"],
			"resources": ["rolebindings1"],
			"verbs": ["*"],
		}],
	}

	count(r) == 0
}
